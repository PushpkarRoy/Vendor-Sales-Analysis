# 📦 Vendor Sales Analysis Project

> 🔍 A complete data analysis project using Python, SQL, and Power BI to uncover business insights, optimize vendor performance, and drive procurement efficiency across a large-scale retail and e-commerce network.

[![Dashboard Banner](https://your-link-to-powerbi-image.png)](https://github.com/PushpkarRoy/Vendor-Sales-Analysis/blob/main/Vendor%20Sales%20Analysis%20Dashboard.png)

---

## 🧠 Project Objective

The goal of this project is to analyze vendor performance across purchasing, inventory, and sales dimensions to:
- Identify top-performing and underperforming vendors
- Optimize inventory turnover and procurement spending
- Uncover hidden profit opportunities in high-margin, low-sales products
- Enable data-driven decisions through interactive dashboards
    
---

## 📂 Dataset Overview

| Table Name         | Description                          | Rows       |
|--------------------|--------------------------------------|------------|
| `begin_inventory`  | Starting inventory snapshot          | 206K       |
| `end_inventory`    | Ending stock levels                  | 2M+        |
| `purchase_prices`  | Vendor price reference data          | 110K       |
| `purchases`        | All vendor purchase transactions     | 16.7M      |
| `sales`            | All product sales transactions       | 14.6M      |
| `vendor_invoice`   | Vendor invoice, freight & approval   | 50K        |

---

## 🐍 Python Analysis

Used Python (Pandas) for:
- Data cleaning and joining multi-million row datasets
- Feature engineering (gross profit, margins, tax)
- Exporting a summarized vendor-product table for SQL & dashboarding

📄 Output file: `vendor_summary_table.csv`

[![Python Code Sample](https://your-link-to-python-code-image.png)](https://github.com/PushpkarRoy/Vendor-Sales-Analysis/blob/main/Python_Jupiter.png)

---

## 🧮 SQL Analysis

PostgreSQL was used to:
- Calculate sales-to-purchase ratios and stock turnover
- Identify blocked capital in unsold inventory
- Rank vendors by efficiency, margin, and ROI
- Generate KPIs for dashboard integration

📁 File: `dB_Analysis_SQL.sql`

[![SQL Query Sample](https://your-link-to-sql-query-image.png)](https://github.com/PushpkarRoy/Vendor-Sales-Analysis/blob/main/SQL%20SS_Image.png)

---

## 📊 Power BI Dashboard

Interactive visual dashboard showing:
- Total purchase/sales value
- Gross profit vs excise tax
- Top vendors by profit and volume
- Low-sales, high-margin vendors
- Unit price comparison across brands

📈 KPI Cards, Pie Charts, Line + Bar Mix

[![Power BI Dashboard](https://your-link-to-dashboard-image.png)](https://github.com/PushpkarRoy/Vendor-Sales-Analysis/blob/main/Vendor%20Sales%20Analysis%20Dashboard.png)

---

## 📌 Key Business Insights

- **Top 10 vendors = 65%+ of spend** → overdependence risk
- **₹50+ lakhs stuck in unsold stock** → blocked working capital
- **Low-turnover vendors** with poor performance flagged
- **Bulk buying doesn’t guarantee savings** → higher unit cost observed
- **High-margin brands underperforming** in volume → promotion potential

---

## 🚀 Tools & Tech Used

| Tool         | Purpose                              |
|--------------|--------------------------------------|
| **Python**   | Data cleaning & aggregation          |
| **PostgreSQL**| Advanced SQL analysis                |
| **Power BI** | Dashboard creation & reporting       |
| **Pandas/Numpy** | Data transformation              |

---

## 📈 Project Impact

This project shows how **data can unlock hidden value** in vendor management and procurement by turning raw transactions into business strategy.

> ✅ Scalable to millions of rows  
> ✅ Optimized for business decisions  
> ✅ Structured and storytelling-ready

---

## 📎 Files Included

📁 /notebooks/Exploratory Data Analysis.ipynb
📁 /sql/dB_Analysis_SQL.sql
📁 /outputs/vendor_summary_table.csv
📁 /dashboard/PowerBI_Dashboard.pbix


---

## 🙌 Acknowledgments

This project was built independently by [Pushpkar Roy](https://github.com/PushpkarRoy) as part of a 30-Day Analytics Challenge to build practical, industry-ready data solutions.

---

## 🔗 Connect with Me

- 📧 Email: pushpkarroy880@gmail.com  
- 💼 LinkedIn: [linkedin.com/in/pushpkar-roy](https://www.linkedin.com/in/pushpkar-roy/)  
- 💻 GitHub: [github.com/PushpkarRoy](https://github.com/PushpkarRoy)

---

> ⭐ If you found this project helpful or inspiring, don’t forget to **star** the repo!

