use BankingIndia;
-- 1.Find all customers who share the same email address and return only the duplicates.
select email,count(*) from customers
group by email
having email > "1";

-- 2.Identify accounts where the same customer_id has more than one Fixed Deposit account in the same branch.
select account_type,count(*) from accounts
group by account_type
having account_type = "Fixed Deposit";

-- 3.Find transactions where the same reference_no appears more than once.
select * from transactions;
select reference_no,count(*) from transactions
group by reference_no
having reference_no > "1";

-- 4.Detect employees who have the same phone number registered under different employee_id.
select * from employees;
select phone,count(*) from employees
group by phone
having count(*) >1 ;

-- 5.Find loans where the same customer has taken the same loan type more than twice.
select * from loans;
select loan_type,count(*) from loans
group by loan_type
having count(*) > "2";


-- NULL & Missing Values


-- 6. List all customers where pan_number is NULL — how many are KYC Verified despite missing PAN?
select * from customers;
select count(*),kyc_status
from customers
where pan_number is null
group by kyc_status;

-- 7. Find accounts where opened_at is NULL or a future date.
select * from accounts;
select * from accounts 
where  opened_at is NULL or opened_at>current_date;

-- 8. Which loans have disbursed_date as NULL but status is Active?
select * from loans
where disbursed_date is null or status = "active";

-- 9. Find employees where join_date is NULL or earlier than the year 2000.
select * from employees;
select * from employees
where join_date is NULL or join_date < '2000-01-01';

-- 10. Identify transactions where balance_after is NULL — how many belong to successful transactions?
select * from transactions
where balance_after is null 
or status = 'success';


-- Invalid / Incorrect Data


-- 11. Find all customers whose phone number is less than 10 digits or starts with 0 or 1.
select count(*) from customers
where length(phone < 10) or phone like '0%' or phone like '1%';
select * from accounts;

-- 12. Which accounts have a balance greater than ₹50,00,000 — are any of them Savings accounts?
select balance,account_type from accounts
where balance > 5000000 and account_type = 'saving';
select * from cards;

-- 13. Find transactions where amount is 0 or negative.
select amount from transactions where amount = '0 or negative';

-- 14. Identify loans where emi_amount is greater than principal — is this logically valid?
select emi_amount from loans where emi_amount > 'principal';

-- 15. Find cards where expiry_date is before the card's issued_at date.
select * from cards where expiry_date > issued_at;
-- Standardisation
select * from customers;

-- 16. Find customers whose email contains uppercase letters — write a query to standardise them.
select email from customers where upper(email);

-- 18. Find employees whose designation has extra spaces or inconsistent casing (e.g., "manager", "MANAGER", " Manager").
select * from loans;

select full_name,designation from employees where designation != trim(designation);
-- 19. Which customer names contain numbers or special characters that shouldn't be there?
select full_name from customers where full_name regexp '[0-9!@#$%^&*()]';


-- 20. Find loan records where interest_rate is 0% or above 30% — are these valid?
select * from loans where interest_rate = 0 OR  interest_rate > 30;


-- Referential Integrity


-- 21. Find transactions that reference an account_id that no longer exists in the accounts table.
select * from transactions where account_id not in (select account_id from accounts);
select t.* 
from transactions t 
left join accounts a on t.account_id = a.account_id
where a.account_id is null;

-- 22. Identify cards linked to accounts that are Closed or Frozen.accounts
select c.*
 from cards c
 left join accounts a on c.account_id = a.account_id
 where a.status in ('closed' or 'frozen');
 
-- 23. Find employees assigned to a branch_id that does not exist in the branches table.
select e.* 
from employees e
left join branches b on e.branch_id = b.branch_id 
where b.branch_id is null;

-- 24. Which loans are linked to a customer_id that has no active account?
select c.* 
from customers c 
left join loans l on c.customer_id = l.customer_id
where l.status is not null; 

-- 25. Find accounts where branch_id is valid but the branch's city is different from the customer's city — list them.
select c.customer_id,c.city as customer_city,b.branch_id,b.city as branch_city
from branches b
join accounts a
on a.branch_id=b.branch_id
left join customers c on c.customer_id=a.customer_id
where c.city != b.city;
select * from customers;


-- 📊 DATA ANALYSIS — 35 Questions

#Customer analysis


-- 26 Who are the top 10 customers by total balance across all active accounts.?
select  * from accounts;
select customer_id,sum(balance) as total_combined_balance
from accounts 
where status = 'active'
group by customer_id
order by total_combined_balance Asc
limit 10;

-- 27.How many customers have more than 3 accounts — list them with total balance.
select customer_id,
sum(balance) as total_balance,
count(account_id) as total_account
from accounts
group by customer_id
having count(account_id) >3 
order by total_balance;

-- 28.Which customers have never taken a loan but have a balance above ₹5,00,000?
select a.customer_id,
sum(a.balance) as total_deposit_balance
from accounts a
left join loans l on
a.customer_id = l.customer_id
group by customer_id
having sum(a.balance) > 500000 
and count(l.loan_id) = 0;

-- 29.Find customers whose total withdrawn amount in the last 90 days exceeds their current balance.
select c.full_name, a.account_id,sum(amount) as total_amount 
from transactions t join accounts a
on t.account_id = a.account_id
join customers c
on a.customer_id = c.customer_id
where t.transaction_date <= current_date - interval 90 day
group by c.full_name, a.account_id
order by total_amount desc
limit 10;

-- 30.Which customers hold both a Credit card and an active loan simultaneously?
SELECT  c.customer_id, 
       l.status AS loan_status, 
       m.card_type
FROM customers c
JOIN loans l
    ON c.customer_id = l.customer_id
JOIN accounts a
    ON a.customer_id =c.customer_id
JOIN cards m
    ON m.account_id = a.account_id
WHERE l.status = 'active' 
  AND m.card_type = 'Credit';
  
-- 31.Find the average age of customers grouped by account type.
select a.account_type,avg(timestampdiff(year,c.dob,curdate())) as avg_age 
from customers c
join accounts a
on c.customer_id = a.customer_id
group by a.account_type;

-- 32.Which customers have accounts in more than one branch?  
select c.customer_id,count( a.branch_id) as total_branches
from customers c 
join accounts a 
on c.customer_id = a.customer_id
join branches b
on a.branch_id = b.branch_id
group by c.customer_id
 having COUNT(a.branch_id) > 1;
 

-- Account Analysis

-- 33.What is the average balance per account type — compare Active vs Inactive accounts.
select account_type,status,avg(balance) as avg_balance
from accounts
group by account_type,status;

-- 34. Which accounts have received more than 10 deposits but never made a single withdrawal?
select a.account_id 
from accounts a 
join transactions t
on a.account_id = t.account_id
group by a.account_id
having count(case 
when t.transaction_type = "deposit"
then 1
end) > 10
and count(case 
when  t.transaction_type = "withdraw"
then 1
end) =0;       
select * from accounts;
select * from transactions;
select * from cards;

-- 35. Find accounts where the total credit (deposits) is less than the total debit (withdrawals).
select t.account_id 
from transactions t
group by t.account_id
having sum(case 
when t.transaction_type = 'deposit'
then t.amount
else 0
end)
<
  sum(case
 when t.transaction_type = 'Withdraw'
 then t.amount
 else 0
 end);
 
-- 36. Which accounts were opened in the last 60 days but already have a balance above ₹1,00,000?
select account_id,
       balance,
       opened_at
from accounts
where opened_at >= current_date - interval 60 day
and balance > 100000;

-- 37. List accounts that have been Frozen — how long ago were they last transacted?
select a.account_id,a.status,max(t.transaction_date) as last_transaction,datediff(curdate(),max(t.transaction_date)) as days_ago
from accounts a 
join transactions t
on a.account_id = t.account_id
where a.status = 'frozen'
group by account_id,a.status;

-- 38. Find all accounts whose balance has not changed in the last 1 year (no successful transactions).
select a.account_id,a.balance,max(t.transaction_date) as last_transactions
from accounts a 
join transactions t 
on a.account_id = t.account_id
where  t.status = 'success'
group by account_id,balance
having max(t.transaction_date) < current_date - interval 1 year;

-- Transaction Analysis


-- 39. What is the month-wise total transaction volume and count for the last 24 months?
select * from transactions;
select transaction_date,sum(amount) as total_transactions_volume,count(*) as total_transaction
from transactions
where transaction_date < current_date - interval 24 month
group by  transaction_date;

-- 40. Which channel (UPI, NEFT, ATM etc.) processes the highest total amount?
select * from transactions;
select channel,max(amount) as total_amount
from transactions
group by channel;

-- 41. What is the success rate (%) of transactions for each channel?
select * from transactions;
select channel,
count(*) as total_transaction,
sum(case 
when status = 'success' then 1
else 0
end) as successful_transaction,
round(sum(case 
when status = 'success' then 1
else 0
end)*100.0)/count(*), 2
as success_rate_percentage from transactions
group by channel;

-- 42. Find the top 5 days of the week with the highest average transaction amount.
select * from transactions;
select dayname(transaction_date),avg(amount)
from transactions
group by dayname(transaction_date)
order by avg(amount) desc 
limit 5;

-- 43. Detect any account that had more than 5 transactions in a single day.
select account_id,transaction_date,count(transaction_id) as total_transaction
from transactions
group by account_id,transaction_date
having count(transaction_id) > 5;

-- 44. Find all transactions above ₹2,00,000 that happened between midnight and 5 AM.
select * from transactions
where amount > 200000
and time(transaction_date) between '00:00:00' and '05:00:00';

-- 45. What is the running total (cumulative sum) of deposits for account_id = 1, ordered by date?
select transaction_date,amount,sum(amount) over(order by transaction_date) as running_total
from transactions
where account_id =1;

-- Loan Analysis


-- 46. What is the default rate (%) for each loan type?
select * from loans;
select loan_type,count(*)as total_loan,
sum(case when status = 'defaulted' then 1 else 0 end) as defaulted_count,
(sum( case when status = 'defaulted' then 1 else 0 end)/count(*))*100 as defaulte_rate_percentage
from loans
group by loan_type;

-- 47. Which customers are paying EMI but their account balance is consistently below their EMI amount?
select * from accounts;
select * from loans;
select * from customers;
select c.full_name,a.balance,l.emi_amount 
from customers c 
join loans l
on c.customer_id = l.customer_id
join accounts a 
on c.customer_id = a.customer_id
where a.balance < l.emi_amount;

-- 48. Find the average loan amount and average interest rate grouped by city.
select * from loans;
select * from customers;
select c.city,avg(emi_amount) as avg_emi_amount,avg(interest_rate) as interest_rate
from customers c 
join loans l 
on c.customer_id = l.customer_id
group by city;

-- 49. Which branches have approved the most loans — and what is their total loan value?
select * from branches;
select * from loans;
select branch_name,count(loan_id) as most_loan,sum(emi_amount*tenure_months) as total_loan_value
from branches b 
join loans l 
on b.branch_id = l.branch_id
group by branch_name
order by total_loan_value desc;

-- 50. Find customers who have a defaulted loan but are still making transactions — potential fraud signal.
select * from customers;
select * from loans;
select * from transactions;
select c.full_name,l.status,t.transaction_date
from customers c 
join loans l 
on c.customer_id = l.customer_id
join transactions t
on c.customer_id = t.transaction_id
where l.status = 'default';

-- 51. What is the total outstanding loan amount grouped by loan type and status?
select * from loans;
select loan_type,status,sum(outstanding) as total_loan
from loans
group by loan_type,status
order by loan_type;

-- 52. Which loan type has the highest average tenure in months?
select * from loans;
select loan_type,avg(tenure_months) as avg_tenure_months
from loans
group by loan_type;


-- Branch & Employee Analysis


-- 53. Which branch has the highest number of active accounts and what is their total deposit?
select * from branches;
select * from accounts;
select b.branch_id,max(a.account_id) as total_depsot,a.status
from branches b 
join accounts a 
on b.branch_id = a.account_id
where a.status = 'Active'
group by branch_id;

-- 54. Find branches where the number of employees is less than 3.
select * from branches;
select * from employees;

select b.branch_id,count(employee_id) as no_emp,branch_name
from branches b
join employees e 
on e.branch_id = b.branch_id
group by  branch_id,branch_name
having count(employee_id) > 3
order by branch_id ;

-- 55. What is the average salary per designation — rank them from highest to lowest.
select * from employees;
select designation,avg(salary) as avg_salary
from employees
group by designation
order by avg(salary) desc; 

-- 56. Which branches have no loan disbursements at all?
select * from branches;
select * from loans;
select b.branch_id
from branches b 
 left join loans l 
on b.branch_id = l.branch_id 
where l.loan_id is null; 

-- 57. Find the branch where the ratio of defaulted loan amount to total loan amount is highest.
select * from branches;
select * from loans;
select branch_name,
sum(case when l.status = 'default' then  emi_amount else 0 end) as default_amount,
sum(case when l.status = 'default' then emi_amount else 0 end ) as  total_amount,
(sum(case when l.status = 'default' then emi_amount else 0 end) /sum(emi_amount)) * 100 as default_ratio
from branches b 
join loans l 
on b.branch_id = l.branch_id
group by b.branch_name 
order by default_ratio desc
limit 10;

--


-- 58. Which customers have a defaulted loan AND large suspicious transactions AND a Blocked card — all at the same time?
select * from customers;
select * from loans;
select * from transactions;
select * from cards;
select c.customer_id,full_name 
from customers c 
inner join loans l 
on c.customer_id = l.customer_id
inner join transactions t 
on c.customer_id = transaction_id
inner join cards ca 
on  c.customer_id = ca.card_id
where l.status = 'default'  and ca.status = 'blocked';
