# TrendPulse — Part 4: SQL & Spreadsheet Analysis

## Deliverables and tools
- MySQL 8.0+ / MySQL Workbench for schema creation, CSV import and SQL analysis.
- Python 3.10+ and pandas for deterministic CSV preparation.
- Microsoft Excel (or compatible spreadsheet software) for the workbook; a native PivotTable object is included.
- No API, scraping, paid service or network access is required.

## Folder contents
- `trendpulse_part4.sql` — database schema, constraints, row-count checks and 11 analysis queries.
- `data/` — the three cleaned relational CSV tables used by this Part.
- `source_data/` — original country CSV inputs and category lookup used to reproduce the cleaned tables.
- `prepare_data.py` — rebuilds the cleaned CSV tables from `source_data/`.
- `requirements.txt` — Python dependencies.
- `trendpulse_part4_briefing.xlsx` — records, category lookup, lookup formulas, headline calculations and a native PivotTable.

## Install and prepare data
Run these commands from this folder:
```bash
python -m pip install -r requirements.txt
python prepare_data.py
```
The preparation script checks required source columns, parses `trending_date` from `%y.%d.%m` to ISO `YYYY-MM-DD`, parses `publish_time` as UTC, converts numeric fields, drops rows missing required identifiers/date/category/views, fills missing likes/dislikes/comment counts with zero, and removes duplicate `(video_id, country, trending_date)` records. It validates category and video references before writing CSVs. `videos.csv` retains the first row after deterministic sorting by video ID, trending date and country; `categories.csv` keeps one row per category ID. The three output tables are written with `index=False`.

## Verified data profile
| CSV/table | Rows | Columns |
|---|---:|---:|
| `categories.csv` | 17 | 2 |
| `videos.csv` | 14,699 | 5 |
| `trending_records.csv` | 46,000 | 7 |

Country record counts: US 16,000; GB 15,000; IN 15,000. Total views: 54,264,601,254. Overall average views: 1,179,665.24. There are no null values in the three cleaned CSVs, no duplicate primary/unique keys, and no missing category/video foreign-key references.

## MySQL schema design and run order
1. Open `trendpulse_part4.sql` in MySQL Workbench and execute it. **The script drops and recreates `trendpulse_db`; back up any database with that name first if you need its contents.**
2. In the Workbench Navigator, use Table Data Import Wizard in this order: `data/categories.csv` → `categories`; `data/videos.csv` → `videos`; `data/trending_records.csv` → `trending_records`. Map by headers and leave `record_id` unmapped because MySQL generates it.
3. Execute the three `SELECT COUNT(*)` statements and confirm 17, 14,699 and 46,000.
4. Execute Q1–Q11. The SQL file contains the complete executable statements.

`categories.category_id` and `videos.video_id` are primary keys. `videos.category_id` references `categories.category_id`; `trending_records.video_id` references `videos.video_id`. `trending_records.record_id` is an auto-increment primary key, and `(video_id, country, trending_date)` has a unique constraint. This separates reusable video metadata from repeated country/day observations and avoids duplicating title/channel/category data in every trending record.

## SQL queries and text outputs
The following outputs were recomputed from the exact committed CSV files using a local SQL execution engine (SQLite) to verify the relational results. The statements in `trendpulse_part4.sql` are written for MySQL 8.0. The query outputs therefore provide reproducible CSV-backed evidence; run the script in MySQL Workbench after import to confirm the same values in your MySQL instance.

### Q1 — SELECT, WHERE, ORDER BY, LIMIT and aliases
```sql
SELECT country AS market, video_id, views AS view_count FROM trending_records WHERE country='US' ORDER BY views DESC LIMIT 10;
```
Shows the ten highest-viewed US trending records; aliases make output headings clearer.

| market   | video_id    |   view_count |
|:---------|:------------|-------------:|
| US       | HPG-bd_JLxn |    129229245 |
| US       | yd4LMLxXzWE |    119711498 |
| US       | HPG-bd_JLxn |    109129467 |
| US       | Nc1MUQvmyWO |     97553795 |
| US       | yd4LMLxXzWE |     97342335 |
| US       | HPG-bd_JLxn |     90679797 |
| US       | Nc1MUQvmyWO |     83611280 |
| US       | h5eHGd1GiiS |     82623566 |
| US       | yd4LMLxXzWE |     80368655 |
| US       | HPG-bd_JLxn |     70261074 |

### Q2 — DISTINCT countries
```sql
SELECT DISTINCT country AS market FROM trending_records ORDER BY market;
```
Lists each country once.

| market   |
|:---------|
| GB       |
| IN       |
| US       |

### Q3 — DISTINCT categories
```sql
SELECT DISTINCT c.category_name AS category FROM categories c INNER JOIN videos v ON v.category_id=c.category_id ORDER BY category LIMIT 12;
```
Lists category names represented by at least one video.

| category             |
|:---------------------|
| Autos & Vehicles     |
| Comedy               |
| Education            |
| Entertainment        |
| Film & Animation     |
| Gaming               |
| Howto & Style        |
| Music                |
| News & Politics      |
| People & Blogs       |
| Pets & Animals       |
| Science & Technology |

### Q4 — GROUP BY, aggregates and HAVING
```sql
SELECT c.category_name, COUNT(*) AS record_count, ROUND(AVG(r.views),2) AS average_views FROM trending_records r INNER JOIN videos v ON v.video_id=r.video_id INNER JOIN categories c ON c.category_id=v.category_id GROUP BY c.category_id,c.category_name HAVING AVG(r.views)>500000 ORDER BY average_views DESC LIMIT 10;
```
Aggregates trending appearances by category and keeps only categories whose mean views exceed 500,000.

| category_name    |   record_count |   average_views |
|:-----------------|---------------:|----------------:|
| Music            |          10310 |      3190950.48 |
| Entertainment    |          12270 |       901025.65 |
| Comedy           |           3258 |       603475.66 |
| Film & Animation |           2297 |       577974.02 |
| People & Blogs   |           3804 |       551234.12 |
| Gaming           |           2057 |       509664.94 |

### Q5 — GROUP BY / HAVING for channels
```sql
SELECT v.channel_title, COUNT(DISTINCT r.video_id) AS distinct_videos FROM videos v INNER JOIN trending_records r ON r.video_id=v.video_id GROUP BY v.channel_title HAVING COUNT(DISTINCT r.video_id)>=5 ORDER BY distinct_videos DESC LIMIT 10;
```
Counts unique trending videos per channel and retains channels with at least five.

| channel_title         |   distinct_videos |
|:----------------------|------------------:|
| UltimateUnboxing65    |               524 |
| QuietChallenge75      |               466 |
| OfficialReview41      |               457 |
| InsaneReaction46      |               321 |
| Brand NewChallenge45  |               302 |
| UltimateSpeech20      |               292 |
| CrazyTrailer91        |               283 |
| WildHighlights7       |               245 |
| UltimateVlog96        |               234 |
| SurprisingChallenge82 |               217 |

### Q6 — INNER JOIN across all three tables
```sql
SELECT r.country,r.trending_date,v.video_id,v.title,c.category_name,r.views FROM trending_records r INNER JOIN videos v ON v.video_id=r.video_id INNER JOIN categories c ON c.category_id=v.category_id ORDER BY r.views DESC LIMIT 10;
```
**Why INNER JOIN:** the question requests complete trending-record, video and category details. Only rows with a matching row in all three tables form a complete result, so unmatched rows should be excluded.

| country   | trending_date   | video_id    | title                                            | category_name   |     views |
|:----------|:----------------|:------------|:-------------------------------------------------|:----------------|----------:|
| GB        | 2018-01-05      | RdqSDDng84n | Lena Ortiz - Monsoon (Live)                      | Music           | 360760164 |
| GB        | 2018-01-27      | QYwpwP6y0Eb | The Hollow Pines - Phones (Official Video) WATCH | Music           | 343297002 |
| GB        | 2018-01-04      | RdqSDDng84n | Lena Ortiz - Monsoon (Live)                      | Music           | 286714357 |
| GB        | 2018-01-26      | QYwpwP6y0Eb | The Hollow Pines - Phones (Official Video) WATCH | Music           | 282812154 |
| GB        | 2017-12-24      | WQEWsMmimzZ | Rook & Vale - Phones (Official Video) WATCH      | Music           | 255362869 |
| GB        | 2018-01-03      | RdqSDDng84n | Lena Ortiz - Monsoon (Live)                      | Music           | 236275528 |
| GB        | 2018-01-25      | QYwpwP6y0Eb | The Hollow Pines - Phones (Official Video) WATCH | Music           | 230704137 |
| GB        | 2018-01-02      | RdqSDDng84n | Lena Ortiz - Monsoon (Live)                      | Music           | 210747294 |
| GB        | 2017-12-23      | WQEWsMmimzZ | Rook & Vale - Phones (Official Video) WATCH      | Music           | 200444300 |
| GB        | 2018-01-24      | QYwpwP6y0Eb | The Hollow Pines - Phones (Official Video) WATCH | Music           | 181785943 |

### Q7 — LEFT JOIN categories to videos
```sql
SELECT c.category_id,c.category_name,COUNT(v.video_id) AS video_count FROM categories c LEFT JOIN videos v ON v.category_id=c.category_id GROUP BY c.category_id,c.category_name ORDER BY video_count,c.category_name;
```
**Why LEFT JOIN:** categories are the full population being audited. Keeping the left-side categories reveals categories with no matching videos; COUNT(video_id) returns zero for them.

|   category_id | category_name         |   video_count |
|--------------:|:----------------------|--------------:|
|            30 | Movies                |             0 |
|            29 | Nonprofits & Activism |             0 |
|            43 | Shows                 |             0 |
|            19 | Travel & Events       |           328 |
|            15 | Pets & Animals        |           395 |
|             2 | Autos & Vehicles      |           415 |
|            27 | Education             |           654 |
|            28 | Science & Technology  |           660 |
|            26 | Howto & Style         |           743 |
|            20 | Gaming                |           767 |
|            17 | Sports                |           797 |
|             1 | Film & Animation      |           829 |
|            23 | Comedy                |          1129 |
|            22 | People & Blogs        |          1331 |
|            25 | News & Politics       |          1381 |
|            10 | Music                 |          1883 |
|            24 | Entertainment         |          3387 |

### Q8 — RIGHT JOIN videos to categories
```sql
SELECT c.category_id,c.category_name,v.video_id,v.title FROM videos v RIGHT JOIN categories c ON c.category_id=v.category_id ORDER BY c.category_id,v.video_id LIMIT 20;
```
**Why RIGHT JOIN:** the requirement is to retain every category on the right side, including categories without videos. This demonstrates RIGHT JOIN; reversing table order and using LEFT JOIN would be equivalent.

|   category_id | category_name    | video_id    | title                         |
|--------------:|:-----------------|:------------|:------------------------------|
|             1 | Film & Animation | --UQXlrk5E0 | Insane Budget Interview       |
|             1 | Film & Animation | -1VjLKhzB3I | Final Chess Reaction FULL     |
|             1 | Film & Animation | -8Kyrh8E3wc | BRAND NEW PARIS INTERVIEW     |
|             1 | Film & Animation | -CUq3mh0N9I | Perfect Election Secret       |
|             1 | Film & Animation | -FCGwYarrYo | Official Bangalore Mystery    |
|             1 | Film & Animation | -GK5d1_uJvf | Shocking Festival Tutorial    |
|             1 | Film & Animation | -RzuYrRezi9 | Epic Pasta Mystery!           |
|             1 | Film & Animation | -WYPvofQqQU | Brand New Chess Highlights    |
|             1 | Film & Animation | -_Cdwyxb7My | Shocking Chess Reaction       |
|             1 | Film & Animation | -b-rhqDVLoT | Amazing Bangalore Breakdown   |
|             1 | Film & Animation | -cLF6_ccjk2 | Brand New Bangalore Vlog!     |
|             1 | Film & Animation | -djoioBcrBR | Official Cricket Challenge    |
|             1 | Film & Animation | -f3mKPCKMfZ | Brand New Space Update        |
|             1 | Film & Animation | -hcbMyxSzMu | Crazy Monsoon Interview       |
|             1 | Film & Animation | -l15uQGm6mz | Surprising Winter Highlights  |
|             1 | Film & Animation | -lBBgcw2yy_ | Epic Pasta Breakdown!         |
|             1 | Film & Animation | -pGQ6w1ew7O | Surprising Guitar Unboxing    |
|             1 | Film & Animation | -sQa1QScSOT | Official Election Review!     |
|             1 | Film & Animation | -xp25kk8U07 | Incredible Monsoon Interview? |
|             1 | Film & Animation | -xt97Z0zJ0v | Epic Cars Challenge           |

### Q9 — country record counts
```sql
SELECT country AS market,COUNT(*) AS record_count FROM trending_records GROUP BY country ORDER BY market;
```
Country totals are cross-checked against the workbook COUNTIF formulas.

| market   |   record_count |
|:---------|---------------:|
| GB       |          15000 |
| IN       |          15000 |
| US       |          16000 |

### Q10 — average views by category and country
```sql
SELECT c.category_name,r.country,ROUND(AVG(r.views),2) AS average_views FROM trending_records r INNER JOIN videos v ON v.video_id=r.video_id INNER JOIN categories c ON c.category_id=v.category_id GROUP BY c.category_id,c.category_name,r.country ORDER BY c.category_name,r.country;
```
The grouped results are the numeric reference for the PivotTable (category rows, country columns, average views values).

| category_name        | country   |   average_views |
|:---------------------|:----------|----------------:|
| Autos & Vehicles     | GB        |       222282.44 |
| Autos & Vehicles     | IN        |       329029.20 |
| Autos & Vehicles     | US        |       297132.79 |
| Comedy               | GB        |       504615.22 |
| Comedy               | IN        |       722128.83 |
| Comedy               | US        |       587646.30 |
| Education            | GB        |       257606.46 |
| Education            | IN        |       489267.26 |
| Education            | US        |       310392.85 |
| Entertainment        | GB        |       817484.06 |
| Entertainment        | IN        |       964959.61 |
| Entertainment        | US        |       880449.42 |
| Film & Animation     | GB        |       797980.03 |
| Film & Animation     | IN        |       551916.55 |
| Film & Animation     | US        |       411683.27 |
| Gaming               | GB        |       495366.67 |
| Gaming               | IN        |       578476.27 |
| Gaming               | US        |       464045.97 |
| Howto & Style        | GB        |       218319.44 |
| Howto & Style        | IN        |       371382.99 |
| Howto & Style        | US        |       313337.85 |
| Music                | GB        |      3728698.36 |
| Music                | IN        |      2449175.97 |
| Music                | US        |      2864733.21 |
| News & Politics      | GB        |       233975.92 |
| News & Politics      | IN        |       345883.94 |
| News & Politics      | US        |       225067.63 |
| People & Blogs       | GB        |       438151.07 |
| People & Blogs       | IN        |       561930.62 |
| People & Blogs       | US        |       645957.18 |
| Pets & Animals       | GB        |       275088.50 |
| Pets & Animals       | IN        |       385024.67 |
| Pets & Animals       | US        |       390569.41 |
| Science & Technology | GB        |       332916.93 |
| Science & Technology | IN        |       395370.93 |
| Science & Technology | US        |       337808.89 |
| Sports               | GB        |       284495.08 |
| Sports               | IN        |       535206.39 |
| Sports               | US        |       326267.45 |
| Travel & Events      | GB        |       221495.51 |
| Travel & Events      | IN        |       281037.34 |
| Travel & Events      | US        |       198942.81 |

### Q11 — overall average views
```sql
SELECT ROUND(AVG(views),2) AS overall_average_views FROM trending_records;
```
Cross-checks the workbook overall AVERAGE formula.

|   overall_average_views |
|------------------------:|
|              1179665.24 |

## Spreadsheet workbook setup (a–f)
**Workbook sheets:** `Records`, `Category_Lookup`, `Lookup_Formula`, `Headline_Summary`, and `Pivot_Category_Country`.

**(a) Native PivotTable:** `Pivot_Category_Country` contains a native PivotTable object named `TrendPulse_AverageViews`, not just a static summary. Source: the `Records` table. Rows = `category_name`; Columns = `country`; Values = `views`, summarized by **Average**. The PivotTable cache and PivotTable definition are embedded in the `.xlsx` package. Refresh it in Excel if you change the source data.

**(b) Category lookup:** `Category_Lookup` contains `category_id` and `category_name`. `Lookup_Formula` uses `=VLOOKUP(A2,Category_Lookup!$A$2:$B$18,2,FALSE)` filled down for every category ID.

**(c) Headline formulas:** `Headline_Summary` contains `=COUNTIF(Records!$B$2:$B$46001,"US")`, corresponding GB and IN COUNTIF formulas, `=AVERAGE(TotalViews)`, `=SUM(TotalViews)`, and country-level `AVERAGEIF` formulas.

**(d) Filters and sorting:** `Records` is an Excel Table named `TrendingRecords`, with filter dropdowns on all nine columns. The records are sorted by `views` descending before they are written to the workbook.

**(e) Conditional formatting:** `Records!D2:D46001` has a Top 10% conditional-formatting rule with a light highlight fill.

**(f) Named range:** `TotalViews` refers to `Records!$D$2:$D$46001`. It is used in `=AVERAGE(TotalViews)` and `=SUM(TotalViews)` on `Headline_Summary`.

## SQL ↔ spreadsheet cross-checks
| Metric | SQL result | Workbook result/formula | Match |
|---|---:|---:|---|
| US trending records | 16,000 | `COUNTIF(...,"US")` = 16,000 | Yes |
| GB trending records | 15,000 | `COUNTIF(...,"GB")` = 15,000 | Yes |
| IN trending records | 15,000 | `COUNTIF(...,"IN")` = 15,000 | Yes |
| Overall average views | 1,179,665.24 | `AVERAGE(TotalViews)` = 1,179,665.24 | Yes |
| Total views | 54,264,601,254 | `SUM(TotalViews)` = 54,264,601,254 | Yes |

The PivotTable averages by category and country also use the same `views` records as Q10. Minor display differences may occur if Excel applies a different number format; the underlying values are the same.

## Design decisions and limitations
- The source CSVs are retained in `source_data/` for reproducibility; the three normalized import tables are in `data/`.
- `trending_records` contains only the columns required for repeatable SQL and spreadsheet analysis; long descriptions, tags and thumbnail links remain in the source inputs and are not copied into the normalized relational tables.
- The SQL file is designed for MySQL 8.0+. The CSV outputs and all foreign-key relationships were validated locally. The query output tables above were independently recomputed from those CSVs; the author must still run the import wizard and SQL script in their own MySQL Workbench environment.
- Excel formulas are saved with recalculated values in the workbook.
