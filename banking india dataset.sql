-- ============================================================
-- BANKING MANAGEMENT SYSTEM - Realistic Indian Data
-- ============================================================

DROP DATABASE IF EXISTS BankingIndia;
CREATE DATABASE BankingIndia CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE BankingIndia;

-- ============================================================
-- SECTION 1: CREATE TABLES
-- ============================================================

CREATE TABLE branches (
    branch_id    INT AUTO_INCREMENT PRIMARY KEY,
    bank_name    VARCHAR(100) NOT NULL,
    branch_name  VARCHAR(150) NOT NULL,
    branch_code  VARCHAR(20)  NOT NULL UNIQUE,
    ifsc_code    VARCHAR(20)  NOT NULL UNIQUE,
    city         VARCHAR(100) NOT NULL,
    state        VARCHAR(100) NOT NULL,
    address      TEXT,
    phone        VARCHAR(20),
    email        VARCHAR(150),
    created_at   DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE customers (
    customer_id  INT AUTO_INCREMENT PRIMARY KEY,
    full_name    VARCHAR(150) NOT NULL,
    email        VARCHAR(150) UNIQUE,
    phone        VARCHAR(15)  NOT NULL,
    address      TEXT,
    city         VARCHAR(100),
    state        VARCHAR(100),
    pincode      VARCHAR(10),
    dob          DATE,
    gender       ENUM('Male','Female','Other') DEFAULT 'Male',
    pan_number   VARCHAR(20) UNIQUE,
    aadhar_last4 VARCHAR(4),
    kyc_status   ENUM('Verified','Pending','Rejected') DEFAULT 'Pending',
    created_at   DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE employees (
    employee_id  INT AUTO_INCREMENT PRIMARY KEY,
    branch_id    INT NOT NULL,
    full_name    VARCHAR(150) NOT NULL,
    email        VARCHAR(150) UNIQUE,
    phone        VARCHAR(15),
    designation  VARCHAR(100),
    department   VARCHAR(100),
    salary       DECIMAL(12,2) DEFAULT 30000.00,
    join_date    DATE,
    status       ENUM('Active','Inactive','Resigned') DEFAULT 'Active',
    created_at   DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_emp_branch FOREIGN KEY (branch_id) REFERENCES branches(branch_id)
);

CREATE TABLE accounts (
    account_id     INT AUTO_INCREMENT PRIMARY KEY,
    customer_id    INT NOT NULL,
    branch_id      INT NOT NULL,
    account_number VARCHAR(20) NOT NULL UNIQUE,
    account_type   ENUM('Savings','Current','Salary','Fixed Deposit','NRI') DEFAULT 'Savings',
    balance        DECIMAL(15,2) DEFAULT 0.00,
    currency       VARCHAR(5) DEFAULT 'INR',
    status         ENUM('Active','Inactive','Closed','Frozen') DEFAULT 'Active',
    minimum_balance DECIMAL(10,2) DEFAULT 1000.00,
    opened_at      DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_acc_customer FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    CONSTRAINT fk_acc_branch   FOREIGN KEY (branch_id)   REFERENCES branches(branch_id)
);

CREATE TABLE transactions (
    transaction_id   INT AUTO_INCREMENT PRIMARY KEY,
    account_id       INT NOT NULL,
    transaction_type ENUM('Deposit','Withdraw','Transfer','EMI','Interest') NOT NULL,
    amount           DECIMAL(15,2) NOT NULL,
    balance_after    DECIMAL(15,2),
    channel          ENUM('ATM','UPI','NEFT','RTGS','IMPS','Branch','Net Banking','Mobile Banking') DEFAULT 'UPI',
    reference_no     VARCHAR(50) UNIQUE,
    remarks          VARCHAR(255),
    status           ENUM('Success','Failed','Pending','Reversed') DEFAULT 'Success',
    transaction_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_txn_account FOREIGN KEY (account_id) REFERENCES accounts(account_id)
);

CREATE TABLE loans (
    loan_id        INT AUTO_INCREMENT PRIMARY KEY,
    customer_id    INT NOT NULL,
    branch_id      INT NOT NULL,
    loan_type      ENUM('Home','Car','Personal','Education','Business','Gold','Agricultural') DEFAULT 'Personal',
    principal      DECIMAL(15,2) NOT NULL,
    interest_rate  DECIMAL(5,2)  DEFAULT 10.00,
    tenure_months  INT           DEFAULT 12,
    emi_amount     DECIMAL(15,2),
    outstanding    DECIMAL(15,2),
    disbursed_date DATE,
    status         ENUM('Active','Closed','Defaulted','Pending','Rejected') DEFAULT 'Pending',
    created_at     DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_loan_customer FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    CONSTRAINT fk_loan_branch   FOREIGN KEY (branch_id)   REFERENCES branches(branch_id)
);

CREATE TABLE cards (
    card_id        INT AUTO_INCREMENT PRIMARY KEY,
    account_id     INT NOT NULL,
    card_number    VARCHAR(25) NOT NULL UNIQUE,
    card_type      ENUM('Debit','Credit','Prepaid') DEFAULT 'Debit',
    card_network   ENUM('Visa','Mastercard','RuPay','Amex') DEFAULT 'RuPay',
    card_holder    VARCHAR(150),
    expiry_date    DATE,
    credit_limit   DECIMAL(15,2) DEFAULT 0.00,
    outstanding_bill DECIMAL(15,2) DEFAULT 0.00,
    status         ENUM('Active','Blocked','Expired','Lost') DEFAULT 'Active',
    issued_at      DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_card_account FOREIGN KEY (account_id) REFERENCES accounts(account_id)
);


-- ============================================================
-- SECTION 2: HELPER TABLES FOR REALISTIC DATA
-- ============================================================

CREATE TABLE tmp_first_names (id INT AUTO_INCREMENT PRIMARY KEY, name VARCHAR(50), gender VARCHAR(10));
CREATE TABLE tmp_last_names  (id INT AUTO_INCREMENT PRIMARY KEY, name VARCHAR(50));
CREATE TABLE tmp_cities      (id INT AUTO_INCREMENT PRIMARY KEY, city VARCHAR(100), state VARCHAR(100), pincode_prefix VARCHAR(3));
CREATE TABLE tmp_areas       (id INT AUTO_INCREMENT PRIMARY KEY, area VARCHAR(100));
CREATE TABLE tmp_streets     (id INT AUTO_INCREMENT PRIMARY KEY, street VARCHAR(100));
CREATE TABLE tmp_banks       (id INT AUTO_INCREMENT PRIMARY KEY, bank_name VARCHAR(100), short_code VARCHAR(10));

-- Indian first names (Male + Female)
INSERT INTO tmp_first_names (name, gender) VALUES
('Rahul','Male'),('Amit','Male'),('Vijay','Male'),('Suresh','Male'),('Rajesh','Male'),
('Anil','Male'),('Manoj','Male'),('Sandeep','Male'),('Deepak','Male'),('Rohit','Male'),
('Vikas','Male'),('Sanjay','Male'),('Arjun','Male'),('Karan','Male'),('Nikhil','Male'),
('Pranav','Male'),('Yash','Male'),('Harsh','Male'),('Akash','Male'),('Dev','Male'),
('Ravi','Male'),('Sunil','Male'),('Manish','Male'),('Pankaj','Male'),('Gaurav','Male'),
('Dinesh','Male'),('Rakesh','Male'),('Naresh','Male'),('Lokesh','Male'),('Mahesh','Male'),
('Girish','Male'),('Hitesh','Male'),('Jitesh','Male'),('Ramesh','Male'),('Umesh','Male'),
('Varun','Male'),('Tarun','Male'),('Arun','Male'),('Karun','Male'),('Sarun','Male'),
('Priya','Female'),('Sneha','Female'),('Pooja','Female'),('Neha','Female'),('Anjali','Female'),
('Kavita','Female'),('Sunita','Female'),('Rekha','Female'),('Meena','Female'),('Geeta','Female'),
('Anita','Female'),('Sonia','Female'),('Ritu','Female'),('Poonam','Female'),('Swati','Female'),
('Divya','Female'),('Shweta','Female'),('Nisha','Female'),('Rashmi','Female'),('Shruti','Female'),
('Pallavi','Female'),('Madhuri','Female'),('Sapna','Female'),('Reena','Female'),('Seema','Female'),
('Asha','Female'),('Usha','Female'),('Lata','Female'),('Nita','Female'),('Rita','Female'),
('Ishita','Female'),('Kriti','Female'),('Tanvi','Female'),('Riya','Female'),('Aisha','Female'),
('Meera','Female'),('Deepa','Female'),('Nandini','Female'),('Radha','Female'),('Sita','Female');

-- Indian last names (regional mix)
INSERT INTO tmp_last_names (name) VALUES
('Sharma'),('Verma'),('Patel'),('Gupta'),('Singh'),('Kumar'),('Jain'),('Shah'),
('Mehta'),('Iyer'),('Nair'),('Pillai'),('Reddy'),('Rao'),('Naidu'),('Yadav'),
('Tiwari'),('Mishra'),('Pandey'),('Dubey'),('Shukla'),('Tripathi'),('Dwivedi'),('Chaturvedi'),
('Agarwal'),('Bansal'),('Garg'),('Mittal'),('Goyal'),('Joshi'),('Bhat'),('Kaur'),
('Chopra'),('Khanna'),('Malhotra'),('Kapoor'),('Bhatia'),('Sethi'),('Anand'),('Arora'),
('Srivastava'),('Saxena'),('Rastogi'),('Asthana'),('Bajpai'),('Lal'),('Das'),('Dey'),
('Bose'),('Ghosh'),('Mukherjee'),('Chatterjee'),('Banerjee'),('Chakraborty'),('Sengupta'),('Roy'),
('Pillai'),('Menon'),('Varma'),('Krishnan'),('Subramaniam'),('Venkatesh'),('Rajan'),('Prasad'),
('Kulkarni'),('Desai'),('Patil'),('Jadhav'),('Shinde'),('More'),('Pawar'),('Jagtap');

-- Indian cities with states and pincode prefix
INSERT INTO tmp_cities (city, state, pincode_prefix) VALUES
('Mumbai','Maharashtra','400'),('Delhi','Delhi','110'),('Bangalore','Karnataka','560'),
('Hyderabad','Telangana','500'),('Chennai','Tamil Nadu','600'),('Kolkata','West Bengal','700'),
('Pune','Maharashtra','411'),('Ahmedabad','Gujarat','380'),('Surat','Gujarat','395'),
('Jaipur','Rajasthan','302'),('Lucknow','Uttar Pradesh','226'),('Kanpur','Uttar Pradesh','208'),
('Nagpur','Maharashtra','440'),('Indore','Madhya Pradesh','452'),('Bhopal','Madhya Pradesh','462'),
('Patna','Bihar','800'),('Ludhiana','Punjab','141'),('Agra','Uttar Pradesh','282'),
('Nashik','Maharashtra','422'),('Vadodara','Gujarat','390'),('Rajkot','Gujarat','360'),
('Meerut','Uttar Pradesh','250'),('Varanasi','Uttar Pradesh','221'),('Amritsar','Punjab','143'),
('Jodhpur','Rajasthan','342'),('Coimbatore','Tamil Nadu','641'),('Guwahati','Assam','781'),
('Chandigarh','Punjab','160'),('Mysore','Karnataka','570'),('Bhubaneswar','Odisha','751'),
('Kochi','Kerala','682'),('Visakhapatnam','Andhra Pradesh','530'),('Thiruvananthapuram','Kerala','695'),
('Raipur','Chhattisgarh','492'),('Gwalior','Madhya Pradesh','474'),('Jabalpur','Madhya Pradesh','482'),
('Madurai','Tamil Nadu','625'),('Faridabad','Haryana','121'),('Noida','Uttar Pradesh','201'),
('Gurgaon','Haryana','122'),('Dehradun','Uttarakhand','248'),('Haridwar','Uttarakhand','249'),
('Shimla','Himachal Pradesh','171'),('Jammu','Jammu & Kashmir','180'),('Srinagar','Jammu & Kashmir','190'),
('Allahabad','Uttar Pradesh','211'),('Ranchi','Jharkhand','834'),('Dhanbad','Jharkhand','826'),
('Vijayawada','Andhra Pradesh','520'),('Udaipur','Rajasthan','313');

-- Areas / localities (realistic Indian colony names)
INSERT INTO tmp_areas (area) VALUES
('Andheri West'),('Bandra East'),('Borivali North'),('Dadar'),('Kurla'),
('Connaught Place'),('Lajpat Nagar'),('Karol Bagh'),('Rohini'),('Dwarka'),
('Koramangala'),('Indiranagar'),('Jayanagar'),('Whitefield'),('HSR Layout'),
('Banjara Hills'),('Jubilee Hills'),('Madhapur'),('Secunderabad'),('Gachibowli'),
('Anna Nagar'),('T. Nagar'),('Adyar'),('Velachery'),('Porur'),
('Salt Lake'),('Park Street'),('Ballygunge'),('Howrah'),('Dum Dum'),
('Kothrud'),('Hadapsar'),('Viman Nagar'),('Aundh'),('Baner'),
('Satellite'),('Navrangpura'),('Maninagar'),('Vastrapur'),('Bopal'),
('Adajan'),('Vesu'),('Katargam'),('Piplod'),('Althan'),
('Malviya Nagar'),('C-Scheme'),('Vaishali Nagar'),('Mansarovar'),('Jagatpura');

-- Street names
INSERT INTO tmp_streets (street) VALUES
('MG Road'),('Gandhi Nagar'),('Nehru Street'),('Patel Road'),('Ambedkar Marg'),
('Station Road'),('Market Road'),('Temple Street'),('Park Avenue'),('Ring Road'),
('Subhash Marg'),('Tilak Nagar Road'),('Shivaji Marg'),('Rajiv Gandhi Road'),('Indira Nagar'),
('Civil Lines'),('Model Town Road'),('Sector 5 Road'),('Link Road'),('Old Highway');

-- Banks
INSERT INTO tmp_banks (bank_name, short_code) VALUES
('State Bank of India','SBI'),('HDFC Bank','HDFC'),('ICICI Bank','ICICI'),
('Axis Bank','AXIS'),('Punjab National Bank','PNB'),('Bank of Baroda','BOB'),
('Canara Bank','CAN'),('Union Bank of India','UBI'),('Kotak Mahindra Bank','KMB'),
('IndusInd Bank','IIB');


-- ============================================================
-- SECTION 3: DATA GENERATION STORED PROCEDURES
-- ============================================================

DELIMITER $$

-- 3.1 Generate 50 Branches
CREATE PROCEDURE sp_generate_branches()
BEGIN
    DECLARE i INT DEFAULT 1;
    DECLARE v_bank_id    INT;
    DECLARE v_city_id    INT;
    DECLARE v_bank_name  VARCHAR(100);
    DECLARE v_short_code VARCHAR(10);
    DECLARE v_city       VARCHAR(100);
    DECLARE v_state      VARCHAR(100);
    DECLARE v_pinpfx     VARCHAR(3);
    DECLARE v_bank_count INT;
    DECLARE v_city_count INT;

    SELECT COUNT(*) INTO v_bank_count FROM tmp_banks;
    SELECT COUNT(*) INTO v_city_count FROM tmp_cities;

    WHILE i <= 50 DO
        SET v_bank_id = (FLOOR(RAND() * v_bank_count) + 1);
        SET v_city_id = (MOD(i - 1, v_city_count) + 1);

        SELECT bank_name, short_code INTO v_bank_name, v_short_code
        FROM tmp_banks WHERE id = v_bank_id;

        SELECT city, state, pincode_prefix INTO v_city, v_state, v_pinpfx
        FROM tmp_cities WHERE id = v_city_id;

        INSERT INTO branches (bank_name, branch_name, branch_code, ifsc_code, city, state, address, phone, email)
        VALUES (
            v_bank_name,
            CONCAT(v_bank_name, ' - ', v_city, ' Branch'),
            CONCAT(v_short_code, LPAD(i, 4, '0')),
            CONCAT(v_short_code, '0', LPAD(i, 6, '0')),
            v_city,
            v_state,
            CONCAT(FLOOR(RAND()*200+1), ', Main Road, ', v_city),
            CONCAT('0', FLOOR(RAND()*90000000 + 10000000)),
            CONCAT(LOWER(v_short_code), '.', LOWER(REPLACE(v_city,' ','')), '@bank.in')
        );
        SET i = i + 1;
    END WHILE;
END$$


-- 3.2 Generate 2000 Customers
CREATE PROCEDURE sp_generate_customers()
BEGIN
    DECLARE i           INT DEFAULT 1;
    DECLARE v_fn_count  INT;
    DECLARE v_ln_count  INT;
    DECLARE v_ct_count  INT;
    DECLARE v_ar_count  INT;
    DECLARE v_st_count  INT;
    DECLARE v_fn_id     INT;
    DECLARE v_ln_id     INT;
    DECLARE v_ct_id     INT;
    DECLARE v_ar_id     INT;
    DECLARE v_st_id     INT;
    DECLARE v_fname     VARCHAR(50);
    DECLARE v_lname     VARCHAR(50);
    DECLARE v_gender    VARCHAR(10);
    DECLARE v_city      VARCHAR(100);
    DECLARE v_state     VARCHAR(100);
    DECLARE v_pinpfx    VARCHAR(3);
    DECLARE v_area      VARCHAR(100);
    DECLARE v_street    VARCHAR(100);
    DECLARE v_fullname  VARCHAR(150);
    DECLARE v_email     VARCHAR(150);
    DECLARE v_phone     VARCHAR(15);
    DECLARE v_pan       VARCHAR(20);
    DECLARE v_dob       DATE;
    DECLARE v_kyc       VARCHAR(20);

    SELECT COUNT(*) INTO v_fn_count FROM tmp_first_names;
    SELECT COUNT(*) INTO v_ln_count FROM tmp_last_names;
    SELECT COUNT(*) INTO v_ct_count FROM tmp_cities;
    SELECT COUNT(*) INTO v_ar_count FROM tmp_areas;
    SELECT COUNT(*) INTO v_st_count FROM tmp_streets;

    WHILE i <= 2000 DO
        SET v_fn_id  = FLOOR(RAND() * v_fn_count) + 1;
        SET v_ln_id  = FLOOR(RAND() * v_ln_count) + 1;
        SET v_ct_id  = FLOOR(RAND() * v_ct_count) + 1;
        SET v_ar_id  = FLOOR(RAND() * v_ar_count) + 1;
        SET v_st_id  = FLOOR(RAND() * v_st_count) + 1;

        SELECT name, gender INTO v_fname, v_gender FROM tmp_first_names WHERE id = v_fn_id;
        SELECT name         INTO v_lname            FROM tmp_last_names  WHERE id = v_ln_id;
        SELECT city, state, pincode_prefix INTO v_city, v_state, v_pinpfx
            FROM tmp_cities WHERE id = v_ct_id;
        SELECT area   INTO v_area   FROM tmp_areas   WHERE id = v_ar_id;
        SELECT street INTO v_street FROM tmp_streets WHERE id = v_st_id;

        SET v_fullname = CONCAT(v_fname, ' ', v_lname);
        SET v_email    = LOWER(CONCAT(v_fname, '.', v_lname, i, '@',
                            ELT(FLOOR(RAND()*5)+1,'gmail.com','yahoo.com','hotmail.com','rediffmail.com','outlook.com')));
        SET v_phone    = CONCAT(ELT(FLOOR(RAND()*8)+1,'98','97','96','95','94','93','92','91'),
                            LPAD(FLOOR(RAND()*99999999), 8, '0'));
        SET v_pan      = CONCAT(
                            CHAR(FLOOR(RAND()*26)+65), CHAR(FLOOR(RAND()*26)+65),
                            CHAR(FLOOR(RAND()*26)+65), CHAR(FLOOR(RAND()*26)+65),
                            CHAR(FLOOR(RAND()*26)+65),
                            LPAD(FLOOR(RAND()*9999)+1000, 4, '0'),
                            CHAR(FLOOR(RAND()*26)+65));
        SET v_dob  = DATE_SUB(CURDATE(), INTERVAL (FLOOR(RAND()*42)+18) YEAR);
        SET v_kyc  = ELT(FLOOR(RAND()*10)+1,'Verified','Verified','Verified','Verified','Verified',
                         'Verified','Verified','Pending','Pending','Rejected');

        INSERT INTO customers (full_name, email, phone, address, city, state, pincode, dob, gender, pan_number, aadhar_last4, kyc_status, created_at)
        VALUES (
            v_fullname,
            v_email,
            v_phone,
            CONCAT(FLOOR(RAND()*200+1), ', ', v_area, ', ', v_street),
            v_city,
            v_state,
            CONCAT(v_pinpfx, LPAD(FLOOR(RAND()*999), 3, '0')),
            v_dob,
            v_gender,
            v_pan,
            LPAD(FLOOR(RAND()*9999), 4, '0'),
            v_kyc,
            DATE_SUB(NOW(), INTERVAL FLOOR(RAND()*1825) DAY)
        );
        SET i = i + 1;
    END WHILE;
END$$


-- 3.3 Generate 500 Employees
CREATE PROCEDURE sp_generate_employees()
BEGIN
    DECLARE i          INT DEFAULT 1;
    DECLARE v_fn_count INT;
    DECLARE v_ln_count INT;
    DECLARE v_fn_id    INT;
    DECLARE v_ln_id    INT;
    DECLARE v_fname    VARCHAR(50);
    DECLARE v_lname    VARCHAR(50);
    DECLARE v_gender   VARCHAR(10);
    DECLARE v_branch   INT;
    DECLARE v_desig    VARCHAR(100);
    DECLARE v_dept     VARCHAR(100);
    DECLARE v_salary   DECIMAL(12,2);

    SELECT COUNT(*) INTO v_fn_count FROM tmp_first_names;
    SELECT COUNT(*) INTO v_ln_count FROM tmp_last_names;

    WHILE i <= 500 DO
        SET v_fn_id  = FLOOR(RAND() * v_fn_count) + 1;
        SET v_ln_id  = FLOOR(RAND() * v_ln_count) + 1;
        SET v_branch = FLOOR(RAND() * 50) + 1;

        SELECT name, gender INTO v_fname, v_gender FROM tmp_first_names WHERE id = v_fn_id;
        SELECT name         INTO v_lname            FROM tmp_last_names  WHERE id = v_ln_id;

        SET v_desig  = ELT(FLOOR(RAND()*8)+1,
                        'Branch Manager','Assistant Manager','Loan Officer',
                        'Cashier','Customer Service Executive','IT Support',
                        'Credit Analyst','Security Officer');
        SET v_dept   = ELT(FLOOR(RAND()*5)+1,
                        'Operations','Loans & Advances','Customer Relations',
                        'IT Department','Risk & Compliance');
        SET v_salary = CASE v_desig
                        WHEN 'Branch Manager'         THEN ROUND(RAND()*50000 + 80000, 2)
                        WHEN 'Assistant Manager'      THEN ROUND(RAND()*30000 + 55000, 2)
                        WHEN 'Loan Officer'           THEN ROUND(RAND()*20000 + 40000, 2)
                        WHEN 'Credit Analyst'         THEN ROUND(RAND()*20000 + 45000, 2)
                        WHEN 'Cashier'                THEN ROUND(RAND()*10000 + 25000, 2)
                        WHEN 'Customer Service Executive' THEN ROUND(RAND()*10000 + 22000, 2)
                        ELSE ROUND(RAND()*15000 + 20000, 2)
                       END;

        INSERT INTO employees (branch_id, full_name, email, phone, designation, department, salary, join_date, status)
        VALUES (
            v_branch,
            CONCAT(v_fname, ' ', v_lname),
            LOWER(CONCAT(v_fname, '.', v_lname, i, '@bankindia.in')),
            CONCAT(ELT(FLOOR(RAND()*4)+1,'98','97','96','95'), LPAD(FLOOR(RAND()*99999999), 8, '0')),
            v_desig,
            v_dept,
            v_salary,
            DATE_SUB(CURDATE(), INTERVAL FLOOR(RAND()*3650) DAY),
            ELT(FLOOR(RAND()*10)+1,'Active','Active','Active','Active','Active',
                'Active','Active','Active','Inactive','Resigned')
        );
        SET i = i + 1;
    END WHILE;
END$$


-- 3.4 Generate 3000 Accounts
CREATE PROCEDURE sp_generate_accounts()
BEGIN
    DECLARE i         INT DEFAULT 1;
    DECLARE v_cust    INT;
    DECLARE v_branch  INT;
    DECLARE v_type    VARCHAR(50);
    DECLARE v_balance DECIMAL(15,2);
    DECLARE v_minbal  DECIMAL(10,2);
    DECLARE v_status  VARCHAR(20);

    WHILE i <= 3000 DO
        SET v_cust   = FLOOR(RAND() * 2000) + 1;
        SET v_branch = FLOOR(RAND() * 50) + 1;
        SET v_type   = ELT(FLOOR(RAND()*5)+1,'Savings','Savings','Current','Salary','Fixed Deposit');
        SET v_balance = CASE v_type
                          WHEN 'Savings'       THEN ROUND(RAND()*500000  + 1000, 2)
                          WHEN 'Current'       THEN ROUND(RAND()*2000000 + 10000, 2)
                          WHEN 'Salary'        THEN ROUND(RAND()*200000  + 5000, 2)
                          WHEN 'Fixed Deposit' THEN ROUND(RAND()*1000000 + 50000, 2)
                          ELSE ROUND(RAND()*300000 + 2000, 2)
                        END;
        SET v_minbal = CASE v_type
                         WHEN 'Savings' THEN 1000
                         WHEN 'Current' THEN 10000
                         ELSE 0
                       END;
        SET v_status = ELT(FLOOR(RAND()*10)+1,'Active','Active','Active','Active','Active',
                           'Active','Active','Active','Inactive','Closed');

        INSERT INTO accounts (customer_id, branch_id, account_number, account_type, balance, minimum_balance, status, opened_at)
        VALUES (
            v_cust,
            v_branch,
            CONCAT(LPAD(v_branch, 4, '0'), LPAD(i, 10, '0')),
            v_type,
            v_balance,
            v_minbal,
            v_status,
            DATE_SUB(NOW(), INTERVAL FLOOR(RAND()*2500) DAY)
        );
        SET i = i + 1;
    END WHILE;
END$$


-- 3.5 Generate 10000 Transactions
CREATE PROCEDURE sp_generate_transactions()
BEGIN
    DECLARE i          INT DEFAULT 1;
    DECLARE v_acc      INT;
    DECLARE v_type     VARCHAR(50);
    DECLARE v_amount   DECIMAL(15,2);
    DECLARE v_channel  VARCHAR(50);
    DECLARE v_status   VARCHAR(20);
    DECLARE v_remark   VARCHAR(255);
    DECLARE v_date     DATETIME;

    WHILE i <= 10000 DO
        SET v_acc    = FLOOR(RAND() * 3000) + 1;
        SET v_type   = ELT(FLOOR(RAND()*10)+1,
                        'Deposit','Deposit','Deposit',
                        'Withdraw','Withdraw','Withdraw',
                        'Transfer','Transfer',
                        'EMI','Interest');
        SET v_amount = CASE v_type
                         WHEN 'Deposit'   THEN ROUND(RAND()*490000  + 500, 2)
                         WHEN 'Withdraw'  THEN ROUND(RAND()*100000  + 100, 2)
                         WHEN 'Transfer'  THEN ROUND(RAND()*200000  + 1000, 2)
                         WHEN 'EMI'       THEN ROUND(RAND()*50000   + 2000, 2)
                         WHEN 'Interest'  THEN ROUND(RAND()*5000    + 100, 2)
                         ELSE ROUND(RAND()*50000 + 100, 2)
                       END;
        SET v_channel = ELT(FLOOR(RAND()*8)+1,
                          'UPI','UPI','UPI','Net Banking','Mobile Banking',
                          'ATM','NEFT','IMPS');
        SET v_status  = ELT(FLOOR(RAND()*10)+1,
                          'Success','Success','Success','Success','Success',
                          'Success','Success','Success','Failed','Pending');
        SET v_remark  = CASE v_type
                          WHEN 'Deposit'  THEN ELT(FLOOR(RAND()*5)+1,'Salary Credit','Cash Deposit','Online Transfer','Cheque Deposit','NEFT Received')
                          WHEN 'Withdraw' THEN ELT(FLOOR(RAND()*5)+1,'ATM Withdrawal','Bill Payment','Online Shopping','Cash Withdrawal','Utility Payment')
                          WHEN 'Transfer' THEN ELT(FLOOR(RAND()*4)+1,'Fund Transfer','UPI Payment','NEFT Transfer','IMPS Transfer')
                          WHEN 'EMI'      THEN ELT(FLOOR(RAND()*3)+1,'Home Loan EMI','Car Loan EMI','Personal Loan EMI')
                          ELSE 'Quarterly Interest Credit'
                        END;
        SET v_date = DATE_SUB(NOW(), INTERVAL FLOOR(RAND()*730) DAY);

        INSERT INTO transactions (account_id, transaction_type, amount, balance_after, channel, reference_no, remarks, status, transaction_date)
        VALUES (
            v_acc,
            v_type,
            v_amount,
            ROUND(RAND() * 800000 + 500, 2),
            v_channel,
            CONCAT('TXN', YEAR(v_date), LPAD(i, 8, '0')),
            v_remark,
            v_status,
            v_date
        );
        SET i = i + 1;
    END WHILE;
END$$


-- 3.6 Generate 1000 Loans
CREATE PROCEDURE sp_generate_loans()
BEGIN
    DECLARE i            INT DEFAULT 1;
    DECLARE v_cust       INT;
    DECLARE v_branch     INT;
    DECLARE v_type       VARCHAR(50);
    DECLARE v_principal  DECIMAL(15,2);
    DECLARE v_rate       DECIMAL(5,2);
    DECLARE v_tenure     INT;
    DECLARE v_emi        DECIMAL(15,2);
    DECLARE v_status     VARCHAR(20);
    DECLARE v_disburse   DATE;

    WHILE i <= 1000 DO
        SET v_cust     = FLOOR(RAND() * 2000) + 1;
        SET v_branch   = FLOOR(RAND() * 50) + 1;
        SET v_type     = ELT(FLOOR(RAND()*7)+1,'Home','Car','Personal','Education','Business','Gold','Agricultural');
        SET v_principal = CASE v_type
                            WHEN 'Home'        THEN ROUND(RAND()*4500000 + 500000, 2)
                            WHEN 'Car'         THEN ROUND(RAND()*1400000 + 100000, 2)
                            WHEN 'Personal'    THEN ROUND(RAND()*450000  + 50000, 2)
                            WHEN 'Education'   THEN ROUND(RAND()*1900000 + 100000, 2)
                            WHEN 'Business'    THEN ROUND(RAND()*4000000 + 500000, 2)
                            WHEN 'Gold'        THEN ROUND(RAND()*400000  + 10000, 2)
                            ELSE ROUND(RAND()*900000 + 50000, 2)
                          END;
        SET v_rate    = CASE v_type
                          WHEN 'Home'      THEN ROUND(RAND()*2 + 7.5, 2)
                          WHEN 'Car'       THEN ROUND(RAND()*3 + 8, 2)
                          WHEN 'Personal'  THEN ROUND(RAND()*5 + 11, 2)
                          WHEN 'Education' THEN ROUND(RAND()*2 + 7, 2)
                          WHEN 'Business'  THEN ROUND(RAND()*4 + 10, 2)
                          WHEN 'Gold'      THEN ROUND(RAND()*2 + 8.5, 2)
                          ELSE ROUND(RAND()*3 + 9, 2)
                        END;
        SET v_tenure   = CASE v_type
                           WHEN 'Home'      THEN FLOOR(RAND()*180 + 120)
                           WHEN 'Car'       THEN FLOOR(RAND()*48  + 24)
                           WHEN 'Personal'  THEN FLOOR(RAND()*48  + 12)
                           WHEN 'Education' THEN FLOOR(RAND()*60  + 24)
                           WHEN 'Business'  THEN FLOOR(RAND()*60  + 12)
                           WHEN 'Gold'      THEN FLOOR(RAND()*24  + 3)
                           ELSE FLOOR(RAND()*84 + 12)
                         END;
        SET v_emi      = ROUND((v_principal * v_rate/1200) / (1 - POW(1 + v_rate/1200, -v_tenure)), 2);
        SET v_status   = ELT(FLOOR(RAND()*10)+1,'Active','Active','Active','Active','Active',
                             'Closed','Closed','Defaulted','Pending','Rejected');
        SET v_disburse = DATE_SUB(CURDATE(), INTERVAL FLOOR(RAND()*1200) DAY);

        INSERT INTO loans (customer_id, branch_id, loan_type, principal, interest_rate, tenure_months, emi_amount, outstanding, disbursed_date, status)
        VALUES (
            v_cust, v_branch, v_type, v_principal, v_rate, v_tenure, v_emi,
            ROUND(v_principal * (RAND()*0.9 + 0.05), 2),
            v_disburse, v_status
        );
        SET i = i + 1;
    END WHILE;
END$$


-- 3.7 Generate 2000 Cards
CREATE PROCEDURE sp_generate_cards()
BEGIN
    DECLARE i           INT DEFAULT 1;
    DECLARE v_acc       INT;
    DECLARE v_cust_name VARCHAR(150);
    DECLARE v_ctype     VARCHAR(20);
    DECLARE v_network   VARCHAR(20);
    DECLARE v_limit     DECIMAL(15,2);
    DECLARE v_expiry    DATE;
    DECLARE v_status    VARCHAR(20);

    WHILE i <= 2000 DO
        SET v_acc = FLOOR(RAND() * 3000) + 1;

        SELECT c.full_name INTO v_cust_name
        FROM accounts a JOIN customers c ON a.customer_id = c.customer_id
        WHERE a.account_id = v_acc LIMIT 1;

        SET v_ctype   = ELT(FLOOR(RAND()*10)+1,'Debit','Debit','Debit','Debit','Debit',
                            'Credit','Credit','Credit','Prepaid','Prepaid');
        SET v_network = CASE v_ctype
                          WHEN 'Debit'   THEN ELT(FLOOR(RAND()*3)+1,'RuPay','Visa','Mastercard')
                          WHEN 'Credit'  THEN ELT(FLOOR(RAND()*3)+1,'Visa','Mastercard','Amex')
                          ELSE 'RuPay'
                        END;
        SET v_limit  = CASE v_ctype
                         WHEN 'Credit' THEN ROUND(RAND()*500000 + 25000, 2)
                         ELSE 0
                       END;
        SET v_expiry = DATE_ADD(CURDATE(), INTERVAL (FLOOR(RAND()*4)-1) YEAR);
        SET v_status = ELT(FLOOR(RAND()*10)+1,'Active','Active','Active','Active','Active',
                           'Active','Active','Blocked','Expired','Lost');

        IF v_expiry < CURDATE() THEN SET v_status = 'Expired'; END IF;

        INSERT INTO cards (account_id, card_number, card_type, card_network, card_holder, expiry_date, credit_limit, status)
        VALUES (
            v_acc,
            CONCAT(LPAD(FLOOR(RAND()*9999+1000),4,'0'), ' ',
                   LPAD(FLOOR(RAND()*9999+1000),4,'0'), ' ',
                   LPAD(FLOOR(RAND()*9999+1000),4,'0'), ' ',
                   LPAD(i, 4, '0')),
            v_ctype, v_network,
            UPPER(IFNULL(v_cust_name,'CARD HOLDER')),
            v_expiry, v_limit,
            v_status
        );
        SET i = i + 1;
    END WHILE;
END$$

DELIMITER ;

-- ============================================================
-- Execute Data Generation
-- ============================================================
CALL sp_generate_branches();
CALL sp_generate_customers();
CALL sp_generate_employees();
CALL sp_generate_accounts();
CALL sp_generate_transactions();
CALL sp_generate_loans();
CALL sp_generate_cards();


-- ============================================================
-- SECTION 4: DATA CLEANING
-- ============================================================

-- 4.1 Remove duplicate customers (same email, keep lowest id)
DELETE c1 FROM customers c1
INNER JOIN customers c2
    ON c1.email = c2.email AND c1.customer_id > c2.customer_id;

-- 4.2 Remove duplicate employees (same email, keep lowest id)
DELETE e1 FROM employees e1
INNER JOIN employees e2
    ON e1.email = e2.email AND e1.employee_id > e2.employee_id;

-- 4.3 Remove duplicate accounts (same account_number)
DELETE a1 FROM accounts a1
INNER JOIN accounts a2
    ON a1.account_number = a2.account_number AND a1.account_id > a2.account_id;

-- 4.4 Handle NULL phone numbers
UPDATE customers SET phone = CONCAT('9000', LPAD(customer_id, 6,'0')) WHERE phone IS NULL OR phone = '';
UPDATE employees SET phone = CONCAT('8000', LPAD(employee_id, 6,'0')) WHERE phone IS NULL OR phone = '';

-- 4.5 Handle NULL cities / states
UPDATE customers SET city  = 'Unknown' WHERE city  IS NULL OR city  = '';
UPDATE customers SET state = 'Unknown' WHERE state IS NULL OR state = '';

-- 4.6 Standardise customer and employee names to Proper Case (Title Case via CONCAT)
UPDATE customers
SET full_name = CONCAT(
    UPPER(SUBSTRING(SUBSTRING_INDEX(full_name,' ',1),1,1)),
    LOWER(SUBSTRING(SUBSTRING_INDEX(full_name,' ',1),2)),
    ' ',
    UPPER(SUBSTRING(SUBSTRING_INDEX(full_name,' ',-1),1,1)),
    LOWER(SUBSTRING(SUBSTRING_INDEX(full_name,' ',-1),2))
);

-- 4.7 Standardise emails to lowercase
UPDATE customers SET email = LOWER(TRIM(email));
UPDATE employees SET email = LOWER(TRIM(email));

-- 4.8 Fix negative balances
UPDATE accounts SET balance = ABS(balance) WHERE balance < 0;

-- 4.9 Fix negative transaction amounts
UPDATE transactions SET amount = ABS(amount) WHERE amount < 0;

-- 4.10 Fix negative loan principals
UPDATE loans SET principal = ABS(principal) WHERE principal < 0;

-- 4.11 Set NULL loan outstanding = principal where NULL
UPDATE loans SET outstanding = principal WHERE outstanding IS NULL;

-- 4.12 Auto-expire cards past expiry date
UPDATE cards SET status = 'Expired' WHERE expiry_date < CURDATE() AND status = 'Active';

-- 4.13 Fix accounts with balance below minimum — log them (view only, no destructive change)
-- SELECT account_id, balance, minimum_balance FROM accounts WHERE balance < minimum_balance AND status = 'Active';
UPDATE accounts SET status = 'Inactive' WHERE balance < minimum_balance AND status = 'Active';

-- 4.14 Remove clearly failed/stuck transactions older than 2 years
DELETE FROM transactions
WHERE status = 'Failed'
  AND transaction_date < DATE_SUB(NOW(), INTERVAL 2 YEAR);


-- ============================================================
-- SECTION 5: PERFORMANCE INDEXES
-- ============================================================

CREATE INDEX idx_txn_account_id       ON transactions(account_id);
CREATE INDEX idx_txn_date             ON transactions(transaction_date);
CREATE INDEX idx_txn_status           ON transactions(status);
CREATE INDEX idx_txn_type             ON transactions(transaction_type);
CREATE INDEX idx_txn_amount           ON transactions(amount);

CREATE INDEX idx_acc_customer_id      ON accounts(customer_id);
CREATE INDEX idx_acc_branch_id        ON accounts(branch_id);
CREATE INDEX idx_acc_status           ON accounts(status);
CREATE INDEX idx_acc_type             ON accounts(account_type);

CREATE INDEX idx_loan_customer_id     ON loans(customer_id);
CREATE INDEX idx_loan_status          ON loans(status);
CREATE INDEX idx_loan_type            ON loans(loan_type);

CREATE INDEX idx_emp_branch_id        ON employees(branch_id);
CREATE INDEX idx_emp_status           ON employees(status);

CREATE INDEX idx_card_account_id      ON cards(account_id);
CREATE INDEX idx_card_status          ON cards(status);
CREATE INDEX idx_card_type            ON cards(card_type);

CREATE INDEX idx_cust_city            ON customers(city);
CREATE INDEX idx_cust_kyc             ON customers(kyc_status);


-- ============================================================
-- SECTION 6: VIEW — High Balance Customers
-- ============================================================

CREATE OR REPLACE VIEW vw_high_balance_customers AS
SELECT
    c.customer_id,
    c.full_name,
    c.email,
    c.phone,
    c.city,
    c.state,
    c.kyc_status,
    a.account_id,
    a.account_number,
    a.account_type,
    b.bank_name,
    b.branch_name,
    a.balance,
    a.status AS account_status
FROM customers c
JOIN accounts  a ON c.customer_id = a.customer_id
JOIN branches  b ON a.branch_id   = b.branch_id
WHERE a.balance  > 500000
  AND a.status   = 'Active'
  AND c.kyc_status = 'Verified'
ORDER BY a.balance DESC;


-- ============================================================
-- SECTION 7: TRIGGER — Auto Update Balance After Transaction
-- ============================================================

DELIMITER $$

CREATE TRIGGER trg_auto_update_balance
AFTER INSERT ON transactions
FOR EACH ROW
BEGIN
    IF NEW.status = 'Success' THEN
        IF NEW.transaction_type IN ('Deposit','Interest') THEN
            UPDATE accounts
            SET balance = balance + NEW.amount
            WHERE account_id = NEW.account_id;

        ELSEIF NEW.transaction_type IN ('Withdraw','Transfer','EMI') THEN
            UPDATE accounts
            SET balance = GREATEST(balance - NEW.amount, 0)
            WHERE account_id = NEW.account_id;
        END IF;

        -- Update balance_after in the same transaction row
        UPDATE transactions t
        JOIN  accounts a ON t.account_id = a.account_id
        SET   t.balance_after = a.balance
        WHERE t.transaction_id = NEW.transaction_id;
    END IF;
END$$

DELIMITER ;


-- ============================================================
-- SECTION 8: STORED PROCEDURE — Money Transfer
-- ============================================================

DELIMITER $$

CREATE PROCEDURE sp_transfer_money(
    IN  p_from_acc  INT,
    IN  p_to_acc    INT,
    IN  p_amount    DECIMAL(15,2),
    IN  p_channel   VARCHAR(50),
    OUT p_status    VARCHAR(10),
    OUT p_message   VARCHAR(500)
)
BEGIN
    DECLARE v_from_bal    DECIMAL(15,2) DEFAULT 0;
    DECLARE v_from_status VARCHAR(20);
    DECLARE v_to_status   VARCHAR(20);
    DECLARE v_ref_no      VARCHAR(50);

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SET p_status  = 'ERROR';
        SET p_message = 'Transaction failed due to a database error. Rolled back.';
    END;

    START TRANSACTION;

    SELECT balance, status INTO v_from_bal, v_from_status
    FROM accounts WHERE account_id = p_from_acc FOR UPDATE;

    SELECT status INTO v_to_status
    FROM accounts WHERE account_id = p_to_acc FOR UPDATE;

    IF v_from_status IS NULL THEN
        SET p_status = 'FAILED'; SET p_message = 'Sender account not found.';
        ROLLBACK;

    ELSEIF v_to_status IS NULL THEN
        SET p_status = 'FAILED'; SET p_message = 'Receiver account not found.';
        ROLLBACK;

    ELSEIF v_from_status != 'Active' THEN
        SET p_status = 'FAILED'; SET p_message = CONCAT('Sender account is ', v_from_status, '. Transfer not allowed.');
        ROLLBACK;

    ELSEIF v_to_status != 'Active' THEN
        SET p_status = 'FAILED'; SET p_message = CONCAT('Receiver account is ', v_to_status, '. Transfer not allowed.');
        ROLLBACK;

    ELSEIF p_amount <= 0 THEN
        SET p_status = 'FAILED'; SET p_message = 'Transfer amount must be greater than zero.';
        ROLLBACK;

    ELSEIF v_from_bal < p_amount THEN
        SET p_status = 'FAILED';
        SET p_message = CONCAT('Insufficient balance. Available: ₹', FORMAT(v_from_bal,2), ', Requested: ₹', FORMAT(p_amount,2));
        ROLLBACK;

    ELSE
        SET v_ref_no = CONCAT('TRF', DATE_FORMAT(NOW(),'%Y%m%d%H%i%s'), p_from_acc, p_to_acc);

        UPDATE accounts SET balance = balance - p_amount WHERE account_id = p_from_acc;
        UPDATE accounts SET balance = balance + p_amount WHERE account_id = p_to_acc;

        INSERT INTO transactions (account_id, transaction_type, amount, channel, reference_no, remarks, status, transaction_date)
        VALUES (p_from_acc, 'Transfer', p_amount, IFNULL(p_channel,'Net Banking'),
                CONCAT(v_ref_no,'D'), CONCAT('Transfer to Account #', p_to_acc), 'Success', NOW());

        INSERT INTO transactions (account_id, transaction_type, amount, channel, reference_no, remarks, status, transaction_date)
        VALUES (p_to_acc, 'Deposit', p_amount, IFNULL(p_channel,'Net Banking'),
                CONCAT(v_ref_no,'C'), CONCAT('Transfer from Account #', p_from_acc), 'Success', NOW());

        COMMIT;
        SET p_status  = 'SUCCESS';
        SET p_message = CONCAT('₹', FORMAT(p_amount,2), ' transferred successfully from Account #',
                               p_from_acc, ' to Account #', p_to_acc, '. Ref: ', v_ref_no);
    END IF;
END$$

DELIMITER ;

-- Test transfer
CALL sp_transfer_money(1, 2, 10000.00, 'UPI', @st, @msg);
SELECT @st AS transfer_status, @msg AS message;


-- ============================================================
-- SECTION 9: DATA ANALYSIS QUERIES
-- ============================================================

-- 9.1 Top 10 Customers by Total Balance
SELECT
    c.customer_id,
    c.full_name,
    c.city,
    c.state,
    COUNT(a.account_id)         AS total_accounts,
    SUM(a.balance)              AS total_balance,
    MAX(a.balance)              AS highest_single_balance,
    c.kyc_status
FROM customers c
JOIN accounts a ON c.customer_id = a.customer_id
WHERE a.status = 'Active'
GROUP BY c.customer_id, c.full_name, c.city, c.state, c.kyc_status
ORDER BY total_balance DESC
LIMIT 10;

-- 9.2 Total Transactions per Account (with customer name)
SELECT
    a.account_id,
    a.account_number,
    a.account_type,
    c.full_name,
    c.city,
    COUNT(t.transaction_id)                                                  AS total_txns,
    ROUND(SUM(t.amount), 2)                                                  AS total_volume,
    ROUND(AVG(t.amount), 2)                                                  AS avg_txn_amount,
    SUM(CASE WHEN t.status = 'Success' THEN 1 ELSE 0 END)                   AS success_count,
    SUM(CASE WHEN t.status = 'Failed'  THEN 1 ELSE 0 END)                   AS failed_count
FROM accounts a
JOIN customers c    ON a.customer_id = c.customer_id
LEFT JOIN transactions t ON a.account_id = t.account_id
GROUP BY a.account_id, a.account_number, a.account_type, c.full_name, c.city
ORDER BY total_txns DESC
LIMIT 20;

-- 9.3 Monthly Transaction Summary (last 24 months)
SELECT
    YEAR(transaction_date)      AS yr,
    MONTH(transaction_date)     AS mo,
    MONTHNAME(transaction_date) AS month_name,
    COUNT(*)                    AS total_transactions,
    ROUND(SUM(amount), 2)       AS total_amount,
    ROUND(AVG(amount), 2)       AS avg_amount,
    ROUND(SUM(CASE WHEN transaction_type='Deposit'  THEN amount ELSE 0 END),2) AS deposits,
    ROUND(SUM(CASE WHEN transaction_type='Withdraw' THEN amount ELSE 0 END),2) AS withdrawals,
    ROUND(SUM(CASE WHEN transaction_type='Transfer' THEN amount ELSE 0 END),2) AS transfers,
    SUM(CASE WHEN status='Success' THEN 1 ELSE 0 END) AS success_txns,
    SUM(CASE WHEN status='Failed'  THEN 1 ELSE 0 END) AS failed_txns
FROM transactions
WHERE transaction_date >= DATE_SUB(NOW(), INTERVAL 24 MONTH)
GROUP BY yr, mo, month_name
ORDER BY yr DESC, mo DESC;

-- 9.4 Loan Analysis — Total Loans per Customer
SELECT
    c.customer_id,
    c.full_name,
    c.city,
    COUNT(l.loan_id)                                                          AS total_loans,
    ROUND(SUM(l.principal), 2)                                                AS total_borrowed,
    ROUND(SUM(l.outstanding), 2)                                              AS total_outstanding,
    ROUND(AVG(l.interest_rate), 2)                                            AS avg_interest_rate,
    SUM(CASE WHEN l.status='Active'    THEN 1 ELSE 0 END)                    AS active_loans,
    SUM(CASE WHEN l.status='Defaulted' THEN 1 ELSE 0 END)                    AS defaulted_loans,
    ROUND(SUM(CASE WHEN l.status='Defaulted' THEN l.outstanding ELSE 0 END),2) AS defaulted_amount
FROM customers c
JOIN loans l ON c.customer_id = l.customer_id
GROUP BY c.customer_id, c.full_name, c.city
ORDER BY total_borrowed DESC
LIMIT 20;

-- 9.5 Fraud Detection — Large Transactions (> ₹1,00,000)
SELECT
    t.transaction_id,
    t.reference_no,
    c.full_name           AS customer_name,
    c.phone,
    a.account_number,
    a.account_type,
    t.transaction_type,
    ROUND(t.amount, 2)    AS amount,
    t.channel,
    t.status,
    t.transaction_date,
    b.bank_name,
    b.city                AS branch_city
FROM transactions t
JOIN accounts  a ON t.account_id   = a.account_id
JOIN customers c ON a.customer_id  = c.customer_id
JOIN branches  b ON a.branch_id    = b.branch_id
WHERE t.amount > 100000
ORDER BY t.amount DESC;

-- 9.6 Inactive Accounts (no transaction in last 180 days)
SELECT
    a.account_id,
    a.account_number,
    a.account_type,
    ROUND(a.balance, 2)                                   AS current_balance,
    c.full_name,
    c.email,
    c.phone,
    c.city,
    MAX(t.transaction_date)                               AS last_txn_date,
    DATEDIFF(NOW(), MAX(t.transaction_date))              AS days_since_last_txn
FROM accounts a
JOIN customers c         ON a.customer_id = c.customer_id
LEFT JOIN transactions t ON a.account_id  = t.account_id
GROUP BY a.account_id, a.account_number, a.account_type, a.balance,
         c.full_name, c.email, c.phone, c.city
HAVING last_txn_date IS NULL
    OR last_txn_date < DATE_SUB(NOW(), INTERVAL 180 DAY)
ORDER BY days_since_last_txn DESC;

-- 9.7 Branch Performance — Accounts, Deposits, Employees
SELECT
    b.branch_id,
    b.bank_name,
    b.branch_name,
    b.city,
    b.state,
    COUNT(DISTINCT a.account_id)                          AS total_accounts,
    ROUND(SUM(a.balance), 2)                             AS total_deposits,
    ROUND(AVG(a.balance), 2)                             AS avg_balance,
    COUNT(DISTINCT e.employee_id)                        AS total_employees,
    ROUND(AVG(e.salary), 2)                              AS avg_employee_salary,
    COUNT(DISTINCT l.loan_id)                            AS total_loans,
    ROUND(SUM(l.principal), 2)                           AS total_loan_amount
FROM branches b
LEFT JOIN accounts  a ON b.branch_id = a.branch_id
LEFT JOIN employees e ON b.branch_id = e.branch_id AND e.status = 'Active'
LEFT JOIN loans     l ON b.branch_id = l.branch_id AND l.status = 'Active'
GROUP BY b.branch_id, b.bank_name, b.branch_name, b.city, b.state
ORDER BY total_deposits DESC;

-- 9.8 Failed vs Successful Transactions by Channel
SELECT
    channel,
    transaction_type,
    COUNT(*)                  AS total_count,
    ROUND(SUM(amount), 2)     AS total_amount,
    ROUND(AVG(amount), 2)     AS avg_amount,
    SUM(CASE WHEN status='Success' THEN 1 ELSE 0 END)  AS success_count,
    SUM(CASE WHEN status='Failed'  THEN 1 ELSE 0 END)  AS failed_count,
    ROUND(SUM(CASE WHEN status='Success' THEN 1 ELSE 0 END)*100.0/COUNT(*),2) AS success_rate_pct
FROM transactions
GROUP BY channel, transaction_type
ORDER BY total_count DESC;

-- 9.9 Average Balance by Account Type
SELECT
    account_type,
    COUNT(*)                       AS total_accounts,
    ROUND(AVG(balance), 2)         AS avg_balance,
    ROUND(MIN(balance), 2)         AS min_balance,
    ROUND(MAX(balance), 2)         AS max_balance,
    ROUND(SUM(balance), 2)         AS total_funds
FROM accounts
WHERE status = 'Active'
GROUP BY account_type
ORDER BY avg_balance DESC;

-- 9.10 Loan Defaulters Detail
SELECT
    c.customer_id,
    c.full_name,
    c.email,
    c.phone,
    c.city,
    l.loan_id,
    l.loan_type,
    ROUND(l.principal, 2)      AS loan_principal,
    ROUND(l.outstanding, 2)    AS outstanding_amount,
    l.interest_rate,
    l.tenure_months,
    l.disbursed_date,
    b.bank_name,
    b.branch_name
FROM loans l
JOIN customers c ON l.customer_id = c.customer_id
JOIN branches  b ON l.branch_id   = b.branch_id
WHERE l.status = 'Defaulted'
ORDER BY l.outstanding DESC;

-- 9.11 City-wise Customer and Balance Distribution
SELECT
    c.city,
    c.state,
    COUNT(DISTINCT c.customer_id)   AS total_customers,
    COUNT(DISTINCT a.account_id)    AS total_accounts,
    ROUND(SUM(a.balance), 2)        AS total_balance,
    ROUND(AVG(a.balance), 2)        AS avg_balance,
    COUNT(DISTINCT l.loan_id)       AS total_loans,
    ROUND(SUM(l.principal), 2)      AS total_loan_value
FROM customers c
LEFT JOIN accounts a ON c.customer_id = a.customer_id AND a.status='Active'
LEFT JOIN loans    l ON c.customer_id = l.customer_id AND l.status='Active'
GROUP BY c.city, c.state
ORDER BY total_balance DESC;

-- 9.12 Card Type and Network Distribution
SELECT
    card_type,
    card_network,
    COUNT(*)                                                    AS total_cards,
    SUM(CASE WHEN status='Active'  THEN 1 ELSE 0 END)          AS active,
    SUM(CASE WHEN status='Blocked' THEN 1 ELSE 0 END)          AS blocked,
    SUM(CASE WHEN status='Expired' THEN 1 ELSE 0 END)          AS expired,
    SUM(CASE WHEN status='Lost'    THEN 1 ELSE 0 END)          AS lost,
    ROUND(AVG(credit_limit), 2)                                AS avg_credit_limit,
    ROUND(SUM(credit_limit), 2)                                AS total_credit_exposure
FROM cards
GROUP BY card_type, card_network
ORDER BY card_type, total_cards DESC;

-- 9.13 High-Risk Accounts (large txns + defaulted loan)
SELECT DISTINCT
    c.customer_id,
    c.full_name,
    c.phone,
    c.city,
    a.account_number,
    ROUND(a.balance, 2)       AS balance,
    MAX(t.amount)             AS max_single_txn,
    COUNT(t.transaction_id)   AS large_txn_count,
    l.loan_type,
    ROUND(l.outstanding, 2)   AS loan_outstanding
FROM customers c
JOIN accounts     a ON c.customer_id = a.customer_id
JOIN transactions t ON a.account_id  = t.account_id AND t.amount > 100000
JOIN loans        l ON c.customer_id = l.customer_id AND l.status = 'Defaulted'
GROUP BY c.customer_id, c.full_name, c.phone, c.city,
         a.account_number, a.balance, l.loan_type, l.outstanding
ORDER BY max_single_txn DESC;


-- ============================================================
-- SECTION 10: CLEANUP HELPER TABLES
-- ============================================================

DROP TABLE IF EXISTS tmp_first_names;
DROP TABLE IF EXISTS tmp_last_names;
DROP TABLE IF EXISTS tmp_cities;
DROP TABLE IF EXISTS tmp_areas;
DROP TABLE IF EXISTS tmp_streets;
DROP TABLE IF EXISTS tmp_banks;
select * from customers;
-- ============================================================
-- END OF BANKING MANAGEMENT SYSTEMaccount_numberaccount_numberaccount_numberaccount_typeaccount_typeemail
-- ============================================================
