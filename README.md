# Health Outreach SQL

This project sets up and manages a simple health outreach 
scheduling system using SQL Server. It includes schema 
creation, data population, and a variety of useful queries 
for analysis and management.

## Table of Contents

* [Project Overview](#project-overview)
* [Technology Stack](#technology-stack)
* [Project Structure](#project-structure)
* [Installation and Setup](#installation-and-setup)
* [Features](#features)
* [Model Implementation](#model-implementation)
* [Controller Implementation](#controller-implementation)
* [View Implementation](#view-implementation)
* [Styling and Design](#styling-and-design)
* [Running the Application](#running-the-application)
* [Disclaimer](#disclaimer)

## Project Overview

The Health Outreach SQL project is designed to simulate a scheduling and reporting system for medical outreach programs. It includes:

* Database creation and schema setup
* Insertions of initial records
* Queries to retrieve insights like booking status, doctor availability, and performance metrics

## Technology Stack

* **Database**: Microsoft SQL Server
* **Language**: T-SQL
* **Environment**: SSMS / Azure Data Studio
* **File**: `solutions.sql`

## Project Structure

```
health-outreach-sql/
├── solutions.sql        -- All schema, insert, and query scripts
├── README.md            -- Project documentation
```

## Installation and Setup

1. Clone the repository:

   ```bash
   git clone https://github.com/HChristopherNaoyuki/health-outreach-sql.git
   cd health-outreach-sql
   ```

2. Open `solutions.sql` in SQL Server Management Studio or Azure Data Studio.

3. Run the script section by section to:

   * Create and select the database
   * Create all tables
   * Populate data
   * Execute reporting and analytics queries

## Features

* Setup of three core tables: `DOCTOR`, `CLINIC`, `OUTREACH`
* Data integrity via primary keys, foreign keys, and constraints
* Insertion of sample data for testing and analytics
* SQL queries for common business scenarios:

  * Doctors without outreach events
  * Total seats per doctor
  * Most attended outreach event per doctor
  * Booking pressure (fill rate ≥ 50%)

## Model Implementation

**Tables:**

* `DOCTOR`: Stores doctor details (name, email, specialty, status)
* `CLINIC`: Stores clinic information (name, address)
* `OUTREACH`: Tracks outreach events, linking doctors and clinics with event dates, available seats, booking stats, and status

**Constraints:**

* Primary keys on IDs
* Unique constraint on doctor email
* Foreign keys in `OUTREACH`
* CHECK constraints for valid values and ranges

## Controller Implementation

**Data Manipulation Statements:**

* `INSERT INTO` statements populate initial data
* `UPDATE` used for changing seat bookings
* `ALTER TABLE` available for modifying constraints

## View Implementation

**Queries for Reports:**

* Doctors without scheduled outreach
* Total available seats per doctor
* Best clinic for a specific doctor based on seat availability
* Booking fill rate analysis

## Styling and Design

As this is a backend-only SQL implementation, no frontend styling or UI design is included. However, the script is logically structured in sections:

* **Section A**: Database setup and data insertion
* **Section B**: Query-based reporting and analysis
* **Section C**: Indexing and integrity testing (optional)

## Running the Application

1. Execute the script in a SQL Server environment.
2. View results of SELECT statements for each section.
3. Modify or extend the script to suit new business rules or datasets.

## Disclaimer

This project is educational and intended for demonstration purposes. 
It is not meant for production use in clinical or patient-facing environments. 
Always ensure data protection and compliance when working with real health data.

---
