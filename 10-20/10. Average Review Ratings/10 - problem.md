# Average Review Ratings [Amazon SQL Interview Question]

> Problem info:
> Difficulty: `Easy`
> Company: `Amazon`

Given the reviews table, write a query to retrieve the average star rating for each product, grouped by month. The output should display the month as a numerical value, product ID, and average star rating rounded to two decimal places. Sort the output first by month and then by product ID.

P.S. If you've read the Ace the Data Science Interview, and liked it, consider writing us a review?

## `reviews` Table:

| Column Name | Type |
| --- | --- |
| review_id | integer |
| user_id | integer |
| submit_date | datetime |
| product_id | integer |
| stars | integer (1-5) |

### `reviews` Example Input:

| review_id | user_id | submit_date | product_id | stars |
| --- | --- | --- | --- | --- |
| 6171 | 123 | 06/08/2022 00:00:00 | 50001 | 4 |
| 7802 | 265 | 06/10/2022 00:00:00 | 69852 | 4 |
| 5293 | 362 | 06/18/2022 00:00:00 | 50001 | 3 |
| 6352 | 192 | 07/26/2022 00:00:00 | 69852 | 3 |
| 4517 | 981 | 07/05/2022 00:00:00 | 69852 | 2 |

## Example Output:

| mth | product | avg_stars |
| --- | --- | --- |
| 6 | 50001 | 3.50 |
| 6 | 69852 | 4.00 |
| 7 | 69852 | 2.50 |

### Explanation

Product 50001 received two ratings of 4 and 3 in the month of June (6th month), resulting in an average star rating of 3.5.

The dataset you are querying against may have different input & output - this is just an example!

Want to try other Amazon SQL Interview Questions?

Here's some more Amazon SQL Interview Questions: