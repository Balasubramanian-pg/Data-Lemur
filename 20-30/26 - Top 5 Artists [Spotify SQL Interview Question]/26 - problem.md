# Top 5 Artists [Spotify SQL Interview Question]

> Problem info:
> Difficulty: `Medium`
> Company: `Spotify`

Assume there are three Spotify tables: artists, songs, and global_song_rank, which contain information about the artists, songs, and music charts, respectively.

Write a query to find the top 5 artists whose songs appear most frequently in the Top 10 of the global_song_rank table. Display the top 5 artist names in ascending order, along with their song appearance ranking.

If two or more artists have the same number of song appearances, they should be assigned the same ranking, and the rank numbers should be continuous (i.e. 1, 2, 2, 3, 4, 5). If you've never seen a rank order like this before, do the rank window function tutorial.

## `artists` Table:

| Column Name | Type |
| ---- | ---- |
| artist_id | integer |
| artist_name | varchar |
| label_owner | varchar |

### `artists` Example Input:

| artist_id | artist_name | label_owner |
| ---- | ---- | ---- |
| 101 | Ed Sheeran | Warner Music Group |
| 120 | Drake | Warner Music Group |
| 125 | Bad Bunny | Rimas Entertainment |

## `songs` Table:

| Column Name | Type |
| ---- | ---- |
| song_id | integer |
| artist_id | integer |
| name | varchar |

### `songs` Example Input:

| song_id | artist_id | name |
| ---- | ---- | ---- |
| 55511 | 101 | Perfect |
| 45202 | 101 | Shape of You |
| 22222 | 120 | One Dance |
| 19960 | 120 | Hotline Bling |

## `global_song_rank` Table:

| Column Name | Type |
| ---- | ---- |
| day | integer (1-52) |
| song_id | integer |
| rank | integer (1-1,000,000) |

### `global_song_rank` Example Input:

| day | song_id | rank |
| ---- | ---- | ---- |
| 1 | 45202 | 5 |
| 3 | 45202 | 2 |
| 1 | 19960 | 3 |
| 9 | 19960 | 15 |

## Example Output:

| artist_name | artist_rank |
| ---- | ---- |
| Ed Sheeran | 1 |
| Drake | 2 |

### Explanation:

Ed Sheeran's song appeared twice in the Top 10 list of global song rank while Drake's song is only listed once. Therefore, Ed is ranked #1 and Drake is ranked #2.

The dataset you are querying against may have different input & output - this is just an example!