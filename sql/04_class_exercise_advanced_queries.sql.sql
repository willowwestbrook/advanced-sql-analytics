#class exercise 2/12/25
#question 1
#Based on the following ERD, write the SQL statements to create the Magazine and the Publisher Table.  
#Make sure to name the foreign key(s) with constraint(s).
#   customer(customer_id, customer_name, customer_email, customer_address)
  #  magazine(magazine_id, magazine_title, magazine_genre, publisher_id)
   # subscription(subscription_id, customer_id, magazine_id, subscription_start_date, subscription_end_date)
    #publisher(publisher_id, publisher_name, publisher_country)

CREATE TABLE Publisher (
    publisher_id INT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    address VARCHAR(255)
);

create table Magazine (
    magazine_id int primary key,
    title VARCHAR(255) NOT NULL,
    issue_number INT,
    publisher_id INT,
    FOREIGN KEY (publisher_id) REFERENCES Publisher(publisher_id) ON DELETE CASCADE
);

#question 2
#Write sql statement that would add a phone number field to the publisher table shown above. 

alter table Publisher
ADD phone_number varchar(20);

#question 3
#The start date on the subscription table was created using VARCHAR(20).  
#Write sql statement that would change it to a DATE field

alter table 


#question 4
#Write sql statements that would accomplish the following (assume that publisher table already exists in the database and you have full access to it): (2 + 3 + 1 = 6 points)
#Remove the current primary key
#Make the Name of the publisher as the primary key
#If you try to do it in a live database with the above tables, what problem would you face?

#question 5
CREATE TABLE Subscription (
    subscription_id INT PRIMARY KEY,
    customer_id INT,
    magazine_id INT,
    subscription_start_date DATE,
    subscription_end_date DATE,
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id),
    FOREIGN KEY (magazine_id) REFERENCES Magazine(magazine_id)
);

INSERT INTO Subscription
    (subscription_id, customer_id, magazine_id, subscription_start_date, subscription_end_date)
VALUES
    (8, 1, 2, '2025-02-01', '2026-03-01');

#question 6
UPDATE Customer
SET email = 'david.brown@gmail.com'
WHERE name = 'David Brown';


