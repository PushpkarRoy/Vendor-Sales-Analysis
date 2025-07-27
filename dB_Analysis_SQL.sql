CREATE TABLE begin_inventory (
    InventoryId VARCHAR(50),
    Store INT, 
    City VARCHAR(50),
    Brand INT, 
    Description VARCHAR(200),
    Size VARCHAR(20),
    onHand INT, 
    Price FLOAT,
    startDate DATE
);

CREATE TABLE end_inventory (
InventoryId	VARCHAR(50),
Store INT, 
City VARCHAR(50),
Brand INT, 
Description VARCHAR(200),
Size VARCHAR(20),
onHand INT, 
Price FLOAT,
endDate DATE
)

CREATE TABLE purchase_prices (
    Brand INT,
    Description VARCHAR(300),
    Price FLOAT,
    Size VARCHAR(20),
    Volume VARCHAR(20),
    Classification INT,
    PurchasePrice FLOAT,
    VendorNumber INT,
    VendorName VARCHAR(300)
);

CREATE TABLE purchase (
    InventoryId VARCHAR(100),
    Store INT, 
    Brand INT, 
    Description VARCHAR(300),
    Size VARCHAR(20),
    VendorNumber INT, 
    VendorName VARCHAR(200),
    PONumber INT, 
    PODate DATE, 
    ReceivingDate DATE, 
    InvoiceDate DATE, 
    PayDate DATE, 
    PurchasePrice FLOAT, 
    Quantity INT, 
    Dollars FLOAT, 
    Classification INT
);

CREATE TABLE sales (
InventoryId VARCHAR(50),
Store INT, 
Brand INT, 
Description VARCHAR(300),	
Size VARCHAR(20),
SalesQuantity INT, 
SalesDollars FLOAT, 
SalesPrice	FLOAT, 
SalesDate DATE, 
Volume INT, 
Classification INT, 
ExciseTax FLOAT, 
VendorNo INT, 
VendorName VARCHAR(300)
)


CREATE TABLE sales (
    inventoryid VARCHAR(50),
    store INT,
    brand INT,
    description VARCHAR(300),
    size VARCHAR(50),
    salesquantity INT,
    salesdollars NUMERIC(10, 2),
    salesprice NUMERIC(10, 2),
    salesdate DATE,
    volume NUMERIC(10, 2),         -- Changed from INT to NUMERIC to handle "750.0"
    classification INT,
    excisetax NUMERIC(10, 2),
    vendorno INT,
    vendorname VARCHAR(300)
);

CREATE TABLE vendor_invoice(
VendorNumber INT,
VendorName VARCHAR(200),
InvoiceDate DATE, 
PONumber INT, 
PODate DATE,
PayDate DATE,
Quantity INT, 
Dollars	 FLOAT, 
Freight	 FLOAT, 
Approval VARCHAR(100)
)


SELECT * FROM vendor_sales_summary

 
-- Data Analysis Questions 

-- • Identify Brand that need promotionanl or price adjustment which exhibit low sales performance but high profit margins

SELECT  vendorname, 
		ROUND(SUM(gross_profit):: NUMERIC, 2) AS total_profit,
		ROUND(AVG(profit_margin):: NUMERIC,2 ) AS avg_profit_margin
FROM vendor_sales_summary
GROUP BY vendorname
HAVING SUM(gross_profit) > 0 AND SUM(profit_margin) > 0 
ORDER BY total_profit, avg_profit_margin DESC
LIMIT 5

-- • Which vendors and brands demonstrate the highest sales performance ? 

SELECT  
    vendorname, 
    brand,
    ROUND((SUM(total_sales_price) - SUM(total_excise_tax))::NUMERIC, 2) AS net_profit
FROM vendor_sales_summary
GROUP BY vendorname, brand
ORDER BY net_profit DESC
LIMIT 5;

-- • Which vendor contribute the most to total purchase dollars 

SELECT * FROM vendor_sales_summary

SELECT  vendorname, 
		ROUND(SUM(total_purchase_dollars):: NUMERIC ,2) AS total_sales,
		ROUND((SUM(total_purchase_dollars) * 100.0 / ( SELECT SUM(total_purchase_dollars)
												 FROM vendor_sales_summary )):: NUMERIC,2 ) AS percentage
FROM vendor_sales_summary
GROUP BY vendorname
ORDER BY percentage DESC
LIMIT 10

-- • Difference between Top 10 vendor vs other remaing vendors 

SELECT Top_10_vendor, 100 - (	
	SELECT SUM(percentage) AS Top_10_vendor
	FROM (
		SELECT  vendorname, 
				ROUND(SUM(total_purchase_dollars):: NUMERIC ,2) AS total_sales,
				ROUND((SUM(total_purchase_dollars) * 100.0 / ( SELECT SUM(total_purchase_dollars)
														 FROM vendor_sales_summary )):: NUMERIC,2 ) AS percentage
		FROM vendor_sales_summary
		GROUP BY vendorname
		ORDER BY percentage DESC
		LIMIT 10 ) AS x ) AS other_vendor
FROM (SELECT SUM(percentage) AS Top_10_vendor
	FROM (
		SELECT  vendorname, 
				ROUND(SUM(total_purchase_dollars):: NUMERIC ,2) AS total_sales,
				ROUND((SUM(total_purchase_dollars) * 100.0 / ( SELECT SUM(total_purchase_dollars)
														 FROM vendor_sales_summary )):: NUMERIC,2 ) AS percentage
		FROM vendor_sales_summary
		GROUP BY vendorname
		ORDER BY percentage DESC
		LIMIT 10 ) AS x)
GROUP BY Top_10_vendor

""" 
🔍 Insights:

 • Vendor Concentration: The top 10 vendors account for 65.34% of the total purchase spending, 
 	showing that the majority of business is concentrated among a few key vendors.

• Remaining Vendors: The other vendors (90% of the vendor pool) contribute only 34.66%, 
	indicating a long tail of smaller or less active vendors.

• Supply Chain Implication: The company heavily depends on a limited number of vendors. 
	Any disruption with top vendors could significantly affect inventory and operations.

• Opportunity: There is potential to diversify purchasing across more vendors or negotiate better deals with the top contributors.


✅ Conclusion:
•   The organization’s purchasing is heavily skewed towards its top 10 vendors, 
	which together drive over 65% of the total procurement value. 
	Strategic efforts should focus on vendor risk management, price negotiations, and diversification.

"""

-- • Does purchasing in bulk reduce the unit price, and what is the option purchase volume for cost saving 

SELECT order_size , ROUND(AVG(unit_purchase_price):: NUMERIC ,2) AS avg_cost_margin
FROM (
	SELECT  vendorname, total_purchase_dollars, 
			total_purchase_quantity, unit_purchase_price,
			CASE 
				WHEN partition_size = 1 THEN 'Small'
				WHEN partition_size = 2 THEN 'Mediam'
				WHEN partition_size = 3 THEN 'Large'
			END AS order_size
	FROM (
					SELECT *, 
					NTILE(3) OVER (ORDER BY unit_purchase_price) AS partition_size
					FROM (
						SELECT  vendorname, ROUND(total_purchase_dollars) AS 
								total_purchase_dollars, total_purchase_quantity,
								ROUND((SUM(total_purchase_dollars) / 
								SUM(total_purchase_quantity)):: NUMERIC,2 ) AS unit_purchase_price
						FROM vendor_sales_summary
						GROUP BY vendorname, total_purchase_dollars, total_purchase_quantity ) AS x ) AS y ) AS z
GROUP BY order_size
ORDER BY avg_cost_margin DESC

"""
📊 Analysis: Bulk Purchase Impact on Unit Price

 🔍 Output Summary:
 
• Large Orders → ₹57.14 average unit cost

• Medium Orders → ₹10.82 average unit cost

• Small Orders → ₹5.50 average unit cost

✅ Insights:
• ⚡ Vendors buying in bulk ("Large") pay the highest per-unit price.

• This is counterintuitive, as bulk purchases usually reduce cost.

• Indicates that higher volumes are being purchased for premium products, not low-cost items.

• 💰 Small and Medium order groups have much lower average prices.

• Suggests they are buying cheaper items in smaller quantities.

• 🔁 This analysis shows that bulk buying does not always equal cost savings if the product mix differs (e.g., premium vs. regular items).

📌 Business Outcome:

• Bulk pricing benefits may be overshadowed by product type.

• Companies need to differentiate whether bulk orders are driving down unit cost or simply reflect expensive product purchases.

• Procurement teams should analyze volume vs. price on a product-level, not just vendor-level, for smarter purchasing decisions.

"""


-- • Which vendor have low inventory ternover indicating excess stock and slow - moving product ? 

SELECT vendorname, ROUND(AVG(stock_turnover):: NUMERIC, 2)  AS avg_stock_turnover 
FROM vendor_sales_summary
WHERE stock_turnover < 1
GROUP BY vendorname
ORDER BY avg_stock_turnover
LIMIT 10
 
"""
✅ Insights:
• Stock Turnover < 1 implies these vendors are not selling inventory effectively.

• High inventory value is sitting idle, increasing carrying costs and reducing cash flow efficiency.

• Vendors like LAUREATE IMPORTS CO and AAPER ALCOHOL & CHEMICAL CO have zero inventory turnover, which could indicate:

	• No sales activity, or

	• Extremely slow-moving products.

• Vendors such as TRUETT HURST and IRA GOLDMAN AND WILLIAMS, LLP also show very low product movement.

📌 Business Outcome & Recommendation:
• 🔍 These vendors need a stock audit and detailed analysis of unsold inventory.

• 🧠 Marketing and promotion strategies should be introduced to move the slow stock.

• 🚫 Consider reducing future orders or discontinuing low-turnover SKUs to prevent overstocking.

• 📈 Bundle offers, discounts, or alternative product placements may help improve turnover.

"""

-- • How much capital is locked in unsold inventery per vendor and which vendor contribute the most to it ? 

SELECT 
    vendorname,
    ROUND(SUM((total_purchase_quantity - total_sales_quantity) * purchaseprice):: NUMERIC ,2) AS capital_locked
FROM vendor_sales_summary
WHERE total_purchase_quantity > total_sales_quantity
GROUP BY vendorname
ORDER BY capital_locked DESC 
LIMIT 10;



SELECT 
    vendorname,
    ROUND(((SUM(total_purchase_quantity) - SUM(total_sales_quantity)) / 10000.0) :: NUMERIC, 2) AS capital_locked_million_usd
FROM vendor_sales_summary
WHERE (total_purchase_quantity - total_sales_quantity) > 0
GROUP BY vendorname
ORDER BY capital_locked_million_usd DESC
LIMIT 10;


"""
🔍 Insight:

• These vendors hold a large amount of unsold inventory, indicating:

• Overstocking

• Slow-moving products

• Ineffective demand forecasting or poor product-market fit

💡 Business Interpretation:

• MARTIGNETTI COMPANIES tops the list with over ₹19 lakh in blocked capital.

• Combined, the top 3 vendors have over ₹50 lakh tied up in unsold stock.

• This capital could be better utilized in faster-moving inventory or marketing.

✅ Recommendation:

• Perform a stock rotation analysis for these vendors.

• Negotiate return-to-vendor or discounted clearance sales.

• Review demand planning, and adjust future purchase quantities.

• Implement tighter inventory control and vendor accountability measures.

"""

