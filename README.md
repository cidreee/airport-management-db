# Airport Management Database System 

This project implements an **Airport Management System** as part of the *Advanced Databases* course.  
It includes data modeling, database design, and automation of key airport operations using **SQL** with stored procedures, triggers, transactions, and views.  

---

## Main Features

- **E-R Model & Data Dictionary**  
  - Tables for airlines, aircrafts, flights, routes, passengers, crew, reservations, maintenance, notifications, and payments.  
  - Well-defined relationships with primary and foreign keys.  
  - Data types adapted to specific requirements.  

- **Views**  
  - Frequent passengers.  
  - Daily flights.  
  - Aircrafts under maintenance.  

- **Stored Procedures**  
  - **Crew assignment** with flight hours balance.  
  - **Automatic check-in** 24 hours before flight.  
  - **Punctuality statistics** (on-time vs delayed).  

- **Triggers**  
  - Automatic update of aircraft status during maintenance.  
  - Email notifications for delayed flights.  
  - Loyalty program updates based on passenger activity.  

- **Transactions**  
  - Reservation process: create reservation, update seats, and register payment in a single transaction.  

- **Security & Roles**  
  - Role-based access with permissions for: administrator, flight operations, customer service, payments, and analytics.  

- **Data Visualization (Python Dashboard)**  
  - Number of flights per month (trends).  
  - Monthly income (payments).  
  - Average route duration.  
  - Current flight status.  
  - Most experienced pilots.  
  - Passengers’ nationalities.  
  - Most traveled routes.  

---

## 🛠️ Technologies
- **MySQL / Advanced SQL** (procedures, triggers, transactions, roles).  
- **Python** (data visualization dashboard).  

---

## Project Structure
- `sql/` → Database creation scripts (tables, views, procedures)  
- `dashboard/` → Python code for data visualization  
- `docs/` → Project presentation and documentation  
- `README.md` → Project description

---

## Authors

- Pablo Iván Pérez Jáuregui  
- Valeria Marian Andrade Monreal  

---
