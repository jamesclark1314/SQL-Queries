DECLARE @as_of AS DATE
SET @as_of = '2023-02-28'

SELECT 
	as_of_date, 
	ml_industry_lvl_4,

	CASE 
		WHEN rating = 'AAA' THEN 'AAA'
		WHEN rating = 'AA3' OR rating = 'AA2' OR rating = 'AA1' THEN 'AA'
		WHEN rating = 'A3' OR rating = 'A2' OR rating = 'A1' THEN 'A'
		WHEN rating = 'BBB3' OR rating = 'BBB2' OR rating = 'BBB1' THEN 'BBB'
		WHEN rating = 'BB3' OR rating = 'BB2' OR rating = 'BB1' THEN 'BB'
		WHEN rating = 'B3' OR rating = 'B2' OR rating = 'B1' THEN 'B'
		ELSE rating 
	END AS ratings_bkt, 

	COUNT(*) AS bond_cnt,
	SUM(mkt_pct_index_wght * excess_rtn_pct_1M) / SUM(mkt_pct_index_wght) AS excess_rtn_1m,	
	SUM(mkt_pct_index_wght * spread_duration) / SUM(mkt_pct_index_wght) AS OASD,
	SUM(mkt_pct_index_wght * OAS) / SUM(mkt_pct_index_wght) AS OAS

FROM [externalstorage].[ice].[constituent_new_main_history]
WHERE ml_industry_lvl_4 LIKE 'ABS%'

AND as_of_date >= @as_of

GROUP BY 
	as_of_date, 
	ml_industry_lvl_4, 
	CASE 
		WHEN rating = 'AAA' THEN 'AAA'
		WHEN rating = 'AA3' OR rating = 'AA2' OR rating = 'AA1' THEN 'AA'
		WHEN rating = 'A3' OR rating = 'A2' OR rating = 'A1' THEN 'A'
		WHEN rating = 'BBB3' OR rating = 'BBB2' OR rating = 'BBB1' THEN 'BBB'
		WHEN rating = 'BB3' OR rating = 'BB2' OR rating = 'BB1' THEN 'BB'
		WHEN rating = 'B3' OR rating = 'B2' OR rating = 'B1' THEN 'B'
		ELSE rating 
	END
ORDER BY 
	as_of_date,
	ml_industry_lvl_4,
	CASE 
		WHEN rating = 'AAA' THEN 'AAA'
		WHEN rating = 'AA3' OR rating = 'AA2' OR rating = 'AA1' THEN 'AA'
		WHEN rating = 'A3' OR rating = 'A2' OR rating = 'A1' THEN 'A'
		WHEN rating = 'BBB3' OR rating = 'BBB2' OR rating = 'BBB1' THEN 'BBB'
		WHEN rating = 'BB3' OR rating = 'BB2' OR rating = 'BB1' THEN 'BB'
		WHEN rating = 'B3' OR rating = 'B2' OR rating = 'B1' THEN 'B'
		ELSE rating 
	END;
