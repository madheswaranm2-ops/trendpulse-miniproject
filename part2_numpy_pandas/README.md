# TrendPulse — Part 2: NumPy & Pandas Data Wrangling

## 1. Project Overview

TrendPulse is a data analysis mini-project that explores YouTube trending video statistics across three countries: the United States (US), Great Britain (GB), and India (IN).

Part 2 focuses on NumPy and Pandas for data loading, cleaning, transformation, analysis, and aggregation. The objective is to identify video engagement patterns, understand trending behaviour, and evaluate data quality.

## 2. Dataset

This project uses the supplied YouTube Trending Video Statistics dataset.

The following CSV files are included:

- `USvideos.csv` — United States trending-video records.
- `GBvideos.csv` — Great Britain trending-video records.
- `INvideos.csv` — India trending-video records.
- `categories.csv` — Video category lookup data.

The dataset was supplied for this project and is not original work by the project author.

## 3. Project Features

The notebook demonstrates:

- Loading and inspecting CSV datasets using Pandas.
- Creating and analysing NumPy arrays.
- Calculating safe engagement metrics and normalized scores.
- Applying NumPy operations and broadcasting for daily country-level analysis.
- Identifying missing values, duplicate records, and data-quality issues.
- Filtering, sorting, and cleaning datasets.
- Merging category information and concatenating country datasets.
- Grouping and aggregating video statistics.
- Analysing publishing time, time-to-trend, and trending lifespan.

## 4. Folder Structure

```text
part2_numpy_pandas/
├── README.md
├── requirements.txt
├── trendpulse_part2_numpy_pandas.ipynb
└── data/
    ├── USvideos.csv
    ├── GBvideos.csv
    ├── INvideos.csv
    └── categories.csv
```

## 5. Requirements

- Python 3.9 or later
- NumPy
- Pandas
- Jupyter Notebook or Google Colab

## 6. Installation

Install the required dependencies:

```bash
python -m pip install -r requirements.txt
```

## 7. How to Run

1. Keep the `data/` folder and notebook in the same project folder.
2. Open the notebook using Google Colab or Jupyter Notebook.
3. Ensure that the CSV filenames and folder paths match the notebook.
4. Run all notebook cells from top to bottom.
5. Review the generated outputs and validation checks.

The notebook reads CSV files from the local `data/` folder. No network access or API calls are required.

## 8. Engagement Score Design

The notebook calculates a weighted engagement score using min-max-normalized values:

| Metric | Weight | Reason |
|---|---:|---|
| Likes | 0.50 | Represents direct positive interaction |
| Views | 0.30 | Represents audience reach |
| Comments | 0.20 | Represents audience conversation |

Likes receive the highest weight because they represent direct positive interactions. Views measure reach, while comments provide an indication of conversation but may be noisy and less frequent.

NumPy `divide` is used for safe ratio calculations with a zero-denominator guard. The top 10% threshold is determined using the 90th percentile.

## 9. Data Quality and Cleaning Decisions

The notebook reports missing-value counts and percentages before handling missing data.

The following cleaning decisions are applied:

- Missing `likes`, `comment_count`, and `dislikes` values are filled with zero for numeric calculations.
- Missing `description` values are filled with an empty string because descriptions are not used in the engagement metrics.
- Rows missing essential identifiers, dates, or views are dropped.
- Numeric columns are converted using `to_numeric(errors="coerce")`.
- Date fields are parsed explicitly.
- Duplicates are identified using `video_id`, `trending_date`, and `country`. The first occurrence is retained.
- Rows marked `video_error_or_removed=True` are excluded from engagement analysis and counted in the data-quality audit.
- Category names are attached using a left merge so that trending rows are not lost.
- Unmatched category IDs are labelled `Unknown`.

## 10. Reproducibility

All numeric outputs, missing-value percentages, duplicate counts, filtering results, and summaries are calculated by the notebook using the included CSV files.

The notebook does not rely on hard-coded analysis results. Run all cells to reproduce the outputs and validation checks.

Part 2 is self-contained and does not depend on files from another TrendPulse project part.
