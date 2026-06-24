# MySQL-Layoffs-EDA
Exploratory Data Analysis on global tech layoffs (2020-2023) using MySQL — trends by industry, country, year, and company stage.

## 📌 Project Overview

This project performs an **Exploratory Data Analysis (EDA)** on a global tech layoffs dataset using MySQL. The goal is to uncover trends, patterns, and insights about layoffs that occurred between 2020 and 2023 — covering the pandemic period, the post-pandemic hiring boom, and the subsequent tech sector correction.

The dataset was sourced from [Alex The Analyst's MySQL YouTube Series](https://github.com/AlexTheAnalyst/MySQL-YouTube-Series) and was first cleaned using MySQL before analysis.

---

## 🔍 Business Questions Answered

### Q1. What were the largest single layoff events, and which companies shut down entirely?
- Identified the maximum layoffs in a single event
- Filtered for companies with 100% layoff (`percentage_laid_off = 1`)
- **Insight:** Several well-funded startups shut down entirely — one raised over $2 billion yet laid off 100% of staff, highlighting that fundraising alone doesn't guarantee survival.

---

### Q2. Which industries were hit hardest by total layoffs?
- Aggregated total layoffs and event counts by industry
- **Insight:** The Consumer and Retail industries topped total layoffs, followed closely by Transportation — reflecting the post-pandemic demand correction as spending habits normalized.

---

### Q3. Which countries experienced the most layoffs, and how concentrated is the impact?
- Calculated each country's share of total global layoffs using a subquery
- **Insight:** The United States accounts for the dominant share of all layoffs in the dataset, confirming the data is heavily weighted toward US-based tech companies.

---

### Q4. How did layoffs trend year over year?
- Grouped layoffs by year to identify the peak period
- **Insight:** Layoffs peaked in 2022 with over 160,000 jobs lost across 1,030 events. 2021 was the calmest year due to post-pandemic hiring optimism. By 2023, layoffs remained high but began to decline, suggesting the worst of the correction had passed.

---

### Q5. Which company funding stage experienced the most layoffs?
- Compared total layoffs, event counts, and average percentage laid off across stages (Seed, Series A, Post-IPO, etc.)
- **Insight:** Post-IPO companies had the highest absolute layoffs due to larger headcounts. However, early-stage startups showed higher average percentage layoffs, often signalling a complete shutdown.

---

### Q6. Which companies ranked in the top 3 for layoffs each year? *(CTE + Window Function)*
- Used two chained CTEs with `DENSE_RANK()` and `PARTITION BY` to rank companies within each year
- **Insight:** Top layoff leaders shifted significantly each year. Travel and gig economy companies dominated 2020, while Big Tech giants (Meta, Amazon, Google, Microsoft) took over in 2022–2023 as the sector-wide correction hit the largest companies.

---

### Q7. Which companies conducted multiple rounds of layoffs, and what was their total impact?
- Used `HAVING COUNT(*) > 1` to isolate companies with repeated layoff events
- Tracked first and last layoff dates to measure restructuring duration
- **Insight:** Companies like Amazon (3 rounds), Salesforce (4 rounds), and Uber (5 rounds) cut repeatedly rather than making a single decisive call. Twitter's 3 rounds within just 4 months reflected the rapid post-acquisition restructuring under new ownership.

---

## 💡 Key Findings Summary

| Finding | Detail |
|---|---|
| 📈 Peak Year | 2022 — 160,661 layoffs across 1,030 events |
| 🏭 Hardest Hit Industry | Consumer & Retail |
| 🌍 Most Affected Country | United States (majority share of all layoffs) |
| 🏢 Most Layoff Rounds | Uber — 5 separate rounds (2020–2022) |
| 💸 Largest Single-Year Cut | Google — 12,000 in 2023 |
| 🚀 100% Layoff Companies | Mostly early-stage startups; some raised $1B+ before shutting down |

---


## 👩‍💻 About Me

**Sufia** — Junior Data Analyst | Google Certified Data Analyst

📎 [LinkedIn](https://linkedin.com/in/sufia-h-98a28624a) | 📂 [GitHub Portfolio](https://github.com/Sufia-Haque)
