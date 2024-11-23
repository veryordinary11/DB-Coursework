-- Make a loan for John Doe borrowing a book
INSERT INTO Loan (loanId, memberId, resourceId)
VALUES
('b1c3fc3a-1f13-4db5-9b6e-531458773c96', 'b1c3fc3a-1f13-4db5-9b6e-531458773c96', 'da72a314-d592-432b-920b-8bfc5a9f0a3e');

-- Test return of John Doe's book (Due date = loan date + 21 days)
-- Case1: Return date >= loan date and Return date <= due date (valid)
UPDATE Loan
SET returnDate = (SELECT loanDate FROM Loan WHERE loanId = 'b1c3fc3a-1f13-4db5-9b6e-531458773c96') + 1
WHERE loanId = 'b1c3fc3a-1f13-4db5-9b6e-531458773c96';

-- Case2: Return date = loan date (valid)
UPDATE Loan
SET returnDate = (SELECT loanDate FROM Loan WHERE loanId = 'b1c3fc3a-1f13-4db5-9b6e-531458773c96')
WHERE loanId = 'b1c3fc3a-1f13-4db5-9b6e-531458773c96';
