from pathlib import Path
import pandas as pd

ROOT = Path(__file__).resolve().parent
SOURCE_DIR = ROOT / "source_data"
DATA_DIR = ROOT / "data"
DATA_DIR.mkdir(exist_ok=True)
COUNTRIES = ["US", "GB", "IN"]
frames = []

for country in COUNTRIES:
    df = pd.read_csv(SOURCE_DIR / f"{country}videos.csv")
    required = {"video_id", "trending_date", "category_id", "views", "likes", "dislikes", "comment_count", "title", "channel_title", "publish_time"}
    missing = required.difference(df.columns)
    if missing:
        raise ValueError(f"{country} CSV is missing columns: {sorted(missing)}")
    df["country"] = country
    df["trending_date"] = pd.to_datetime(df["trending_date"], format="%y.%d.%m", errors="coerce").dt.strftime("%Y-%m-%d")
    df["publish_time"] = pd.to_datetime(df["publish_time"], utc=True, errors="coerce").dt.strftime("%Y-%m-%d %H:%M:%S")
    for col in ["views", "likes", "dislikes", "comment_count", "category_id"]:
        df[col] = pd.to_numeric(df[col], errors="coerce")
    df = df.dropna(subset=["video_id", "trending_date", "category_id", "views"]).copy()
    df = df.drop_duplicates(subset=["video_id", "country", "trending_date"])
    for col in ["likes", "dislikes", "comment_count"]:
        df[col] = df[col].fillna(0).astype("int64")
    df["category_id"] = df["category_id"].astype("int64")
    df["views"] = df["views"].astype("int64")
    frames.append(df)

records_full = pd.concat(frames, ignore_index=True).drop_duplicates(["video_id", "country", "trending_date"])
categories = pd.read_csv(SOURCE_DIR / "categories_source.csv").drop_duplicates("category_id")
categories["category_id"] = pd.to_numeric(categories["category_id"], errors="raise").astype("int64")
if not records_full["category_id"].isin(categories["category_id"]).all():
    raise ValueError("Some trending records reference category IDs absent from categories_source.csv")
videos = (records_full.sort_values(["video_id", "trending_date", "country"]).drop_duplicates("video_id")[["video_id", "title", "channel_title", "category_id", "publish_time"]])
if not records_full["video_id"].isin(videos["video_id"]).all():
    raise ValueError("Trending records contain video IDs absent from videos.csv")
records_full[["video_id", "country", "trending_date", "views", "likes", "dislikes", "comment_count"]].to_csv(DATA_DIR / "trending_records.csv", index=False)
videos.to_csv(DATA_DIR / "videos.csv", index=False)
categories.to_csv(DATA_DIR / "categories.csv", index=False)
print(f"categories: {len(categories):,}")
print(f"videos: {len(videos):,}")
print(f"trending_records: {len(records_full):,}")
