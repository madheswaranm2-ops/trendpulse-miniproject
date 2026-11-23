Q: 1
Mini Project — TrendPulse: What's Actually Trending Right Now
A working data professional is expected to move comfortably across the whole analysis loop: loading a dataset and shaping it with core Python and NumPy, wrangling it in Pandas, understanding it visually, and then querying and summarizing it with SQL and spreadsheets. This mini project asks you to demonstrate exactly that range on one theme: finding out what actually trends, and why. You will work with a real dataset of daily "trending videos" lists from several countries, and turn it into a short, evidence-backed "content strategy briefing" for a media-analytics team. The work is broken into four independently-gradeable Parts. Every technique required below is a standard, well-documented technique covered in the program so far, with widely available tooling and documentation support. No machine learning is required anywhere; wherever the project talks about "classifying" or "scoring", you will build transparent, rule-based logic yourself. No API calls, no web scraping, and no manual file-handling code is used anywhere in this project — the dataset is provided as ready-to-load CSV files, and all of the work is done in Python, NumPy and Pandas (plus SQL and a spreadsheet in Part 4).

Work through the Parts in order if you like, but each Part is scoped, described, and graded entirely on its own.

Total marks: 100 · Parts: 4

The Dataset
This project uses the public Trending YouTube Video Statistics dataset: daily snapshots of the videos that appeared on YouTube's "Trending" list, with one CSV file per country (for example USvideos.csv, GBvideos.csv, INvideos.csv) and one small lookup file, categories.csv, that maps each numeric category_id to a category name. The program team will make these files available on the LMS, ready to load with pd.read_csv() (the dataset is also publicly available on Kaggle). Each country CSV row is one video on one trending day and includes fields such as video_id, trending_date, title, channel_title, category_id, publish_time, tags, views, likes, dislikes, comment_count, comments_disabled, ratings_disabled, video_error_or_removed and description.

Your scope: use at least three countries (for example US, GB and IN), giving at least 40,000 rows in total, plus the categories.csv lookup. Inspect the actual column names of your copy before you start; some records are messy, and handling that is part of the task.

Click here to Download the dataset Files: DataFiles

Submission Guidelines (read first)
Submit one public GitHub repository link for the whole project. Inside it, create four folders, one per Part, using this layout:

trendpulse/
├── README.md                      (project overview and links to each Part's folder)
├── part1_python_foundations/
├── part2_numpy_pandas/
├── part3_visualization_eda/
└── part4_sql_spreadsheet/
Each Part is graded independently from its own folder, so each folder must be fully self-contained: grading one Part never requires opening another Part's folder.

Every Part folder must include its own README.md covering: how to install dependencies (a requirements.txt or equivalent inside that folder), how to run the code end to end, and a short summary of design decisions. Where a Part asks for written interpretation, that text lives in that folder's README.md or in Markdown cells inside a notebook — not in a separate document. The root README.md only needs a short overview and a link to each folder.

Python work is done in Google Colab notebooks (.ipynb) committed to the repository. A notebook must run top to bottom without errors (Runtime → Restart and run all), be organized with headings and short Markdown explanations, and contain no leftover scratch cells.

All deliverables are textual: code lives in the repository (inside the relevant Part folder) as .py/.ipynb/.sql files (plus one .xlsx workbook in Part 4), and every write-up lives as Markdown text inside the repository. No screenshots, images, PDFs, slide decks, presentations, video, or audio are required or accepted anywhere in this project. Chart image files your code generates (e.g., saved .png plots) may live inside a repository as supporting artifacts, but they are never a substitute for the required written interpretation — a grader must be able to assess your work from the text alone.

Data in the repository (every Part). Each Part folder must contain the data it needs, so that it runs without any other folder: the country CSV files and categories.csv (or a slimmed copy of them) inside that folder's data/ subfolder. GitHub rejects any single file over 100 MB, so if a file is too large, commit a trimmed version (for example, with the long description, tags and thumbnail_link columns dropped) and say exactly how you trimmed it in that folder's README. No Part's code may read from, import from, or otherwise depend on another Part's folder at grading time.

Data use. State the dataset's name and source in your root README, and do not claim it as your own. Do not add any personal or private data to the repository.

Academic integrity: the code, analysis, and written interpretations must be your own. You may use standard library/framework documentation, but the reasoning and implementation must be authored by you.

Deadline: submit your single repository link by the date/time communicated separately on the LMS for this evaluation.

Git workflow (general practice for every Part; separately scored in Parts 1 and 3). Because all four Parts live in one repository, the commit history should show, for each Part, at least one feature branch (for example part1-cleaning, part3-eda) that was created, committed to at least twice with changes inside that Part's folder, and then merged back into main (visible via git log --graph --all or the repository's branch/merge-commit history) — this is expected submission practice across all four Parts. Parts 1 and 3 additionally carry a dedicated rubric criterion for this: if there is no branch/merge history for the Part-1 or Part-3 folder (for example, everything is in a few commits made straight on main), that Part will be marked down on that criterion, even if the code itself is correct. Parts 2 and 4 do not carry a separate scored line item for this, but the same branch-and-merge history is still expected there as standard practice.

No paid services required anywhere in this project. The dataset is free, and no API key, account or network service is needed to complete any Part.

Part 1 — Python Foundations & Data Structures (25 marks)
Real-world data rarely arrives perfectly clean. In this Part you will load the dataset once, then do the actual work in core Python: converting and cleaning values with reusable functions, organizing records with the right data structures, and applying rule-based logic to label what you loaded. The only Pandas used in this Part is pd.read_csv() and df.to_dict("records") to get the data into Python lists and dictionaries; everything after that is core Python (loops, functions, conditions and data structures).

Data source: the per-country trending CSV files and categories.csv described in "The Dataset", read from part1_python_foundations/data/.

Tasks
Setup. In a Colab notebook, declare your configuration (file paths, list of countries, thresholds) as variables with correct data types, and print a formatted run header with f-strings showing which countries will be loaded and when the run started. Add a short Markdown note on the notebook discipline you followed (clear headings, restart-and-run-all, no hidden state).
Loading function. Write a reusable function such as load_country(path, country, max_rows=None) with parameters, a default argument and a return value. Inside it, read the CSV with pd.read_csv(), add a country field, and return the rows as a list of dictionaries using df.to_dict("records"). Verify that the columns you need are present, and print how many records were loaded per country. Build a category_names dictionary (category_id → category name) from categories.csv.
Type conversion and cleaning (core Python). Loop over the records and convert views, likes, dislikes and comment_count to integers and the true/false flag columns to booleans; handle blanks and bad values explicitly (state whether you drop the record or substitute a value, and justify the choice); convert trending_date (the dataset stores it in a compact yy.dd.mm style — check your copy) and publish_time into proper dates using string handling or the standard datetime module. Use try/except so that one bad value cannot crash the notebook, and report how many values failed to parse for each field.
Core data structures. Store the cleaned records as a list of dictionaries and a few key fields (video_id, trending_date, views, likes) as tuples where immutability makes sense, explaining why. Use a set to find the unique video IDs in each country, and set intersection/difference to find videos that trended in more than one country and videos unique to one. Use a dictionary to count how many trending appearances each channel has, and slicing to show the 15 channels with the most appearances. Build a nested dictionary summary (country → category name → number of records) and print part of it with f-strings. State in Markdown why each structure was the right choice for its job, and which of them are mutable or immutable.
Scope. Include a short demonstration, with a Markdown explanation, of variable scope: one variable defined inside a function and one defined outside it, showing what happens when you try to access each from the other side.
Loops over strings and sequences. Write title_features(title) that iterates over the characters and words of a video title to count: uppercase words, exclamation/question marks, and the title length in words. Use a for loop, range() with index access at least once, and a while loop with a correct termination condition (for example, scanning records until you find the first video above a view threshold), using break and continue meaningfully.
Rule-based classification. Write classify_video(record) using if/elif/else, boolean logic and nested conditions to assign each record one label such as Viral Hit, Steady Performer, Divisive, Low Engagement, Unrated, based on views, a like ratio (likes / (likes + dislikes)), and the comments/ratings-disabled flags. State your thresholds and handle edge cases explicitly (zero views, zero likes and dislikes, ratings disabled, missing values) without a division-by-zero error. Include a short hand-trace in Markdown of one example record through your conditions, showing which branch it takes and why. Loop over all records, and report how many records fall into each label.
Refactor. Identify one block of code you wrote more than once and refactor it into a reusable function, and explain in two sentences what you gained.
README. Document install/run steps, the countries and files used, your cleaning rules and thresholds, and the data source.
Acceptance criteria (your submission is complete when…)
The notebook runs end to end from the files in data/ and loads ≥ 40,000 records from ≥ 3 countries, with the loaded count reported for each.
Loading is implemented as a reusable function with parameters, a default argument and a return value, and returns a list of dictionaries; category_names is a dictionary built from categories.csv.
Each conversion/cleaning decision is justified, try/except is used so bad values do not crash the notebook, and parse-failure counts are reported per field.
A list of dictionaries, a tuple, a set (with intersection/difference), a dictionary counter, a nested dictionary and slicing are each used, with a stated reason for each choice.
The scope demonstration is present with its explanation.
for, while, range(), break and continue are each used meaningfully, and title_features iterates over the characters/words of a string.
classify_video uses nested conditions, handles the stated edge cases, includes a hand-traced example, and the count per label is reported.
One repeated block is refactored into a function with a short explanation.
The repository's commit history shows a Part-1 feature branch with 2+ commits (touching part1_python_foundations/) merged into main.
part1_python_foundations/README.md documents install/run steps, the cleaning rules and thresholds, and the data source.
Submission
The part1_python_foundations/ folder of the public GitHub repository, containing: the Colab notebook(s) and any .py helper files, the data/ files (or documented trimmed versions), and a README.md.

Part 2 — NumPy & Pandas Data Wrangling (25 marks)
Raw data is rarely analysis-ready. In this Part you will compute a transparent "engagement score" with NumPy, load the data into Pandas, inspect and clean it, and use grouping, aggregation, merging and concatenation to answer concrete questions about what trends and for how long. This Part is entirely self-contained: it does not reuse any file from Part 1's folder. Commit your own copy of the data in part2_numpy_pandas/data/ (the country CSV files and categories.csv, or a slimmed copy, as described in the Submission Guidelines) and copy into this folder any helper function from Part 1 that you need.

Data source: the same Trending YouTube Video Statistics files, loaded from this Part's own data/ folder (no network access is needed for any part of this task).

Tasks
NumPy arrays. Load the views, likes, dislikes and comment_count columns into NumPy arrays. Report the shape and dtype of each array. Practice indexing and slicing: show the 10 largest view counts, every 100th record, and a sub-array of your choice.
Engagement score without loops. Using only NumPy array operations (no explicit Python loops), compute: (a) a like ratio and a comment rate (comments ÷ views) that safely handle zero denominators, (b) min-max-normalized versions of views, likes and comments, (c) an engagement score that combines them with weights you choose and justify in writing, and (d) a log-scaled view count with a short note on why raw views are hard to plot. Use boolean masks to flag the top 10% of records by engagement score.
Reshape and broadcast. Build a (days × countries) array of daily trending counts (or average views), use reshape and flatten, and use broadcasting to compute each country's share of each day's total and each day's value relative to that country's average, again without explicit loops.
Loading and inspection. Load the country CSV files into Pandas DataFrames with pd.read_csv(), add a country column to each, and show head(), info(), describe() and shape for each and for the combined data. Convert the date columns to datetimes and fix the other data types. List every data-quality issue you find (for example missing descriptions, removed/errored videos, duplicate rows, inconsistent dates) and state how you handled each.
Filtering. Using boolean indexing with &/|, loc and iloc, and sorting, answer: (a) which records have 1 million+ views and more than 50,000 likes? (b) what are the top 20 records by engagement score? (c) which records are in the Music or Gaming category with views above the overall median? Select specific columns where it helps readability.
Missing values and duplicates. Use isna(), fillna(), dropna() and drop_duplicates(). For every column with missing values, report the count and percentage, choose a strategy, and justify it in one or two sentences. State how many duplicate rows were removed (or that none were found), and explain what counts as a "duplicate" for this dataset (for example, the same video_id on the same trending_date in the same country).
Joining category names. Load categories.csv with pd.read_csv() and use merge() to attach category names to the trending records. State whether you used an inner or a left merge and why, and show that no records were lost.
Aggregation. Use groupby() with agg() to report, by category and by country: record count, average views, average likes, and average engagement score. Use value_counts() for the category distribution, as both counts and percentages, and find which publishing day of the week or hour tends to produce the highest-viewed videos.
Time to trend and trending lifespan. Compute days_to_trend (days between publish_time and trending_date) and describe its distribution. For each video within each country, compute its trending lifespan — the number of distinct days it stayed on the trending list — using groupby and nunique, then list the 10 longest-lasting videos and the average lifespan per category.
Combining data. Use concat() to stack the per-country DataFrames into one, and use merge() between a per-video summary table and a per-channel summary table to show, for each channel, its number of trending videos and total views.
README. Document install/run steps, your engagement-score weights and the reasoning behind them, the data-quality issues found, and your missing-value and duplicate decisions.
Acceptance criteria (your submission is complete when…)
The notebook runs offline from the committed data with no external call.
shape and dtype are reported for every NumPy array, and the ratios, normalization, engagement score and broadcasting steps are computed without explicit loops.
The weights of the engagement score are stated and justified in writing.
head(), info(), describe() and shape are shown for the country DataFrames and the combined one, and each data-quality issue is listed with how it was handled.
Boolean indexing with & and |, loc, iloc and sorting are each demonstrated and answer the questions asked.
The missing-value percentage is reported per affected column, with a justified strategy for each; the definition of a duplicate and the number removed are reported.
The category merge is correct, the merge type is explained, and no records are lost.
groupby/agg, value_counts, concat and merge are each used correctly.
days_to_trend and trending lifespan are computed, with the longest-lasting videos listed.
part2_numpy_pandas/README.md documents install/run steps, the weights, and the cleaning decisions.
Submission
The part2_numpy_pandas/ folder of the public GitHub repository, containing: the notebook(s), the committed data/ files (or documented trimmed versions), and a README.md.

Part 3 — Visualization, EDA & Business Thinking (25 marks)
Before reporting on any dataset, an analyst must be able to profile it, tell a clear visual story about it, and connect the numbers to business questions. In this Part you will build charts, run a structured exploratory analysis, and write the content strategy briefing. This Part is self-contained: it is graded from its own folder alone, using its own committed copy of the data and its own cleaning steps.

Data source: the same Trending YouTube Video Statistics files and categories.csv, committed in this Part's own folder (part3_visualization_eda/data/).

Tasks
Profile the data. Load and combine the country data, report shape, data types and the percentage of missing values for every column that has any. Briefly document any cleaning you apply (for example, removing duplicates and records for removed videos), and add the category names to each record.
Chart basics. Using Matplotlib, produce at least five charts that suit their data types — for example: a bar chart of record counts per category, a histogram of (log-scaled) views, a scatter plot of views vs. likes, a line chart of the number of trending records per day, and a box plot of views by category. Every chart must have a title, axis labels and (where relevant) a legend.
Interactive charts. Using Plotly, produce at least two interactive charts — for example, a scatter plot of views vs. likes colored by category with the video title on hover, and a bar chart comparing the average views per category across countries.
Interpretation. Under each chart, write a 2–4 sentence interpretation of what it shows and a sentence explaining why that chart type fits the variables used. A chart with no interpretation does not count.
Distributions and outliers. For views and for likes, compute mean, median and mode and state in writing whether each distribution is right-skewed, left-skewed or symmetric, referencing the mean/median/mode ordering. Apply the IQR rule (outliers are points outside [Q1 − 1.5×IQR, Q3 + 1.5×IQR]) and report the number of outliers for each, with a short note on whether they should be removed or kept for this analysis, and why.
Correlation. Compute a correlation matrix across your numeric columns (at least views, likes, dislikes, comment count and days_to_trend), render it as a heatmap, and interpret in text the two strongest correlations — defined as the two feature pairs with the largest absolute off-diagonal coefficients. Add one sentence on why correlation here does not prove that likes cause views.
Funnel analysis. Using unique videos, build a funnel: all videos that ever trended → videos above the median peak views → videos above the 90th percentile of peak views → videos with 1,000+ comments. Report the count and the conversion rate at each stage, state where the largest drop-off occurs, and explain in two or three sentences what that drop-off suggests.
Retention-style analysis (trending lifespan). Treat a video's first trending day as day 1. Report the percentage of videos that were still on the trending list on day 2, day 3, day 5 and day 7, and draw a retention curve. Compare at least two categories or two countries, and describe which kinds of videos stay and which disappear after one day.
Cohort view. Group videos by the week (or month) in which they first trended, and compare the cohorts on a metric of your choice (for example, average views or average lifespan). State whether any cohort looks different, and whether the difference could be explained by the amount of data in it.
Content strategy briefing. Write a 5–8 sentence briefing for a content team: which categories dominate trending, how quickly videos reach trending, what separates videos that stay on the list from those that vanish, and how countries differ. Reference specific numbers from your analysis, and state one honest limitation of your data (such as its fixed time window or that it only shows videos that did trend, not those that did not).
README. Document install/run steps and place every required written interpretation, the funnel table, the retention result and the briefing in the README or in notebook Markdown cells.
Acceptance criteria (your submission is complete when…)
Missing-value percentages are reported for every affected column, and cleaning steps are documented.
At least 5 Matplotlib charts and 2 Plotly charts are present, all with titles and labels, and each has its own 2–4 sentence interpretation including the reason for the chart type.
Mean, median and mode are reported for views and likes, with an explicit skewness conclusion that compares them.
IQR-based outlier counts are reported for both columns with a keep/remove decision.
The correlation heatmap is present, and the two strongest correlations (largest absolute off-diagonal coefficients) are named and interpreted in text.
The four-stage funnel is reported with counts and conversion rates, and the biggest drop-off is explained.
The retention analysis reports numeric percentages for days 2, 3, 5 and 7, includes the curve, and compares at least two categories or countries.
The cohort comparison is present with a written conclusion.
The 5–8 sentence content strategy briefing is present, cites specific numbers and states a limitation.
The repository's commit history shows a Part-3 feature branch with 2+ commits (touching part3_visualization_eda/) merged into main.
part3_visualization_eda/README.md documents install/run steps and contains every required written interpretation.
Submission
The part3_visualization_eda/ folder of the public GitHub repository, containing: the analysis notebook(s), the committed data/ files (or documented trimmed versions), any saved chart images as supporting artifacts, and a README.md (or notebook Markdown cells) with every required written interpretation.

Part 4 — SQL & Spreadsheet Analysis (25 marks)
Analysts regularly have to answer the same questions in more than one tool: a database for repeatable queries and a spreadsheet for quick, shareable summaries. In this Part you will load the trending data into a relational database using MySQL Workbench, query it with SQL, and then build a spreadsheet briefing workbook. This Part is self-contained: it is graded from its own folder alone, using cleaned CSV files that you commit to it.

Data source: three cleaned CSV tables prepared from the Trending YouTube Video Statistics files — a categories table, a videos table (one row per unique video), and a trending-records table (one row per video per day per country) — committed in this Part's own folder under part4_sql_spreadsheet/data/. Prepare these tables in Python/Pandas (for example, with drop_duplicates(), merge() and df.to_csv(..., index=False)), and describe how in the README.

Tasks
Schema design. In MySQL Workbench, design a schema with at least three related tables sharing primary/foreign key relationships — for example categories(category_id, category_name), videos(video_id, title, channel_title, category_id, publish_time) and trending_records(record_id, video_id, country, trending_date, views, likes, dislikes, comment_count). You may rename columns and tables, but the three-table, PK/FK structure is required. Save the full CREATE DATABASE / CREATE TABLE statements in a .sql file.
Loading. Load your CSV data into the tables using the Workbench import wizard or INSERT/LOAD DATA statements, saving the statements you used in the .sql file. Record the row count of each table after loading, using SELECT COUNT(*).
Basic queries. Write and run queries that demonstrate SELECT with WHERE, ORDER BY, LIMIT, DISTINCT, and column aliases — for example, the 10 most-viewed trending records in one country, or the distinct countries and categories present.
Grouping. Write queries using GROUP BY with aggregate functions and HAVING — for example, categories whose average views are above a threshold of your choice, or channels with at least 5 distinct trending videos.
Joins. Write queries using INNER JOIN, LEFT JOIN and RIGHT JOIN, each on a scenario where that join type is the correct choice (for example, a LEFT JOIN from categories to videos to find categories that have no video in your data, or a three-table INNER JOIN listing trending records with video title and category name). Under each, write one or two sentences explaining why that join type, and not another, fits the question.
Query count and evidence. Collectively your queries must number at least 8 and cover every clause above. Paste each query together with its text output into the README.
Spreadsheet workbook. Export your cleaned data into an .xlsx workbook and build: (a) a pivot table summarizing average views by category and country, (b) a lookup sheet and an XLOOKUP or VLOOKUP formula that maps each category_id to its category name, (c) COUNTIF, SUM and AVERAGE formulas for headline numbers such as records per country and overall average views, (d) filters and sorting applied to the records sheet, (e) conditional formatting that highlights records in the top 10% of views, and (f) at least one named range used inside a formula.
Explain the workbook in text. Because screenshots are not accepted, describe in the README exactly how each of (a)–(f) was set up: the formulas used (written out as text), the pivot rows/columns/values, the conditional-formatting rule, and the range name and what it refers to.
Cross-check. Choose two numbers (for example, the record count for one country and the average views for one category) and show that your SQL result and your spreadsheet result agree. If they differ, explain why.
README. Document the tools used, the order to run the .sql file, and your design decisions for the schema.
Acceptance criteria (your submission is complete when…)
The .sql file recreates the database from scratch and implements a schema of ≥ 3 related tables with primary/foreign keys; table row counts are recorded.
≥ 8 queries are present with their text output in the README, collectively covering SELECT/WHERE, ORDER BY, LIMIT, DISTINCT, aliases, GROUP BY with HAVING, and INNER, LEFT and RIGHT joins.
Each join is accompanied by a written justification for the join type.
The .xlsx workbook is committed and contains a pivot table, an XLOOKUP/VLOOKUP, COUNTIF/SUM/ AVERAGE formulas, filters and sorting, conditional formatting and a named range.
Every workbook element is described in text in the README, including the formulas.
The cross-check between a SQL result and a spreadsheet result is shown for at least two values.
part4_sql_spreadsheet/README.md documents the run order, how the CSV tables were prepared, and the schema design decisions.
Submission
The part4_sql_spreadsheet/ folder of the public GitHub repository, containing: the .sql file, the cleaned CSVs under data/, the .xlsx workbook, and a README.md with every query, its text output, and the written description of the workbook.
