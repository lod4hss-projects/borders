




-- step_persons definition

CREATE TABLE step_persons (
	pk_step_persons INTEGER PRIMARY KEY AUTOINCREMENT,
	fk_step integer,
	income integer,
	d_1 numeric,
	d_2 numeric,
	d_3 numeric,
	d_4 numeric,
	e_1 numeric,
	e_2 numeric,
	e_3 numeric,
	e_4 numeric,
	label TEXT,
	description TEXT,
	notes TEXT,
	
    FOREIGN KEY (fk_step) REFERENCES step(pk_step)
);


--INSERT INTO step_persons (fk_step, income, d_1, d_2, d_3, d_4, e_1, e_2, e_3, e_4, label, description, notes)
SELECT fk_step, income, d_1, d_2, d_3, d_4, e_1, e_2, e_3, e_4, label, description, notes
FROM step_persons_old spo
ORDER BY spo.pk_step_persons;

SELECT fk_step, income, d_1, d_2, d_3, d_4, e_1, e_2, e_3, e_4, label, description, notes
FROM step_persons
ORDER BY pk_step_persons;


-- step_persons definition

CREATE TABLE step_persons_old (
	pk_step_persons INTEGER PRIMARY KEY AUTOINCREMENT,
	fk_step integer,
	income integer,
	e_1 numeric,
	e_2 numeric,
	e_3 numeric,
	e_4 numeric,
	d_1 numeric,
	d_2 numeric,
	d_3 numeric,
	d_4 numeric,
	label TEXT,
	description TEXT,
	notes TEXT,
	
    FOREIGN KEY (fk_step) REFERENCES step(pk_step)
);


-- step_persons definition

CREATE TABLE step_cargo (
	pk_step_cargo INTEGER PRIMARY KEY AUTOINCREMENT,
	fk_step_cargo integer,
	income integer,
	emb_weight_in_tonnes numeric, -- embarked
	dis_weight_in_tonnes numeric, -- disembarked
	label TEXT,
	description TEXT,
	notes TEXT,
	
    FOREIGN KEY (fk_step_cargo) REFERENCES step(pk_step)
);