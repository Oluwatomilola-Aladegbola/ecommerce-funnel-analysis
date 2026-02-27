SELECT *
FROM `sqllessons-487804.Users_events.user_events`
LIMIT 10;

---Defiining sales funnel and stages of the funnel

WITH funnel_stages AS (

  SELECT 
    COUNT (DISTINCT CASE WHEN event_type='page_view' THEN user_id END) AS stage1_views,
    COUNT (DISTINCT CASE WHEN event_type='add_to_cart' THEN user_id END) AS stage2_cart,
    COUNT (DISTINCT CASE WHEN event_type='checkout_start' THEN user_id END) AS stage3_checkout,
    COUNT (DISTINCT CASE WHEN event_type='payment_info' THEN user_id END) AS stage4_payment,
    COUNT (DISTINCT CASE WHEN event_type='purchase' THEN user_id END) AS stage5_purchase

  FROM `sqllessons-487804.Users_events.user_events`

  ----WITH A FOCUS on the last30 days--filter
  WHERE event_date >= TIMESTAMP (DATE_SUB(CURRENT_DATE(),INTERVAL 30 DAY))
)


---CONVERSION RATES ACROSS THE DIFFERENT STAGES

SELECT
  stage1_views,
  stage2_cart,
  ROUND(stage2_cart *100 / stage1_views) AS view_to_cart_rate,

  stage3_checkout,
  ROUND (stage3_checkout *100/stage2_cart) AS cart_to_checkout_rate,
  
  stage4_payment,
  ROUND(stage4_payment *100/ stage3_checkout) AS checkout_to_payment_rate,

  stage5_purchase,
  ROUND(stage5_purchase *100/ stage4_payment) AS payment_to_purchase_rate,

  ROUND(stage5_purchase *100/ stage1_views) AS overall_conversion_rate

FROM funnel_stages;

---Analysis on the different marketing channels

WITH source_funnel AS (
  SELECT 
    traffic_source, 
    COUNT (DISTINCT CASE WHEN event_type='page_view' THEN user_id END) AS views,
    COUNT (DISTINCT CASE WHEN event_type='add_to_cart' THEN user_id END) AS carts,
    COUNT (DISTINCT CASE WHEN event_type='purchase' THEN user_id END) AS purchases
    FROM `sqllessons-487804.Users_events.user_events`

    WHERE event_date >= TIMESTAMP (DATE_SUB(CURRENT_DATE(),INTERVAL 30 DAY))

    GROUP BY traffic_source
)

SELECT  traffic_source, views, carts, purchases,
ROUND (carts*100/views) AS cart_conversion_rate,
ROUND (purchases*100/views) AS purchase_conversion_rate,
ROUND (purchases*100/carts) AS cart_to_purchase_conversion_rate
FROM source_funnel
ORDER BY purchases DESC;

----Time conversion analysis

WITH user_journey AS (
  SELECT 
    user_id, 
    MIN(CASE WHEN event_type='page_view' THEN event_date END) AS view_time,
    MIN(CASE WHEN event_type='add_to_cart' THEN event_date END) AS cart_time,
    MIN(CASE WHEN event_type='purchase' THEN event_date END) AS purchase_time
  FROM `sqllessons-487804.Users_events.user_events`

  WHERE event_date >= TIMESTAMP (DATE_SUB(CURRENT_DATE(),INTERVAL 30 DAY))
  GROUP BY user_id
  HAVING MIN(CASE WHEN event_type='purchase' THEN event_date END) IS NOT NULL
  
)

SELECT 
  COUNT (*) AS converted_users,
  ROUND(AVG(TIMESTAMP_DIFF(cart_time, view_time, MINUTE)),2) AS avg_view_to_cart_minutes,
  ROUND(AVG(TIMESTAMP_DIFF(purchase_time, cart_time, MINUTE)),2) AS avg_cart_to_purchase_minutes,
  ROUND(AVG(TIMESTAMP_DIFF(purchase_time, view_time, MINUTE)),2) AS avg_total_journey_minutes,
  

FROM user_journey;

-----Revenue funnel analysis
WITH funnel_revenue AS (
  SELECT 
    COUNT(DISTINCT CASE WHEN event_type='page_view' THEN user_id END) AS total_visitors,
    COUNT(DISTINCT CASE WHEN event_type='purchase' THEN user_id END) AS total_buyers,
    SUM(CASE WHEN event_type='purchase' THEN amount END) AS total_revenue,
    COUNT(CASE WHEN event_type='purchase' THEN 1 END) AS total_orders
  FROM `sqllessons-487804.Users_events.user_events`

  WHERE event_date >= TIMESTAMP (DATE_SUB(CURRENT_DATE(),INTERVAL 30 DAY))
  
)

SELECT
  total_visitors,
  total_buyers,
  total_orders,
  total_revenue,
  total_revenue/total_orders AS avg_order_value,
  total_revenue/total_buyers AS revenue_per_buyer,
  total_revenue/total_visitors AS revenue_per_visitor
FROM funnel_revenue

