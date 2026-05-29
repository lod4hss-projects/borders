
create table step_persons_old AS
select *
from step_persons;



-- step_persons definition

-- drop table step_persons;
CREATE TABLE step_persons (
	pk_step_persons INTEGER PRIMARY KEY AUTOINCREMENT,
	fk_step integer,
	label TEXT,
	d_1 numeric,
	d_2 numeric,
	d_3 numeric,
	d_4 numeric,
	e_1 numeric,
	e_2 numeric,
	e_3 numeric,
	e_4 numeric,
	income integer,
	description TEXT,
	notes TEXT,
	
    FOREIGN KEY (fk_step) REFERENCES step(pk_step)
);





--INSERT INTO step_persons (fk_step, income, d_1, d_2, d_3, d_4, e_1, e_2, e_3, e_4, label, notes)
SELECT fk_step, income, d_1, d_2, d_3, d_4, e_1, e_2, e_3, e_4, description, notes   --1, description, notes
FROM step_persons_old spo
ORDER BY spo.pk_step_persons;

SELECT fk_step, income, d_1, d_2, d_3, d_4, e_1, e_2, e_3, e_4, description, notes
FROM step_persons_old
ORDER BY pk_step_persons;

SELECT pk_step_persons, fk_step, label, d_1, d_2, d_3, d_4, e_1, e_2, e_3, e_4, income, description, notes
FROM step_persons
ORDER BY pk_step_persons;



drop TABLE step_cargo;
CREATE TABLE step_cargo (
	pk_step_cargo INTEGER PRIMARY KEY AUTOINCREMENT,
	fk_step_cargo integer,
	label TEXT,
	emb_weight_in_tons numeric, -- embarked
	dis_weight_in_tons numeric, -- disembarked
	income integer,
	description TEXT,
	notes TEXT,
	
    FOREIGN KEY (fk_step_cargo) REFERENCES step(pk_step)
);

select *
from step_cargo;



create table step_cargo_old AS
select * from step_cargo;

INSERT INTO step_cargo ( fk_step_cargo, label, emb_weight_in_tons, dis_weight_in_tons, income, notes) 
SELECT fk_step_cargo, description, emb_weight_in_tons, dis_weight_in_tons, income, notes
FROM step_cargo_old
ORDER BY pk_step_cargo;





