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


INSERT INTO department (name)
VALUES 
    ('HR'), 
    ('Finance'), 
    ('Operations'), 
    ('Hardware Solution'), 
    ('Software solution'), 
    ('Consultation');
   
-- inserting dummy data for employee
INSERT INTO employee ("name", department_id, "position", manager_id)
VALUES 
    ('John Doe', 1, 'Chief', NULL),  -- HR Department
    ('Alice Smith', 1, 'Associate', 1),
    ('Bob Johnson', 1, 'Mid-Level', 1),
    ('Emily Brown', 1, 'Intern', 2),
    ('Michael Clark', 1, 'Senior', 1),
    
    ('David Wilson', 2, 'Chief', NULL),  -- Finance Department
    ('Emma Garcia', 2, 'Associate', 6),
    ('James Martinez', 2, 'Mid-Level', 6),
    ('Olivia Rodriguez', 2, 'Intern', 7),
    ('William Lee', 2, 'Senior', 6),
    
    ('Sophia Taylor', 3, 'Chief', NULL),  -- Operations Department
    ('Daniel Anderson', 3, 'Associate', 11),
    ('Elizabeth Thomas', 3, 'Mid-Level', 11),
    ('Alexander Hernandez', 3, 'Intern', 12),
    ('Charlotte Moore', 3, 'Senior', 11),
    
    ('Liam Martin', 4, 'Chief', NULL),  -- Hardware Solution Department
    ('Amelia White', 4, 'Associate', 16),
    ('Henry Hall', 4, 'Mid-Level', 16),
    ('Mia Lopez', 4, 'Intern', 17),
    ('Ethan King', 4, 'Senior', 16),
    
    ('Oliver Harris', 5, 'Chief', NULL),  -- Software Solutions Department
    ('Ava Young', 5, 'Associate', 21),
    ('Lucas Green', 5, 'Mid-Level', 21),
    ('Isabella Baker', 5, 'Intern', 22),
    ('Lily Adams', 5, 'Senior', 21),
    
    ('Mason Rivera', 6, 'Chief', NULL),  -- Consultation Department
    ('Evelyn Hill', 6, 'Associate', 26),
    ('Logan Diaz', 6, 'Mid-Level', 26),
    ('Harper Campbell', 6, 'Intern', 27)
 ;


-- Inserting dummy data for clients
INSERT INTO client (name, office_address, city, phone)
VALUES 
    ('Client 1', '123 Main St', 'New York', '123-456-7890'),
    ('Client 2', '456 Elm St', 'Los Angeles', '987-654-3210'),
    ('Client 3', '789 Oak St', 'Chicago', '111-222-3333'),
    ('Client 4', '101 Pine St', 'Houston', '444-555-6666'),
    ('Client 5', '202 Maple St', 'Miami', '777-888-9999'),
    
    ('Client 6', '303 Cedar St', 'San Francisco', '222-333-4444'),
    ('Client 7', '404 Walnut St', 'Seattle', '555-666-7777'),
    ('Client 8', '505 Birch St', 'Miami', '888-999-0000'),
    ('Client 9', '606 Spruce St', 'Dallas', '333-444-5555'),
    ('Client 10', '707 Cherry St', 'Miami', '666-777-8888');
    
-- Inserting dummy data for project requests (by clients)
INSERT INTO project_request (client_id, title, description, deadline, offer, accepted)
VALUES 
    (1, 'Project 1', 'Description for Project 1', '2024-05-15', 5000, TRUE),
    (2, 'Project 2', 'Description for Project 2', '2024-05-20', 7000, TRUE),
    (3, 'Project 3', 'Description for Project 3', '2024-05-25', 6000, FALSE),
    (4, 'Project 4', 'Description for Project 4', '2024-05-30', 8000, TRUE),
    (5, 'Project 5', 'Description for Project 5', '2024-06-05', 5500, FALSE),
    
    (1, 'Project 6', 'Description for Project 6', '2024-06-10', 6500, FALSE),
    (2, 'Project 7', 'Description for Project 7', '2024-06-15', 9000, TRUE),
    (3, 'Project 8', 'Description for Project 8', '2024-06-20', 7500, TRUE),
    (4, 'Project 9', 'Description for Project 9', '2024-06-25', 8200, FALSE),
    (5, 'Project 10', 'Description for Project 10', '2024-06-30', 5800, TRUE),
    
    (1, 'Project 11', 'Description for Project 11', '2024-07-05', 5100, FALSE),
    (2, 'Project 12', 'Description for Project 12', '2024-07-10', 7200, TRUE),
    (3, 'Project 13', 'Description for Project 13', '2024-07-15', 6100, TRUE),
    (4, 'Project 14', 'Description for Project 14', '2024-07-20', 8300, FALSE),
    (5, 'Project 15', 'Description for Project 15', '2024-07-25', 5600, TRUE),
    
    (6, 'Project 16', 'Description for Project 16', '2024-08-01', 6700, FALSE),
    (7, 'Project 17', 'Description for Project 17', '2024-08-05', 9400, TRUE),
    (8, 'Project 18', 'Description for Project 18', '2024-08-10', 7600, TRUE),
    (9, 'Project 19', 'Description for Project 19', '2024-08-15', 8400, FALSE),
    (10, 'Project 20', 'Description for Project 20', '2024-08-20', 5900, TRUE);
   
-- Inserting dummy data for product_category
INSERT INTO product_category (name)
VALUES 
    ('Hardware'),
    ('Software'),
    ('Consultation');

-- Inserting dummy data for products
INSERT INTO product (name, category_id, cost)
VALUES 
    ('Product 1', 1, 100),  -- Hardware
    ('Product 2', 1, 150),
    ('Product 3', 1, 200),
    ('Product 4', 1, 120),
    ('Product 5', 1, 180),
    
    ('Product 6', 2, 80),   -- Software
    ('Product 7', 2, 120),
    ('Product 8', 2, 90),
    ('Product 9', 2, 100),
    ('Product 10', 2, 110),
    
    ('Product 11', 3, 200),  -- Consultation
    ('Product 12', 3, 250),
    ('Product 13', 3, 180),
    ('Product 14', 3, 220),
    ('Product 15', 3, 210),
    
    -- Repeat the products to make 30 rows
    ('Product 16', 1, 130),  -- Hardware
    ('Product 17', 1, 170),
    ('Product 18', 1, 140),
    ('Product 19', 1, 190),
    ('Product 20', 1, 160),
    
    ('Product 21', 2, 95),   -- Software
    ('Product 22', 2, 105),
    ('Product 23', 2, 85),
    ('Product 24', 2, 115),
    ('Product 25', 2, 125),
    
    ('Product 26', 3, 230),  -- Consultation
    ('Product 27', 3, 270),
    ('Product 28', 3, 200),
    ('Product 29', 3, 240),
    ('Product 30', 3, 220);


    
-- Inserting dummy data for projects
INSERT INTO project (title, description, bugdet, product_id, deadline, status, client_id)
VALUES 
    ('Website Redesign', 'Redesigning the company website to improve user experience and modernize its look.', 8000, 6, '2024-06-30', 'inprogress', 1),
    ('Inventory Management System', 'Developing a new inventory management system for better tracking of products.', 10000, 12, '2024-07-15', 'pending', 2),
    ('Mobile App Development', 'Creating a mobile application for easier access to our services.', 7000, 20, '2024-08-20', 'pending', 3),
    ('Data Analysis Tool', 'Building a tool to analyze large datasets and generate insights for decision-making.', 9000, 18, '2024-08-15', 'paused', 4),
    ('Marketing Campaign', 'Planning and executing a marketing campaign to promote our new product line.', 6000, 24, '2024-07-25', 'completed', 5),
    
    ('E-commerce Platform', 'Developing an e-commerce platform for selling our products online.', 8500, 7, '2024-07-10', 'inprogress', 1),
    ('Customer Feedback System', 'Implementing a system to collect and analyze customer feedback for continuous improvement.', 7500, 13, '2024-08-10', 'pending', 2),
    ('Supply Chain Optimization', 'Optimizing the supply chain process to reduce costs and improve efficiency.', 8200, 19, '2024-08-25', 'pending', 3),
    ('HR Management Software', 'Building a software solution for managing HR processes such as payroll and employee records.', 9500, 9, '2024-09-05', 'inprogress', 4),
    ('Social Media Campaign', 'Running a social media campaign to increase brand awareness and engagement.', 5800, 25, '2024-07-20', 'completed', 5),
    
    ('Data Security Enhancement', 'Enhancing data security measures to protect against cyber threats and breaches.', 7800, 8, '2024-07-10', 'paused', 1),
    ('Training Program Development', 'Developing a training program for employees to enhance their skills and knowledge.', 7200, 14, '2024-09-15', 'inprogress', 2),
    ('Logistics Optimization', 'Optimizing logistics operations to ensure timely delivery of products to customers.', 8400, 21, '2024-08-30', 'pending', 3),
    ('Financial Reporting System', 'Implementing a system for generating accurate and timely financial reports.', 8900, 10, '2024-08-05', 'inprogress', 4),
    ('Product Launch Event', 'Planning and organizing an event to launch our new product line.', 6200, 26, '2024-08-10', 'completed', 5),
    
    ('Market Research Study', 'Conducting a comprehensive market research study to identify new opportunities.', 8000, 11, '2024-07-15', 'paused', 1),
    ('Employee Engagement Initiative', 'Implementing initiatives to improve employee engagement and satisfaction.', 7700, 15, '2024-09-20', 'pending', 2),
    ('Quality Control System', 'Developing a quality control system to maintain product quality standards.', 8300, 22, '2024-08-25', 'pending', 3),
    ('Health and Safety Training', 'Providing training on health and safety protocols to ensure a safe work environment.', 9600, 16, '2024-09-10', 'inprogress', 4),
    ('Customer Appreciation Event', 'Organizing an event to show appreciation to our loyal customers.', 5900, 27, '2024-08-15', 'completed', 5),
    
    ('Website Localization', 'Localizing our website to target international markets and reach a wider audience.', 7900, 5, '2024-07-20', 'inprogress', 1),
    ('Employee Wellness Program', 'Implementing a wellness program to promote the health and well-being of employees.', 7300, 17, '2024-09-25', 'pending', 2),
    ('Product Packaging Redesign', 'Redesigning product packaging to enhance visual appeal and brand perception.', 8100, 23, '2024-08-30', 'pending', 3),
    ('IT Infrastructure Upgrade', 'Upgrading IT infrastructure to improve performance and security.', 9100, 28, '2024-09-05', 'inprogress', 4),
    ('Trade Show Exhibition', 'Participating in a trade show to showcase our products and services.', 6000, 29, '2024-08-10', 'completed', 5);

-- inserting dummy data for review
INSERT INTO review (satisfaction_score, feedback, project_id)
VALUES 
    (4, 'Great work by the team. The project was delivered on time and met all our requirements.', 5),
    (5, 'Excellent job! The team went above and beyond to ensure the success of the project.', 10),
    (3, 'Satisfactory work, but there were some minor issues that needed to be addressed.', 15),
    (4, 'Overall, we are happy with the outcome of the project. Good communication and collaboration.', 20),
    (5, 'Outstanding performance! The team exceeded our expectations and delivered exceptional results.', 25);
   
-- inserting dummy data for client_market_share
INSERT INTO client_market_share (client_id, "year", revenue) VALUES
    (1, 2020, 500000),
    (1, 2021, 550000),
    (1, 2022, 600000),
    (1, 2023, 620000),
    (1, 2024, 650000),
    
    (2, 2020, 450000),
    (2, 2021, 480000),
    (2, 2022, 510000),
    (2, 2023, 530000),
    (2, 2024, 550000),
    
    (3, 2020, 600000),
    (3, 2021, 650000),
    (3, 2022, 700000),
    (3, 2023, 720000),
    (3, 2024, 750000),
    
    (4, 2020, 700000),
    (4, 2021, 720000),
    (4, 2022, 750000),
    (4, 2023, 780000),
    (4, 2024, 800000),
    
    (5, 2020, 550000),
    (5, 2021, 580000),
    (5, 2022, 600000),
    (5, 2023, 620000),
    (5, 2024, 650000),
    
    (6, 2020, 500000),
    (6, 2021, 520000),
    (6, 2022, 550000),
    (6, 2023, 570000),
    (6, 2024, 600000),
    
    (7, 2020, 480000),
    (7, 2021, 500000),
    (7, 2022, 520000),
    (7, 2023, 540000),
    (7, 2024, 570000),
    
    (8, 2020, 550000),
    (8, 2021, 580000),
    (8, 2022, 600000),
    (8, 2023, 620000),
    (8, 2024, 650000),
    
    (9, 2020, 600000),
    (9, 2021, 630000),
    (9, 2022, 650000),
    (9, 2023, 680000),
    (9, 2024, 700000),
    
    (10, 2020, 700000),
    (10, 2021, 720000),
    (10, 2022, 750000),
    (10, 2023, 780000),
    (10, 2024, 800000);
   
-- mark project as completed if review is given with score greater than 4;
CREATE OR REPLACE FUNCTION update_project_status()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE project
    SET status = CASE
                    WHEN NEW.satisfaction_score >= 4 THEN 'completed'
                    ELSE status
                 END
    WHERE id = NEW.project_id;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_project_status_trigger
AFTER INSERT ON review
FOR EACH ROW
EXECUTE FUNCTION update_project_status();

-- testing the trigger on project.id = 9
INSERT INTO review (satisfaction_score, feedback, project_id)
VALUES 
    (5, 'Great work by the team. The project was delivered on time and met all our requirements.', 9);
   
