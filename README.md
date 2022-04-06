# RDBMS-Project_USMuseum-Analysis
As a museum lover, I always acquire lots of knowledge from them. But sometimes I can’t help but wonder, students usually have discounts for some particular museums, and the everyone’s visiting frequency for one specific museum is not that high, so...do they really earn enough money to operate?
So the Business problem space I wanna explore is “How’s museum’s financial condition in the US? What kind of museums earn the most?”

## Data source:
I found a dataset on Kaggle, regarding Name, location, and revenue for every museum in the United States It contains basic information of the museum like Museums’ name, museum types location, phone number as well as what I need– its Income, Revenue (some financial related data)
The basic information contained in the dataset is quite detailed. It includes state, city, county and address, so that I can classify, or group by the data I need, Or to examine museums’ financial condition with different aspects in my following steps.

## The whole project contains:
1. **Entity Relationship Diagram (ERD):** Originally the dataset is a single spreadsheet with all the information regarding the museums. So, I have to develop it from UNF to 3NF
2. **Physical Database Design:**
- Create database
- Create 9 tables based on ERD structure
- Code INSERT INTO statements (five rows) for each table that does not have a foreign key
- 5 stored procedure to INSERT a new row in tables in my project that has a foreign key
- SQL code to create two business rules & two computed columns leveraging UDFs

## Two complex queries with SQL that I used to answer the financial related questions that I’m curious about:
1. What are the top 5 museums with best financial condition(judging by income) by city in U.S.A.?
2. What are the top 3 types of museum earning highest income in Alaska in 2014?
