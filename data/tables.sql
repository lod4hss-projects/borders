



-- step_persons definition

CREATE TABLE step_persons (
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