---
Created: null
Company:
- null
Difficulty: null
Status: Draft
Category: null
Sub Category: null
Question Link: null
Title: Average Vacant Days_from_made_1
Area: Interview Prep
Type: Interview Question
Source: 03. Interview Prep/Interview Question/Data Lemur/Hard/Average Vacant Days_from_made_1.md
Updated: ''
Tags: ''
Topic: ''
Date: ''
---
- **1.** **Identify active listings:**
    
    Filter the listings table to include only those that are currently active (is_active = 1).
    
- **2.** **Calculate rented days:**
    
    For each active listing, calculate the number of days it was rented out within the specified year (e.g., 2021). This involves joining the listings and bookings tables and considering the check-in and check-out dates.
    
- **3.** **Calculate vacant days:**
    
    Subtract the rented days from 365 (or the total number of days in the year) to find the number of vacant days for each listing.
    
- **4.** **Calculate average vacant days:**
    
    Calculate the average of the vacant days across all active listings.
    
- **5.** **Handle edge cases:**
    
    Consider scenarios where a listing might have check-in or check-out dates outside the specified year by appropriately adjusting the date calculations.

SQL

```
WITH ActiveListings AS (
    -- 1. Identify active listings
    SELECT
        listing_id,
        listing_name
    FROM
        listings
    WHERE
        is_active = 1
),
ListingRentedDays AS (
    -- 2. Calculate rented days for each active listing within the specified year (e.g., 2021)
    SELECT
        al.listing_id,
        al.listing_name,
        SUM(
            CASE
                -- Case 1: Booking entirely within the year
                WHEN YEAR(b.check_in_date) = 2021 AND YEAR(b.check_out_date) = 2021
                THEN DATEDIFF(b.check_out_date, b.check_in_date)

                -- Case 2: Booking starts before the year and ends within the year
                WHEN YEAR(b.check_in_date) < 2021 AND YEAR(b.check_out_date) = 2021
                THEN DATEDIFF(b.check_out_date, '2021-01-01')

                -- Case 3: Booking starts within the year and ends after the year
                WHEN YEAR(b.check_in_date) = 2021 AND YEAR(b.check_out_date) > 2021
                THEN DATEDIFF('2021-12-31', b.check_in_date)

                -- Case 4: Booking starts before the year and ends after the year (covers the entire year)
                WHEN YEAR(b.check_in_date) < 2021 AND YEAR(b.check_out_date) > 2021
                THEN 365 -- Assuming 2021 is not a leap year for simplicity, adjust for leap year if needed

                ELSE 0
            END
        ) AS rented_days_2021
    FROM
        ActiveListings al
    LEFT JOIN
        bookings b ON al.listing_id = b.listing_id
    WHERE
        -- Filter bookings relevant to the year 2021 (overlapping in any way)
        b.check_in_date <= '2021-12-31' AND b.check_out_date >= '2021-01-01'
    GROUP BY
        al.listing_id, al.listing_name
),
ListingVacantDays AS (
    -- 3. Calculate vacant days for each listing
    SELECT
        al.listing_id,
        al.listing_name,
        COALESCE(lrd.rented_days_2021, 0) AS rented_days, -- Use COALESCE to handle listings with no bookings
        (365 - COALESCE(lrd.rented_days_2021, 0)) AS vacant_days_2021 -- Assuming 365 days in 2021
    FROM
        ActiveListings al
    LEFT JOIN
        ListingRentedDays lrd ON al.listing_id = lrd.listing_id
)
-- 4. Calculate average vacant days across all active listings
SELECT
    AVG(vacant_days_2021) AS average_vacant_days_2021
FROM
    ListingVacantDays;
```