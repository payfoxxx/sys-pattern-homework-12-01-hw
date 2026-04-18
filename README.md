# Домашнее задание к занятию "`Базы данных`" - `Матухно Игорь`

### Задание 1

![Схема-БД](https://github.com/payfoxxx/sys-pattern-homework-12-01-hw/blob/main/img/db_scheme.png)

### Задание 2

CREATE TABLE positions (
	id serial PRIMARY KEY,
	position_name varchar(50) NOT NULL UNIQUE
);

CREATE TABLE subunit_types (
	id serial PRIMARY KEY,
	subunit_type_name varchar(100) NOT NULL UNIQUE
);

CREATE TABLE structural_subunits (
	id serial PRIMARY KEY,
	structural_subunit_name varchar(100) NOT NULL UNIQUE
);

CREATE TABLE addresses (
	id serial PRIMARY KEY,
	address_name varchar(150) NOT NULL UNIQUE
);

CREATE TABLE projects (
	id serial PRIMARY KEY,
	project_name varchar(150) NOT NULL UNIQUE
);

CREATE TABLE employees (
	id serial PRIMARY KEY,
	name varchar(150),
	salary float,
	hire_date date,
	position_id int,
	subunit_type_id int,
	structural_subunit_id int,
	address_id int,
	FOREIGN KEY (position_id) REFERENCES positions(id),
	FOREIGN KEY (subunit_type_id) REFERENCES subunit_types(id),
	FOREIGN KEY (structural_subunit_id) REFERENCES structural_subunits(id),
	FOREIGN KEY (address_id) REFERENCES addresses(id)
);

CREATE TABLE employees_project (
	employer_id int,
	project_id int,
	PRIMARY KEY(employer_id, project_id),
	FOREIGN KEY (employer_id) REFERENCES employees(id),
	FOREIGN KEY (project_id) REFERENCES projects(id)
);


