-- TrendPulse Part 4: SQL & Spreadsheet Analysis (MySQL 8.0+)
-- WARNING: DROP DATABASE recreates this assignment database from scratch.
-- Back up any existing trendpulse_db before running if it contains work you need.
DROP DATABASE IF EXISTS trendpulse_db;
CREATE DATABASE trendpulse_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE trendpulse_db;

CREATE TABLE categories (
  category_id INT PRIMARY KEY,
  category_name VARCHAR(100) NOT NULL
);
CREATE TABLE videos (
  video_id VARCHAR(20) PRIMARY KEY,
  title TEXT,
  channel_title VARCHAR(255),
  category_id INT NOT NULL,
  publish_time DATETIME NULL,
  CONSTRAINT fk_videos_category FOREIGN KEY (category_id) REFERENCES categories(category_id)
);
CREATE TABLE trending_records (
  record_id BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  video_id VARCHAR(20) NOT NULL, country CHAR(2) NOT NULL, trending_date DATE NOT NULL,
  views BIGINT NOT NULL, likes BIGINT NOT NULL DEFAULT 0, dislikes BIGINT NOT NULL DEFAULT 0, comment_count BIGINT NOT NULL DEFAULT 0,
  CONSTRAINT uq_video_country_date UNIQUE (video_id,country,trending_date),
  CONSTRAINT fk_records_video FOREIGN KEY (video_id) REFERENCES videos(video_id)
);

-- Load with MySQL Workbench Table Data Import Wizard in this order:
-- 1) data/categories.csv -> categories; 2) data/videos.csv -> videos; 3) data/trending_records.csv -> trending_records.
-- Map columns by header. Do not map record_id (AUTO_INCREMENT).
-- Row-count evidence (execute after import):
SELECT COUNT(*) AS categories_rows FROM categories; -- expected 17
SELECT COUNT(*) AS videos_rows FROM videos; -- expected 14699
SELECT COUNT(*) AS trending_records_rows FROM trending_records; -- expected 46000

-- Q1 SELECT, WHERE, ORDER BY, LIMIT, aliases
SELECT country AS market, video_id, views AS view_count FROM trending_records WHERE country='US' ORDER BY views DESC LIMIT 10;
-- Q2 DISTINCT countries
SELECT DISTINCT country AS market FROM trending_records ORDER BY market;
-- Q3 DISTINCT category names present in videos
SELECT DISTINCT c.category_name AS category FROM categories c INNER JOIN videos v ON v.category_id=c.category_id ORDER BY category LIMIT 12;
-- Q4 GROUP BY, aggregate, HAVING
SELECT c.category_name, COUNT(*) AS record_count, ROUND(AVG(r.views),2) AS average_views FROM trending_records r INNER JOIN videos v ON v.video_id=r.video_id INNER JOIN categories c ON c.category_id=v.category_id GROUP BY c.category_id,c.category_name HAVING AVG(r.views)>500000 ORDER BY average_views DESC LIMIT 10;
-- Q5 GROUP BY/HAVING: channels with >=5 distinct trending videos
SELECT v.channel_title, COUNT(DISTINCT r.video_id) AS distinct_videos FROM videos v INNER JOIN trending_records r ON r.video_id=v.video_id GROUP BY v.channel_title HAVING COUNT(DISTINCT r.video_id)>=5 ORDER BY distinct_videos DESC LIMIT 10;
-- Q6 INNER JOIN: only complete record/video/category matches
SELECT r.country,r.trending_date,v.video_id,v.title,c.category_name,r.views FROM trending_records r INNER JOIN videos v ON v.video_id=r.video_id INNER JOIN categories c ON c.category_id=v.category_id ORDER BY r.views DESC LIMIT 10;
-- Q7 LEFT JOIN: retain all categories, including categories with no video
SELECT c.category_id,c.category_name,COUNT(v.video_id) AS video_count FROM categories c LEFT JOIN videos v ON v.category_id=c.category_id GROUP BY c.category_id,c.category_name ORDER BY video_count,c.category_name;
-- Q8 RIGHT JOIN: retain every category from the right-hand table
SELECT c.category_id,c.category_name,v.video_id,v.title FROM videos v RIGHT JOIN categories c ON c.category_id=v.category_id ORDER BY c.category_id,v.video_id LIMIT 20;
-- Q9 country record counts (cross-check with COUNTIF)
SELECT country AS market,COUNT(*) AS record_count FROM trending_records GROUP BY country ORDER BY market;
-- Q10 average views by category and country (PivotTable cross-check)
SELECT c.category_name,r.country,ROUND(AVG(r.views),2) AS average_views FROM trending_records r INNER JOIN videos v ON v.video_id=r.video_id INNER JOIN categories c ON c.category_id=v.category_id GROUP BY c.category_id,c.category_name,r.country ORDER BY c.category_name,r.country;
-- Q11 overall average views (cross-check with AVERAGE)
SELECT ROUND(AVG(views),2) AS overall_average_views FROM trending_records;
