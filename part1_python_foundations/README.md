TrendPulse – Part 1: Python Foundations & Data Structures

1. Project Overview

TrendPulse is a Python-based mini project that analyzes YouTube Trending Video Statistics from three countries: United States (US), Great Britain (GB), and India (IN).

Part 1 focuses on Python fundamentals, data structures, data cleaning, loops, functions, and video classification using real-world data.

2. Dataset Details

The project uses the YouTube Trending Video Statistics dataset.

Countries Included:

- United States (US)
- Great Britain (GB)
- India (IN)

Dataset Summary:

- Total Records: 46,230
- Total Categories: 17
- Data Format: CSV

3. Project Folder Structure

part1_python_foundations/
│
├── README.md
├── TrendPulse_Part1.ipynb
│
└── data/
    ├── USvideos.csv
    ├── GBvideos.csv
    ├── INvideos.csv
    └── categories.csv

4. Technologies Used

- Python
- Pandas
- Google Colab
- Git and GitHub
- Python Built-in Data Structures

5. Installation and Requirements

Requirements

- Python 3
- Pandas

Install Dependencies

pip install pandas

The notebook can be opened and executed using Google Colab or Jupyter Notebook.

6. Key Tasks Completed

1. Loaded CSV datasets using Pandas.
2. Converted DataFrame records into Python dictionaries.
3. Cleaned numeric, Boolean, date, and datetime values.
4. Used lists, tuples, sets, and dictionaries.
5. Compared unique video IDs across countries using sets.
6. Identified the top 15 channels.
7. Created country-wise category summaries.
8. Demonstrated local and global scope.
9. Practiced for loops, while loops, range(), break, and continue.
10. Created reusable functions for data processing.
11. Classified videos using conditional statements.
12. Refactored repeated logic into reusable functions.

7. Data Cleaning

The following cleaning operations were performed:

- Invalid or missing numeric values were replaced with 0.
- Boolean values were converted into True or False.
- Invalid date values were handled using None.
- Trending dates were converted into Python date objects.
- Publish times were converted into timezone-aware datetime objects.
- Original records were preserved without removing rows.

8. Python Data Structures

The project demonstrates:

- Lists: Storing collections of records.
- Dictionaries: Storing video information as key-value pairs.
- Tuples: Representing structured video records.
- Sets: Finding unique video IDs, intersections, and differences.
- Nested Dictionaries: Organizing country-wise and category-wise summaries.

9. Video Classification

Videos were classified into five categories using views, like ratio, and engagement-related conditions.

Classification Thresholds

Metric| Threshold
Viral Views| 1,000,000 or more
Steady Views| 100,000 or more
Divisive Views| 50,000 or more
High Like Ratio| 0.70 or more
Low Like Ratio| Below 0.50

Classification Categories

- Viral Hit: Videos with at least 1 million views and a like ratio of 0.70 or higher.
- Steady Performer: Videos meeting the steady-view threshold and the applicable like-ratio and comment conditions, or viral-level videos with a moderate like ratio.
- Divisive: Videos with a low like ratio under the applicable view conditions.
- Low Engagement: Videos with low views, zero views, invalid negative metrics, or insufficient engagement under the classification rules.
- Unrated: Videos with ratings disabled or no likes and dislikes.

Classification Results

Category| Count
Viral Hit| 9,555
Steady Performer| 27,345
Divisive| 47
Low Engagement| 8,739
Unrated| 544
Total| 46,230

The classification logic uses nested conditional statements and safely handles zero ratings and invalid values.

10. How to Run the Project

1. Open "TrendPulse_Part1.ipynb" using Google Colab.
2. Ensure the four CSV files are available in the "data" folder.
3. Update the dataset path in the notebook if required.
4. Run all notebook cells from top to bottom.
5. Check the outputs and final validation results.

11. Final Validation

The project includes validation checks for:

- Minimum cleaned record count.
- Number of countries processed.
- Total category count.
- Tuple and record count consistency.
- Classification count consistency.

Expected validation output:

"All final validation checks passed."

12. Dataset Source

YouTube Trending Video Statistics dataset provided as part of the TrendPulse mini project assignment.

---

Project: TrendPulse
Part: 1 – Python Foundations & Data Structures
Status: Completed
