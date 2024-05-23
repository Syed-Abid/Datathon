-- Create the employee table
CREATE type position_enum AS ENUM ('Intern', 'Associate', 'Mid-Level', 'Senior', 'Chief');
CREATE TABLE employee (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    department_id INT,
    position position_enum,
    manager_id INT
);

-- Create the department table
CREATE TABLE department (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL
);

-- Add foreign key constraint for department_id in employee table
ALTER TABLE employee
ADD CONSTRAINT fk_employee_department
FOREIGN KEY (department_id)
REFERENCES department(id);

-- Add foreign key constraint for manager_id in employee table (self-join)
ALTER TABLE employee
ADD CONSTRAINT fk_employee_manager
FOREIGN KEY (manager_id)
REFERENCES employee(id);

-- Add foreign key constraint for head_of_department in department table
ALTER TABLE department
ADD CONSTRAINT fk_department_head
FOREIGN KEY (hod)
REFERENCES employee(id);

CREATE TABLE product_category (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL
);


CREATE TABLE product (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    category_id INT REFERENCES product_category(id),
    cost BIGINT
);


CREATE TABLE client (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    office_address varchar(511),
    city varchar(63),
    phone varchar(31)
);

CREATE TABLE project_request (
    id SERIAL PRIMARY KEY,
    client_id INT NOT NULL REFERENCES client(id),
    title varchar(63),
    description TEXT,
    deadline DATE,
    offer BIGINT,
    accepted BOOLEAN
);

CREATE type project_status AS ENUM ('pending', 'inprogress', 'completed', 'paused');

CREATE TABLE project (
	id SERIAL PRIMARY KEY,
	title varchar(63),
	description TEXT,
	bugdet BIGINT,
	product_id INT NOT NULL REFERENCES product(id),
	deadline DATE,
	status project_status,
	client_id INT NOT NULL REFERENCES client(id)
);

CREATE TABLE project_team (
    employee_id INT,
    project_id INT,
    PRIMARY KEY (employee_id, project_id),
    FOREIGN KEY (employee_id) REFERENCES employee(id),
    FOREIGN KEY (project_id) REFERENCES project(id)
);

CREATE TABLE review (
	id SERIAL PRIMARY KEY,
	satisfaction_score SMALLINT,
	feedback TEXT,
	project_id INT NOT NULL REFERENCES project(id)
);

/* Records client revenue each year */
CREATE TABLE client_market_share (
	client_id INT REFERENCES client(id),
	"year" INT,
	revenue BIGINT,
	PRIMARY KEY (client_id, "year")
);

