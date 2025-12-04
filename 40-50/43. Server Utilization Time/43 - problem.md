# Server Utilization Time [Amazon SQL Interview Question]

> Problem info:
> Difficulty: `Hard`
> Company: `Amazon`

Amazon Web Services (AWS) is powered by fleets of servers. Senior management has requested data-driven solutions to optimize server usage.

Write a query that calculates the total time that the fleet of servers was running. The output should be in units of **full days**.

## Assumptions:
- Each server might start and stop several times.
- The total time in which the server fleet is running can be calculated as the sum of each server's uptime.

## `server_utilization` Table:

| Column Name | Type |
| --- | --- |
| server_id | integer |
| status_time | timestamp |
| session_status | string |

### `server_utilization` Example Input:

| server_id | status_time | session_status |
| --- | --- | --- |
| 1 | 08/02/2022 10:00:00 | start |
| 1 | 08/04/2022 10:00:00 | stop |
| 2 | 08/17/2022 10:00:00 | start |
| 2 | 08/24/2022 10:00:00 | stop |

## Example Output:

| total_uptime_days |
| --- |
| 21 |

### Explanation

In the example output, the combined uptime of all the servers (from each start time to stop time) totals 21 full days.

The dataset you are querying against may have different input & output - this is just an example!