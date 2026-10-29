
select count(*) as n
from borders.flight_ticket ft ;


-- supprimé les buildings pour les remplaces avec des lieux
--update borders.flight_ticket set destination_uri = null, origin_uri = null;

select *
from borders.flight_ticket 
where origin ~ 'Jerus';

--update borders.flight_ticket ft set origin_uri = 'https://borders.lod4hss.org/resource/iiuGOkRXf'
where origin ~ 'Jerus';

select ft.origin, ft.destination, ft.valid_date_exact_or_from, ft.valid_date_to, ft.trip_type 
from borders.flight_ticket ft 
limit 30;


SELECT
    CASE
        WHEN valid_date_exact_or_from LIKE '% to %' THEN split_part(valid_date_exact_or_from, ' to ', 1)
        ELSE valid_date_exact_or_from
    END AS start_date,
    CASE
        WHEN valid_date_exact_or_from LIKE '% to %' THEN split_part(valid_date_exact_or_from, ' to ', 2)
        ELSE valid_date_exact_or_from
    END AS end_date, trip_type 
FROM borders.flight_ticket;




UPDATE borders.flight_ticket set valid_date_exact_or_from =
    CASE
        WHEN valid_date_exact_or_from LIKE '% to %' THEN split_part(valid_date_exact_or_from, ' to ', 1)
        ELSE valid_date_exact_or_from
    END,
    valid_date_to = 
    CASE
        WHEN valid_date_exact_or_from LIKE '% to %' THEN split_part(valid_date_exact_or_from, ' to ', 2)
        ELSE valid_date_exact_or_from
    END;





-- outbound half price if return
select ft.origin, ft.destination, ft.valid_date_exact_or_from flight_date, 'outbound' as direction,
case
	when trip_type = 'Return'
	then ft.price_le / 2
	else ft.price_le 
end price, ft.trip_type, ft.price_le 
from borders.flight_ticket ft ;




-- outbound
select ft.origin, ft.destination, ft.valid_date_exact_or_from flight_date, 'outbound' as direction,
sum(case
	when trip_type = 'Return'
	then ft.price_le / 2
	else ft.price_le 
end) income,
count(*) as n_tickets, sum(ft.ticket_number) n_persons, sum(ft.price_le) income_full, string_agg(ft.trip_type, ',')
from borders.flight_ticket ft 
group by ft.origin, ft.destination, ft.valid_date_exact_or_from
order by flight_date, ft.origin, ft.destination;


--inbound
with tw1 as (
select ft.destination as origin, ft.origin as destination,
case
	when length(ft.valid_date_to) > 2 then ft.valid_date_to 
	else ft.valid_date_exact_or_from
end as flight_date,
case
	when trip_type = 'Return'
	then ft.price_le / 2
	else ft.price_le 
end price_corr,
	ft.ticket_number, ft.price_le 
from borders.flight_ticket ft 
where ft.trip_type = 'Return')
select tw1.origin, tw1.destination, tw1.flight_date, 'inbound' as direction, 
 count(*) as n_tickets, sum(ticket_number) n_persons,  sum(price_corr) income,
 sum(price_le) income_full
from tw1
group by tw1.origin, tw1.destination, tw1.flight_date
order by tw1.flight_date, origin, destination;


/*
 * Full query and view
 * 
 * NB : trips are not identified explicitely, i.e. that this inbound flight
 * corresponds to that outbound flight. Identifiers shouls be added
 * 
 */

-- outbound
(select ft.origin, ft.destination, ft.valid_date_exact_or_from flight_date, 'outbound' as direction,
 count(*) as n_tickets, sum(ft.ticket_number) n_persons, 
sum(case
	when trip_type = 'Return'
	then ft.price_le / 2
	else ft.price_le 
end) income, ft.origin_uri, ft.destination_uri
from borders.flight_ticket ft 
group by ft.origin, ft.destination, ft.valid_date_exact_or_from, ft.origin_uri, ft.destination_uri
order by flight_date, ft.origin, ft.destination)
UNION
--inbound
(with tw1 as (
select ft.destination as origin, ft.origin as destination,
case
	when length(ft.valid_date_to) > 2 then ft.valid_date_to 
	else ft.valid_date_exact_or_from
end as flight_date, 
	ft.ticket_number,
case
	when trip_type = 'Return'
	then ft.price_le / 2
	else ft.price_le 
end price_corr, ft.origin_uri as destination_uri, ft.destination_uri as origin_uri
from borders.flight_ticket ft 
where ft.trip_type = 'Return')
select tw1.origin, tw1.destination, tw1.flight_date, 'inbound' as direction, 
 count(*) as n_tickets, sum(ticket_number) n_persons, sum(price_corr) income, 
 origin_uri, destination_uri
from tw1
group by tw1.origin, tw1.destination, tw1.flight_date, tw1.origin_uri, tw1.destination_uri)
order by flight_date, origin, destination;



-- view borders.v_flights;
create or replace view borders.v_flights
as 
with tw1 as (
-- outbound
(select ft.origin, ft.destination, ft.valid_date_exact_or_from flight_date, 'outbound' as direction,
 count(*) as n_tickets, sum(ft.ticket_number) n_persons, 
sum(case
	when trip_type = 'Return'
	then ft.price_le / 2
	else ft.price_le 
end) income, ft.origin_uri, ft.destination_uri
from borders.flight_ticket ft 
group by ft.origin, ft.destination, ft.valid_date_exact_or_from, ft.origin_uri, ft.destination_uri
order by flight_date, ft.origin, ft.destination)
UNION
--inbound
(with tw1 as (
select ft.destination as origin, ft.origin as destination,
case
	when length(ft.valid_date_to) > 2 then ft.valid_date_to 
	else ft.valid_date_exact_or_from
end as flight_date, 
	ft.ticket_number,
case
	when trip_type = 'Return'
	then ft.price_le / 2
	else ft.price_le 
end price_corr, ft.origin_uri as destination_uri, ft.destination_uri as origin_uri
from borders.flight_ticket ft 
where ft.trip_type = 'Return')
SELECT tw1.origin, tw1.destination, tw1.flight_date, 'inbound' as direction, 
 count(*) as n_tickets, sum(ticket_number) n_persons, sum(price_corr) income, 
 origin_uri, destination_uri
from tw1
group by tw1.origin, tw1.destination, tw1.flight_date, tw1.origin_uri, tw1.destination_uri))
select row_number() OVER (ORDER BY 1)::INTEGER as id_flight, tw1.*
from tw1
order by flight_date, origin, destination;


select *
from borders.v_flights
limit 10;


-- Verify values: origin
select origin, string_agg(distinct origin_uri, '-'), count(*) as num
from borders.v_flights
group by origin, origin_uri;

-- Verify values: destination
select destination, string_agg(distinct destination_uri, '-'), count(*) as num
from borders.v_flights
group by destination, destination_uri;




/*
 * Create epistemic phases: flights per month per route
 */


select *
from borders.v_flights
limit 10;


select count(*) as flight_n, origin, destination, substr(flight_date, 1, 7) as "month", 
	sum(income) as sum_income, sum(n_persons) as sum_persons,
	origin_uri, destination_uri 
from borders.v_flights
group by origin, destination,substr(flight_date, 1, 7), origin_uri, destination_uri 
order by month, origin, destination
limit 1000;


















