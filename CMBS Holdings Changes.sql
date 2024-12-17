DECLARE @BEG_DATE AS DATE
DECLARE @END_DATE AS DATE
SET @BEG_DATE = '2024-09-16'
SET @END_DATE = '2024-12-16';

WITH cte_prior AS(
	SELECT DISTINCT
		b.cusip, b.name
	FROM 
		TRPRef.position.v_position_master a, TRPRef.security.v_security_master b, TRPRef.pricing.pricing_master c, TRPRef.account.account_master d
	WHERE
		a.security_id = b.security_id AND a.security_id = c.security_id
		AND b.instrument_type LIKE 'CMBS' 
		--AND b.name NOT LIKE 'FRETE%' 
		AND a.effective_date = @BEG_DATE
		AND d.is_active = 'true' AND d.portfolio_type <> 'EQ' AND d.account_type_trp <> 'INDEX' AND d.account_type_trp <> 'MODEL' AND acnominor <> ''
		AND a.account_id = d.account_id),
	
	cte_current AS(
	SELECT DISTINCT
		b.cusip, b.name
	FROM 
		TRPRef.position.v_position_master a, TRPRef.security.v_security_master b, TRPRef.pricing.pricing_master c, TRPRef.account.account_master d
	WHERE
		a.security_id = b.security_id AND a.security_id = c.security_id
		AND b.instrument_type LIKE 'CMBS' 
		--AND b.name NOT LIKE 'FRETE%' 
		AND a.effective_date = @END_DATE
		AND d.is_active = 'true' AND d.portfolio_type <> 'EQ' AND d.account_type_trp <> 'INDEX' AND d.account_type_trp <> 'MODEL' AND acnominor <> ''
		AND a.account_id = d.account_id)

SELECT
	*
FROM
	cte_current
WHERE NOT EXISTS
	(SELECT
		*
	FROM
		cte_prior 
	WHERE 
		cte_prior.cusip = cte_current.cusip);
	
