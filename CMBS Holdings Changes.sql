DECLARE @BEG_DATE AS DATE
DECLARE @END_DATE AS DATE
SET @BEG_DATE = '2024-01-02'
SET @END_DATE = '2024-12-18';

WITH cte_prior AS(
	SELECT DISTINCT
		b.cusip, b.name
	FROM 
		TRPRef.position.v_position_master a, TRPRef.security.v_security_master b, TRPRef.pricing.pricing_master c, TRPRef.account.account_master d, TRPRef.security.v_analytic_fixed_income_current e
	WHERE
		a.security_id = b.security_id AND a.security_id = c.security_id AND a.security_id = e.security_id
		AND b.instrument_type LIKE 'CMBS' 
		--AND b.name NOT LIKE 'FRETE%' 
		AND a.effective_date = @BEG_DATE AND a.effective_date = c.effective_date AND a.effective_date = e.effective_date
		AND d.is_active = 'true' AND d.portfolio_type <> 'EQ' AND d.account_type_trp <> 'INDEX' AND d.account_type_trp <> 'MODEL' AND acnominor <> ''
		AND a.account_id = d.account_id
		AND e.provider_code = 'LehTax'),
	
	cte_current AS(
	SELECT DISTINCT
		b.cusip, b.name
	FROM 
		TRPRef.position.v_position_master a, TRPRef.security.v_security_master b, TRPRef.pricing.pricing_master c, TRPRef.account.account_master d, TRPRef.security.v_analytic_fixed_income_current e
	WHERE
		a.security_id = b.security_id AND a.security_id = c.security_id AND a.security_id = e.security_id
		AND b.instrument_type LIKE 'CMBS' 
		--AND b.name NOT LIKE 'FRETE%' 
		AND a.effective_date = @END_DATE AND a.effective_date = c.effective_date AND a.effective_date = e.effective_date
		AND d.is_active = 'true' AND d.portfolio_type <> 'EQ' AND d.account_type_trp <> 'INDEX' AND d.account_type_trp <> 'MODEL' AND acnominor <> ''
		AND a.account_id = d.account_id
		AND e.provider_code = 'LehTax')

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
	
