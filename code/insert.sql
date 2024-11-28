------------------- Insert sample data -------------------

/* 1. Inserting a row into the resourceLimit which is mentioned in the description */
INSERT INTO ResourceLimit (memberType, resourceLimit)
VALUES
('Student', 5);

INSERT INTO ResourceLimit (memberType, resourceLimit)
VALUES
('Staff', 10);

/* 2. Inserting a row into the Member table is triggered when a new member is added to the system */

-- Inserting 5 rows into the Member table
INSERT INTO Member (memberId, memberName, email, DOB, memberType, totalFine, totalLoan, reservationFailed)
VALUES 
('082413d4-7897-4ef9-b69e-c7d65514d6c4', 'Alan Li', 'ec24279@qmul.ac.uk', TO_DATE('2001/10/23', 'YYYY/MM/DD'), 'Student', DEFAULT, DEFAULT, DEFAULT);

INSERT INTO Member (memberId, memberName, email, DOB, memberType, totalFine, totalLoan, reservationFailed)
VALUES 
('9a703c27-bb79-4b4f-b9c2-2b5044f0b40b', 'Maria Zhang', 'maria.zhang@qmul.ac.uk', TO_DATE('1999/04/15', 'YYYY/MM/DD'), 'Staff', DEFAULT, DEFAULT, DEFAULT);

INSERT INTO Member (memberId, memberName, email, DOB, memberType, totalFine, totalLoan, reservationFailed)
VALUES 
('b1c3fc3a-1f13-4db5-9b6e-531458773c96', 'John Doe', 'johndoe@mail.com', TO_DATE('1997/02/10', 'YYYY/MM/DD'), 'Student', DEFAULT, DEFAULT, DEFAULT);

INSERT INTO Member (memberId, memberName, email, DOB, memberType, totalFine, totalLoan, reservationFailed)
VALUES 
('d1a0ac9a-3fbc-4664-b5ed-4d4220d517d7', 'Sophia Chen', 'sophia.chen@qmul.ac.uk', TO_DATE('2000/11/05', 'YYYY/MM/DD'), 'Student', DEFAULT, DEFAULT, DEFAULT);

INSERT INTO Member (memberId, memberName, email, DOB, memberType, totalFine, totalLoan, reservationFailed)
VALUES 
('a4f5eb5e-37f2-4b6e-baa2-713a3780d6e2', 'James Li', 'james.li@qmul.ac.uk', TO_DATE('1998/07/22', 'YYYY/MM/DD'), 'Staff', DEFAULT, DEFAULT, DEFAULT);

-- Inserting invalid rows into the Member table
-- INSERT INTO Member (memberId, memberName, email, DOB, memberType, totalFine, totalLoan, reservationFailed)
-- VALUES (
--     '12345678-1234-1234-1234-1234567890ab', -- Invalid memberId
--     'Invalid User',                         -- Name
--     'invalid.user@example.com',             -- Email
--     TO_DATE('2025-01-01', 'YYYY-MM-DD'),    -- Invalid DOB (future date, violates the trigger)
--     'Student',                              -- memberType
--     0,                                      -- totalFine
--     0,                                      -- totalLoan
--     0                                       -- reservationFailed
-- );


/* 3. Inserting some rows into the Location table */

-- Location 1: Floor number 1
INSERT INTO Location (locationId, floorNumber, shelfNumber, sectionName, classNumber)
VALUES ('4e8f9b5a-d684-42f2-90e3-05d679b8d87f', 1, 1, 'Computer Science', 'C001');

-- Location 2: Floor number 2
INSERT INTO Location (locationId, floorNumber, shelfNumber, sectionName, classNumber)
VALUES ('d91f9fbc-3483-4aeb-a9d5-b1aeb5e8589a', 2, 2, 'Mathematics', 'C002');

-- Location 3: Floor number 3
INSERT INTO Location (locationId, floorNumber, shelfNumber, sectionName, classNumber)
VALUES ('b77b2c66-cf66-4b33-bec4-524d54996785', 3, 3, 'Physics', 'C003');

-- Location 4: Floor number 1
INSERT INTO Location (locationId, floorNumber, shelfNumber, sectionName, classNumber)
VALUES ('f51c29fe-cf52-4386-b01a-9352b232e759', 1, 2, 'Chemistry', 'C004');

-- Location 5: Floor number 2
INSERT INTO Location (locationId, floorNumber, shelfNumber, sectionName, classNumber)
VALUES ('9c9a1cc5-9d0a-4e1f-87cd-56e824f8d77e', 2, 5, 'Biology', 'C005');

-- Inserting invalid rows into the Location table

/* 4. Inserting some rows into the Resources table */
-- Resource 1: Book
INSERT INTO Resources (resourceId, resourceType, locationId, borrowRule, digitalCopy, availability, classNumber, resourceTitle)
VALUES ('da72a314-d592-432b-920b-8bfc5a9f0a3e', 'book', '4e8f9b5a-d684-42f2-90e3-05d679b8d87f', 'normal', NULL, 1, 'C001', 'Introduction to Computer Science');

-- Resource 2: eBook
INSERT INTO Resources (resourceId, resourceType, locationId, borrowRule, digitalCopy, availability, classNumber, resourceTitle)
VALUES ('b213c1e5-d899-41c0-b0c6-bb7b3a3347b4', 'eBook', NULL, 'normal', 1, 1, 'C001', 'Data Structures and Algorithms');

-- Resource 3: Device
INSERT INTO Resources (resourceId, resourceType, locationId, borrowRule, digitalCopy, availability, classNumber, resourceTitle)
VALUES ('d6f8a699-7087-4f77-b490-1a70c3a99125', 'device', '4e8f9b5a-d684-42f2-90e3-05d679b8d87f', 'onSite', NULL, 1, NULL, 'Laptop for Programming');

-- Resource 4: Book
INSERT INTO Resources (resourceId, resourceType, locationId, borrowRule, digitalCopy, availability, classNumber, resourceTitle)
VALUES ('a846cbd1-b13f-4d50-9283-ff8dfe5f39db', 'book', 'd91f9fbc-3483-4aeb-a9d5-b1aeb5e8589a', 'short', NULL, 1, 'C002', 'Advanced Mathematics');

-- Resource 5: eBook
INSERT INTO Resources (resourceId, resourceType, locationId, borrowRule, digitalCopy, availability, classNumber, resourceTitle)
VALUES ('679b9a02-d568-4c0f-9c57-75c3f21e9c64', 'eBook', NULL, 'normal', 1, 1, 'C001', 'Machine Learning Basics');

-- Resource 6: Device
INSERT INTO Resources (resourceId, resourceType, locationId, borrowRule, digitalCopy, availability, classNumber, resourceTitle)
VALUES ('cf3fd2b0-4c71-4f95-9253-f325fb15b7ac', 'device', 'f51c29fe-cf52-4386-b01a-9352b232e759', 'onSite', NULL, 1, NULL, 'Projector for Class');

-- Resource 7: Book
INSERT INTO Resources (resourceId, resourceType, locationId, borrowRule, digitalCopy, availability, classNumber, resourceTitle)
VALUES ('e2d3941c-8d5b-41b9-85b6-cc8e5f74330f', 'book', 'b77b2c66-cf66-4b33-bec4-524d54996785', 'normal', NULL, 1, 'C003', 'Fundamentals of Physics');

-- Resource 8: eBook
INSERT INTO Resources (resourceId, resourceType, locationId, borrowRule, digitalCopy, availability, classNumber, resourceTitle)
VALUES ('fab39c56-7b82-49eb-83e8-5a3c733842bb', 'eBook', NULL, 'normal', 1, 1, 'C005', 'Introduction to Psychology');

-- Resource 9: Device
INSERT INTO Resources (resourceId, resourceType, locationId, borrowRule, digitalCopy, availability, classNumber, resourceTitle)
VALUES ('83d3f2cc-1c90-4873-87c9-6b48a13c78fe', 'device', '9c9a1cc5-9d0a-4e1f-87cd-56e824f8d77e', 'onSite', NULL, 1, NULL, 'Tablet for Reading');


/* 5. Inserting some rows into the Loan table to simulate some user borrow a resource */

-- Alan Li borrowing Advanced Mathematics
INSERT INTO Loan (loanId, memberId, resourceId)
VALUES (
    'd6067de1-0b8e-41a8-bf28-6691565ed51c',
    '082413d4-7897-4ef9-b69e-c7d65514d6c4', -- Alan Li's memberId
    'a846cbd1-b13f-4d50-9283-ff8dfe5f39db'  -- ResourceId for Advanced Mathematics
);

-- Maria Zhang borrows Fundamentals of Physics
INSERT INTO Loan (loanId, memberId, resourceId)
VALUES (
    'fe4129d9-96af-4a62-b92c-f512a6a14f1e',
    '9a703c27-bb79-4b4f-b9c2-2b5044f0b40b', -- Maria Zhang's memberId
    'e2d3941c-8d5b-41b9-85b6-cc8e5f74330f'  -- ResourceId for Fundamentals of Physics
);

-- Sophia Chen borrows Data Structures and Algorithms
INSERT INTO Loan (loanId, memberId, resourceId)
VALUES (
    'ee8c993a-5c15-4b9b-b24c-5b7e2ef462df',
    'd1a0ac9a-3fbc-4664-b5ed-4d4220d517d7', -- Sophia Chen's memberId
    'b213c1e5-d899-41c0-b0c6-bb7b3a3347b4'  -- ResourceId for Data Structures and Algorithms
);

-- Alan Li borrows Machine Learning Basics
INSERT INTO Loan (loanId, memberId, resourceId)
VALUES (
    'c9f05635-bfc6-41de-818d-41254e3b872a',
    '082413d4-7897-4ef9-b69e-c7d65514d6c4', -- Alan Li's memberId
    '679b9a02-d568-4c0f-9c57-75c3f21e9c64'  -- ResourceId for Machine Learning Basics
);

-- John Doe borrows Introduction to Psychology
INSERT INTO Loan (loanId, memberId, resourceId)
VALUES (
    '8e5b4e3a-69b6-482c-b3a7-1c1a70de4d3f',
    'b1c3fc3a-1f13-4db5-9b6e-531458773c96', -- John Doe's memberId
    'fab39c56-7b82-49eb-83e8-5a3c733842bb'  -- ResourceId for Introduction to Psychology
);


-- Invalid Input: John Doe borrows Laptop for Programming, but the Laptop should only be used on site.
-- INSERT INTO Loan (loanId, memberId, resourceId)
-- VALUES (
--     '39a74364-f3d7-4b97-a5f1-f4d5e45052dc',
--     'b1c3fc3a-1f13-4db5-9b6e-531458773c96', -- John Doe's memberId
--     'd6f8a699-7087-4f77-b490-1a70c3a99125'  -- ResourceId for Laptop for Programming
-- );

/* 6. Updating rows into the Loan table to simulate some user return a resource */

-- Alan Li returns "Advanced Mathematics" 3 days after the due date
UPDATE Loan
SET returnDate = dueDate + 3
WHERE memberId = '082413d4-7897-4ef9-b69e-c7d65514d6c4' 
  AND resourceId = 'a846cbd1-b13f-4d50-9283-ff8dfe5f39db'
  AND returnDate IS NULL;

-- Maria Zhang returned Fundamentals of Physics 2 days late
UPDATE Loan
SET returnDate = dueDate + 2
WHERE memberId = '9a703c27-bb79-4b4f-b9c2-2b5044f0b40b' 
  AND resourceId = 'e2d3941c-8d5b-41b9-85b6-cc8e5f74330f'
  AND returnDate IS NULL;

-- Sophia Chen returned Data Structures and Algorithms on the due date
UPDATE Loan
SET returnDate = dueDate
WHERE memberId = 'd1a0ac9a-3fbc-4664-b5ed-4d4220d517d7' 
  AND resourceId = 'b213c1e5-d899-41c0-b0c6-bb7b3a3347b4'
  AND returnDate IS NULL;

-- Alan Li returned Machine Learning Basics 3 days late
UPDATE Loan
SET returnDate = dueDate + 3
WHERE memberId = '082413d4-7897-4ef9-b69e-c7d65514d6c4' 
  AND resourceId = '679b9a02-d568-4c0f-9c57-75c3f21e9c64'
  AND returnDate IS NULL;

-- John Doe returned Introduction to Psychology 2 days before the due date
UPDATE Loan
SET returnDate = dueDate - 2
WHERE memberId = 'b1c3fc3a-1f13-4db5-9b6e-531458773c96' 
  AND resourceId = 'fab39c56-7b82-49eb-83e8-5a3c733842bb'
  AND returnDate IS NULL;


/* 7. Some resources is being borrowed and returned again */

INSERT INTO Loan (loanId, memberId, resourceId)
VALUES (
    'c3a0e71c-be6f-495b-a967-a90c17150263',
    '082413d4-7897-4ef9-b69e-c7d65514d6c4', -- Alan Li's memberId
    'a846cbd1-b13f-4d50-9283-ff8dfe5f39db'  -- ResourceId for Advanced Mathematics
);

UPDATE Loan
SET returnDate = dueDate + 5
WHERE memberId = '082413d4-7897-4ef9-b69e-c7d65514d6c4' 
  AND resourceId = 'a846cbd1-b13f-4d50-9283-ff8dfe5f39db'
  AND returnDate IS NULL;

