-- Solved on: PostgreSQL 14

WITH cte_hit_songs AS (
  SELECT 
    A.name, B.artist_name, COUNT(day) AS top_ten_days
  FROM songs A
  LEFT JOIN artists B ON A.artist_id = B.artist_id
  LEFT JOIN global_song_rank C ON A.song_id = C.song_id
  WHERE C.rank <= 10
  GROUP BY A.name, B.artist_name
)

, cte_appearance_frequency AS (
  SELECT 
    artist_name, SUM(top_ten_days) as frequency
  FROM cte_hit_songs
  GROUP BY artist_name
)

, cte_artist_rankings AS (
  SELECT 
    artist_name
    , DENSE_RANK() over (ORDER BY frequency DESC) AS artist_rank
  FROM cte_appearance_frequency
)

SELECT * FROM cte_artist_rankings 
WHERE artist_rank <= 5
ORDER BY 2,1;