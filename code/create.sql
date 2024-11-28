------------------- ResourceLimit table -------------------
CREATE TABLE ResourceLimit (
    memberType VARCHAR2(20) PRIMARY KEY CHECK (memberType IN ('Student', 'Staff')),
    resourceLimit INT CHECK (resourceLimit >= 0) -- Ensures resourceLimit is non-negative
);






------------------- Member table -------------------
CREATE TABLE Member (
    memberId VARCHAR2(100) PRIMARY KEY,
    memberName VARCHAR2(100) NOT NULL,
    email VARCHAR2(100) UNIQUE NOT NULL,
    DOB DATE,
    memberType VARCHAR2(20),
    totalFine NUMBER DEFAULT 0 CHECK (totalFine >= 0), 
    totalLoan NUMBER DEFAULT 0 CHECK (totalLoan >= 0),
    reservationFailed NUMBER DEFAULT 0 CHECK (reservationFailed >= 0),
    FOREIGN KEY (memberType) REFERENCES ResourceLimit(memberType)
);

/* Constrain for DOB */
CREATE OR REPLACE TRIGGER trg_check_dob
BEFORE INSERT OR UPDATE ON Member
FOR EACH ROW
BEGIN
    IF :NEW.DOB >= SYSDATE THEN
        RAISE_APPLICATION_ERROR(-20001, 'Date of Birth must be in the past.');
    END IF;
END;
/





------------------- Location table -------------------
CREATE TABLE Location (
    locationId VARCHAR2(100) PRIMARY KEY,
    floorNumber INT CHECK (floorNumber <= 3),
    shelfNumber INT,
    sectionName VARCHAR2(50),
    classNumber VARCHAR2(50) UNIQUE
);





------------------- Resources table -------------------
CREATE TABLE Resources (
    resourceId VARCHAR2(100) PRIMARY KEY,
    resourceType VARCHAR2(50) CHECK (resourceType IN ('book', 'eBook', 'device')),
    locationId VARCHAR2(100),
    borrowRule VARCHAR2(50) CHECK (borrowRule IN ('normal', 'short', 'onSite')),
    digitalCopy INT CHECK (digitalCopy >= 0),
	availability NUMBER(1) DEFAULT 1 CHECK (availability IN (0, 1)), -- 0 for unavailable, 1 for available
    classNumber VARCHAR2(50),
    resourceTitle VARCHAR2(200) NOT NULL,
    FOREIGN KEY (locationId) REFERENCES Location(locationId) ON DELETE CASCADE,  -- Cascades delete for locationId
    FOREIGN KEY (classNumber) REFERENCES Location(classNumber) ON DELETE CASCADE  -- Cascades delete for classNumber
);

/* Constrain for resources type */

-- Trigger for when a new eBook resource is added
CREATE OR REPLACE TRIGGER trg_check_ebook
BEFORE INSERT ON Resources
FOR EACH ROW
BEGIN
    IF :NEW.resourceType = 'eBook' THEN
        -- Ensure digitalCopy is not NULL and locationId is NULL for eBooks
        IF :NEW.digitalCopy IS NULL THEN
            RAISE_APPLICATION_ERROR(-20002, 'Digital Copy must not be NULL for eBooks.');
        END IF;
        IF :NEW.locationId IS NOT NULL THEN
            RAISE_APPLICATION_ERROR(-20003, 'LocationId must be NULL for eBooks.');
        END IF;
    END IF;
END;
/

-- Trigger for when a new book resource is added
CREATE OR REPLACE TRIGGER trg_check_book
BEFORE INSERT ON Resources
FOR EACH ROW
BEGIN
    IF :NEW.resourceType = 'book' THEN
        -- Ensure digitalCopy is NULL and classNumber is not NULL for books
        IF :NEW.digitalCopy IS NOT NULL THEN
            RAISE_APPLICATION_ERROR(-20004, 'Digital Copy must be NULL for books.');
        END IF;
        IF :NEW.classNumber IS NULL THEN
            RAISE_APPLICATION_ERROR(-20005, 'ClassNumber must not be NULL for books.');
        END IF;
    END IF;
END;
/

-- Trigger for when a new device resource is added
CREATE OR REPLACE TRIGGER trg_check_device
BEFORE INSERT ON Resources
FOR EACH ROW
BEGIN
    IF :NEW.resourceType = 'device' THEN
        -- Ensure digitalCopy is NULL and classNumber is NULL for devices
        IF :NEW.digitalCopy IS NOT NULL THEN
            RAISE_APPLICATION_ERROR(-20006, 'Digital Copy must be NULL for devices.');
        END IF;
        IF :NEW.classNumber IS NOT NULL THEN
            RAISE_APPLICATION_ERROR(-20007, 'ClassNumber must be NULL for devices.');
        END IF;
    END IF;
END;
/






------------------- Loan table -------------------
CREATE TABLE Loan (
    loanId VARCHAR2(100) PRIMARY KEY,
    memberId VARCHAR2(100) NOT NULL,
    resourceId VARCHAR2(100) NOT NULL,
    loanDate DATE DEFAULT SYSDATE,
    dueDate DATE,
    returnDate DATE,
    FOREIGN KEY (memberId) REFERENCES Member(memberId) ON DELETE CASCADE,
    FOREIGN KEY (resourceId) REFERENCES Resources(resourceId) ON DELETE CASCADE
);


/* Trigger to handle loan creation logic(borrow resource) */
CREATE OR REPLACE TRIGGER trg_loan_insert
BEFORE INSERT ON Loan
FOR EACH ROW
DECLARE
    member_eligibility NUMBER;
    resource_availability NUMBER;
    borrow_rule VARCHAR2(20);
BEGIN
    -- Step 1: Check member eligibility
    SELECT 
        CASE 
            WHEN m.totalFine <= 10 AND m.totalLoan <= rl.resourceLimit THEN 1
            ELSE 0
        END
    INTO member_eligibility
    FROM 
        Member m
    JOIN 
        ResourceLimit rl ON m.memberType = rl.memberType
    WHERE 
        m.memberId = :NEW.memberId;

    IF member_eligibility = 0 THEN
        RAISE_APPLICATION_ERROR(-20010, 'Member is not eligible to borrow this resource.');
    END IF;

    -- Step 2: Check resource availability and borrow rule
    SELECT 
        r.availability, 
        r.borrowRule
    INTO 
        resource_availability, 
        borrow_rule
    FROM 
        Resources r
    WHERE 
        r.resourceId = :NEW.resourceId;

    IF resource_availability = 0 THEN
        RAISE_APPLICATION_ERROR(-20011, 'Resource is not available for borrowing.');
    END IF;

    -- Step 3: Determine dueDate based on borrowRule
    IF borrow_rule = 'normal' THEN
        :NEW.dueDate := SYSDATE + 21;
    ELSIF borrow_rule = 'short' THEN
        :NEW.dueDate := SYSDATE + 3;
    ELSIF borrow_rule = 'onSite' THEN
        RAISE_APPLICATION_ERROR(-20012, 'Resource should only be used on site.');
    ELSE
        :NEW.dueDate := SYSDATE; -- Default case
    END IF;

    -- Set loanDate to the current date
    :NEW.loanDate := SYSDATE;

    -- Step 4: Update resource availability and member's totalLoan
    UPDATE Resources
    SET availability = 0
    WHERE resourceId = :NEW.resourceId;

    UPDATE Member
    SET totalLoan = totalLoan + 1
    WHERE memberId = :NEW.memberId;
END;
/


/* Trigger to handle loan update logic (return resource) */
CREATE OR REPLACE TRIGGER trg_loan_update
BEFORE UPDATE OF returnDate ON Loan
FOR EACH ROW
DECLARE
    v_dueDate DATE;
    v_returnDate DATE;
    v_fine NUMBER;
BEGIN
    IF :OLD.returnDate IS NOT NULL THEN
        RAISE_APPLICATION_ERROR(-20013, 'The resource is already returned.');
    END IF;

    -- Step 1: Fetch the dueDate and returnDate for the loan
    v_dueDate := :OLD.dueDate;
    v_returnDate := :NEW.returnDate;

    -- Step 2: Calculate the fine (if the returnDate is after the dueDate)
    IF v_returnDate > v_dueDate THEN
        v_fine := v_returnDate - v_dueDate;
    ELSE
        v_fine := 0; -- No fine if returned on or before dueDate
    END IF;

    -- Step 3: Update the Member's totalFine and totalLoan
    UPDATE Member
    SET 
        totalFine = totalFine + v_fine, -- Add calculated fine to the totalFine
        totalLoan = totalLoan - 1       -- Decrement the totalLoan
    WHERE 
        memberId = :OLD.memberId;

    -- Step 4: Update the Resource's availability
    UPDATE Resources
    SET 
        availability = 1 -- Set the resource as available
    WHERE 
        resourceId = :OLD.resourceId;
END;
/






------------------- Reservation table -------------------
CREATE TABLE Reservation (
    reservationId VARCHAR2(100) PRIMARY KEY,
    memberId VARCHAR2(100) NOT NULL,
    resourceId VARCHAR2(100) NOT NULL,
    reservationDate DATE DEFAULT SYSDATE,
    expirationDate DATE,
    FOREIGN KEY (memberId) REFERENCES Member(memberId) ON DELETE CASCADE,
    FOREIGN KEY (resourceId) REFERENCES Resources(resourceId) ON DELETE CASCADE
);

/* insert into reservation simulate a member reserve a resource */
CREATE OR REPLACE TRIGGER trg_reservation_insert
BEFORE INSERT ON Reservation
FOR EACH ROW
DECLARE
    v_memberFine NUMBER;
    v_memberFails NUMBER;
BEGIN
    -- Step 1: Check member's totalFine and reservationFailed
    SELECT totalFine, reservationFailed
    INTO v_memberFine, v_memberFails
    FROM Member
    WHERE memberId = :NEW.memberId;

    -- Step 2: Raise an error if member eligibility conditions are not met
    IF v_memberFine > 10 THEN
        RAISE_APPLICATION_ERROR(-20014, 'Member has too much fine to make a reservation.');
    ELSIF v_memberFails >= 3 THEN
        RAISE_APPLICATION_ERROR(-20015, 'Member has exceeded the allowed number of failed reservations.');
    END IF;
END;
/

