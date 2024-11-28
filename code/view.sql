/* 1. View for Most Popular Resources
This view shows the top 3 most borrowed resources based on the total number of times they have been borrowed. */

CREATE OR REPLACE VIEW MostPopularResources AS
SELECT 
    r.resourceId,
    r.resourceTitle,
    COUNT(l.loanId) AS borrowCount
FROM 
    Resources r
LEFT JOIN 
    Loan l ON r.resourceId = l.resourceId
GROUP BY 
    r.resourceId, r.resourceTitle
ORDER BY 
    borrowCount DESC
FETCH FIRST 3 ROWS ONLY;


/* 2. View for Member Eligibility
This view shows the eligibility of all members to borrow resources based on fines (totalFine > 10 makes 
a member ineligible) and the number of current loans(totalLoan > 5/10 makes a student/staff ineligible). */

CREATE OR REPLACE VIEW MemberEligibility AS
SELECT 
    m.memberId,
    m.memberName,
    m.memberType,
    m.totalFine,
    m.totalLoan,
    CASE 
        WHEN m.totalFine > 10 THEN 'Ineligible (High Fine)'
        WHEN m.memberType = 'Student' AND m.totalLoan > 5 THEN 'Ineligible (Too Many Loans for Student)'
        WHEN m.memberType = 'Staff' AND m.totalLoan > 10 THEN 'Ineligible (Too Many Loans for Staff)'
        ELSE 'Eligible'
    END AS eligibilityStatus
FROM 
    Member m;


/* 3. View for Detailed Fine Information for Alan Li
This view provides detailed fine information for a specific member (Alan Li), 
showing which loans contributed to their fines, the due date, return date, and the fine amount. */

CREATE OR REPLACE VIEW AlanLiFineDetails AS
SELECT 
    l.loanId,
    l.resourceId,
    r.resourceTitle,
    l.dueDate,
    l.returnDate,
    CASE 
        WHEN l.returnDate > l.dueDate THEN l.returnDate - l.dueDate
        ELSE 0
    END AS fineAmount
FROM 
    Loan l
JOIN 
    Resources r ON l.resourceId = r.resourceId
WHERE 
    l.memberId = '082413d4-7897-4ef9-b69e-c7d65514d6c4';




