# STORE_PROCEDURE 
# 📚 Library Management System – SQL Project

This project is a simple **Library Management System** developed using **SQL**. It demonstrates how to design and manage a basic relational database system to handle books, members, and rentals.

## 📌 Project Overview

The project includes:
- Creation of a database named `SQL_PROJECT`
- Design and creation of 3 core tables:
  - `books`
  - `members`
  - `rental`
- Use of **primary keys**, **foreign keys**, **auto-increment**, and **constraints**
- Insertion of sample data
- Execution of useful queries to analyze rental data and manage library operations

## 🧱 Database Structure

### 1. `books` Table
- `bookid`: Primary Key, Auto Increment
- `title`: Title of the book
- `author`: Author's name
- `copiesavailable`: Number of copies available

### 2. `members` Table
- `memberid`: Primary Key, Auto Increment
- `name`: Member's name
- `email`: Unique Email ID
- `membershipdate`: Date of registration

### 3. `rental` Table
- `rentalid`: Primary Key, Auto Increment
- `bookid`: Foreign Key referencing `books`
- `memberid`: Foreign Key referencing `members`
- `rentaldate`: Date when the book was rented
- `returndate`: Date when the book was returned

## 🛠️ Sample Features Implemented
- Book issue and return tracking
- Membership and borrowing history
- Data integrity through foreign key relationships
- Sample data population

## 🚀 How to Use

1. Open your MySQL environment (e.g., MySQL Workbench, XAMPP, or any SQL editor)
2. Run the script `SQLProj_SHYAM.sql.sql`
3. Explore the database and execute custom queries for data analysis

## 🧠 Skills Demonstrated

- SQL DDL (CREATE, ALTER)
- SQL DML (INSERT, SELECT)
- Relationships and constraints
- Database normalization concepts

## 📂 File Structure


- Add fine calculation for late returns
- Add book categories/genres
- Create views or stored procedures for reports

