CREATE TABLE IF NOT EXISTS department (
	department_id SERIAL PRIMARY KEY,
	name VARCHAR(80) unique NOT NULL
);

CREATE TABLE IF NOT EXISTS employee (
	employee_id SERIAL PRIMARY KEY,
	name VARCHAR(60) NOT null,
	department_id INTEGER references department(department_id),
	boss_id INTEGER references employee(employee_id)
);