
```sparql
### Number of triples in the repo graphs
select ?g (count(*) as ?num)
where { graph ?g {?s ?p ?o} }
group by ?g
```
### Create the monthly phases

```sparql
prefix sdh-act: <https://sdhss.org/ontology/human-activity/>
prefix sdh-short: <https://sdhss.org/ontology/shortcuts/>
prefix sdh: <https://sdhss.org/ontology/core/>


select ?flight_month ?number_flights  
    ?placeLabel_from ?geocoord_from ?placeLabel_from ?place_from
    ?placeLabel_to ?geocoord_to ?placeLabel_to ?place_to
WHERE {

{select  ?flight_month ?place_from ?place_to (count(*) as ?number_flights)
where {?flight a sdh-act:C5;
             sdh-short:P1 ?flight_date;
             sdh:P60 ?place_from;
             sdh:P61 ?place_to.
       BIND(SUBSTR(?flight_date, 1, 7) AS ?flight_month)
       
       }
group by ?flight_month ?place_from ?place_to
}

  ?place_from sdh-short:P14 ?geocoord_from.
  ?place_from sdh-short:P9 ?placeLabel_from.
  
  ?place_to sdh-short:P14 ?geocoord_to.
  ?place_to sdh-short:P9 ?placeLabel_to.
}
limit 10

```
### Get the data from agraph

Did not work, security issues?


```sparql
SELECT *
WHERE {
    SERVICE <https://lod4hss1.dh.unibe.ch/agraph/repositories/borders>  {
    GRAPH <https://borders.lod4hss.org/graph/flights>
    {
        ?s ?p ?o
    }
}
}
LIMIT 10
```

```sparql
CONSTRUCT {
        ?s ?p ?o
    }
WHERE {
    SERVICE <https://lod4hss1.dh.unibe.ch/agraph/repositories/borders>  {
    GRAPH <https://borders.lod4hss.org/graph/flights>
    {
        ?s ?p ?o
    }
    }
}
LIMIT 5
```

```sparql
INSERT {
    GRAPH <https://borders.lod4hss.org/graph/flights>
    {
        ?s ?p ?o
    }
}
WHERE {
    SERVICE <https://lod4hss1.dh.unibe.ch/agraph/repositories/borders>  {
    GRAPH <https://borders.lod4hss.org/graph/flights>
    {
        ?s ?p ?o
    }
    }
}
```
### Upload from ontop export file

Worked (29 October 2026)

```sparql
curl -u fb-write \
  -H "Content-Type: text/turtle" \
  --data-binary @statements-20261028.ttl \
  "https://open-gdb.lod4hss.org/repositories/borders/statements?context=<https://borders.lod4hss.org/graph/flights>"
  
```
