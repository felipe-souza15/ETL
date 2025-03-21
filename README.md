🧩 SQL ETL - Customer Product Classification

🚀 About This Repository  
This repository contains a complete SQL transformation logic (T-SQL) using **Common Table Expressions (CTEs)** to classify customers based on their billing behavior. It is part of the ETL (Extract, Transform, Load) process and helps identify product usage patterns across active customers.

The logic includes filters for customer validity, exclusion of some products, and identification of customers who only use the **minimum VCM package**.

---

📊 Business Rules & Classification

✔ Valid and active customers only  
✔ Excludes SH, demo, suspended, and delinquent customers  
✔ Identifies customers **without Serasa Alert**  
✔ Flags customers using **MeProteja (00180)**  
✔ Flags customers using **only VCM (00118 and 00186)**  

---

📈 Why Use This Repository?  
This SQL logic is modular, readable, and ready to plug into ETL pipelines or reporting processes. It uses **CTEs** to structure the logic step-by-step, making it easy to maintain and extend.  

Ideal for data analysts, BI developers, and teams looking to implement product segmentation or customer behavior flags within their data warehouse or reporting layer.

---

🧰 Tables Used

- `Customer` 
- `Franchise` 
- `Transactions_202502`
- `BillingSuspendedCustomers`
- `DelinquentCustomers` 

---

📌 Built With

- Microsoft SQL Server (T-SQL)  
- Common Table Expressions (CTEs)  
- Business Rules & Data Filtering  

---

👨‍💻 Author  
**Felipe De Souza Lopes**  
(https://www.linkedin.com/in/felipesouzalopes15)

---

⭐ If you find this repository useful, give it a star and connect with me on LinkedIn!
