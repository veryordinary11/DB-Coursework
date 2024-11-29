/* Simple Queries */

-- 1.List all books with the "short" borrow rule.
SELECT resourceId, resourceTitle, borrowRule 
FROM Resources 
WHERE resourceType = 'book' AND borrowRule = 'short';

-- 2.Find all members with fines greater than 10.
SELECT memberId, memberName, totalFine 
FROM Member 
WHERE totalFine > 10;

-- 3.List all resources currently unavailable.
SELECT resourceId, resourceTitle, availability 
FROM Resources 
WHERE availability = 0;

-- 4.Find the location of section 'Computer Science'.
SELECT locationId, floorNumber, shelfNumber, sectionName
FROM Location
Where sectionName = 'Computer Science';


/* Intermediate Queries */

-- 1. Find member who borrowed a specific book.
SELECT m.memberId, m.memberName, l.resourceId 
FROM Member m
JOIN Loan l ON m.memberId = l.memberId
WHERE l.resourceId = 'da72a314-d592-432b-920b-8bfc5a9f0a3e';


-- 2. Display loan details along with resource titles.
SELECT l.loanId, l.memberId, r.resourceTitle, l.loanDate 
FROM Loan l
JOIN Resources r ON l.resourceId = r.resourceId;


-- 3. List members and the total number of resources they have borrowed.
SELECT m.memberId, m.memberName, COUNT(l.loanId) AS historyLoans
FROM Member m
JOIN Loan l ON m.memberId = l.memberId
GROUP BY m.memberId, m.memberName;


-- 4.Find all unavailable resources and their borrowers currently.
SELECT r.resourceTitle, m.memberName, l.loanDate, l.returnDate
FROM Resources r
JOIN Loan l ON r.resourceId = l.resourceId
JOIN Member m ON l.memberId = m.memberId
WHERE r.availability = 0
AND l.returnDate is NULL;

/* Advanced Queries */

-- 1.Find the top three members with the highest total fines.
SELECT m.memberId, m.memberName, m.totalFine
FROM Member m
ORDER BY m.totalFine DESC
FETCH FIRST 3 ROWS ONLY;


-- 2.Count the total loans per resource type.
SELECT r.resourceType, COUNT(l.loanId) AS totalLoans
FROM Resources r
JOIN Loan l ON r.resourceId = l.resourceId
GROUP BY r.resourceType;

-- 3.Show the average fine incurred by members grouped by member type.
SELECT m.memberType, AVG(m.totalFine) AS avgFine
FROM Member m
GROUP BY m.memberType;

-- 4.List the top three most borrowed resources.
SELECT r.resourceTitle, COUNT(l.loanId) AS borrowCount
FROM Resources r
JOIN Loan l ON r.resourceId = l.resourceId
GROUP BY r.resourceTitle
ORDER BY borrowCount DESC
FETCH FIRST 3 ROWS ONLY;


