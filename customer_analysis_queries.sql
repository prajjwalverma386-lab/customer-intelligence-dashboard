-- =========================================
-- Customer intelligence Table
-- =========================================

Create table Customer_data as

SELECT 
    customerid,

    COUNT(DISTINCT invoiceno) AS total_orders,

    SUM(CASE 
        WHEN quantity > 0 THEN quantity * unitprice 
        ELSE 0 
    END) AS purchase_amount,

    SUM(CASE 
        WHEN quantity < 0 THEN ABS(quantity * unitprice) 
        ELSE 0 
    END) AS return_amount,

    SUM(quantity * unitprice) AS net_revenue,
	min(invoicedate) as first_purchase_date,

    MAX(invoicedate) AS last_purchase_date
	

FROM cleaned_data
GROUP BY customerid;


-- =========================================
-- Customer Segmentation Analysis
-- =========================================

select *,
case 
when return_amount/nullif(purchase_amount, 0) > 0.5 then 'high return'
when net_revenue >= 1000 then 'high value'
when total_orders = 1 then 'one time'
when net_revenue >= 10000 then 'VIP'
else 'standard'
end as segment 
from customer_data;

GROUP BY customer_id;


