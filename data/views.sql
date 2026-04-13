

SELECT *,
	CASE 
		WHEN arrival_date_iso IS NULL OR LENGTH(arrival_date_iso) = 0
		THEN departure_date_iso
		ELSE arrival_date_iso
	END AS order_by_date
FROM step s
ORDER BY fk_voyage, order_by_date;

SELECT *
FROM voyage v 
ORDER BY v.begin_date_iso ;

/*
 * Create view to order voyages and steps in time
 */

CREATE VIEW v_sort_by_departure_and_step_date AS
SELECT s.*,
	v.departure_date_iso voyage_departure,
	CASE 
		WHEN s.arrival_date_iso IS NULL OR LENGTH(s.arrival_date_iso) = 0
		THEN s.departure_date_iso
		ELSE s.arrival_date_iso
	END AS order_by_date
FROM step s
	JOIN voyage v on v.pk_voyage = s.fk_voyage 
ORDER BY voyage_departure, fk_voyage, order_by_date;

-- query the view
SELECT *
FROM v_sort_by_departure_and_step_date;




