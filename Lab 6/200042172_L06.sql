DROP TABLE propertyVisit;
DROP TABLE houseOwningInfo;
DROP TABLE owners;
DROP TABLE client;
DROP TABLE house;
DROP TABLE employee;
DROP TABLE branch;

CREATE TABLE branch
(
    branch_name VARCHAR(25) NOT NULL,
    street_name VARCHAR(25),
    city_name VARCHAR(25),
    postcode INT,
    CONSTRAINT pk_branch_name PRIMARY KEY(branch_name)
);

CREATE TABLE employee
(
    emp_id INT NOT NULL,
    first_name VARCHAR(25),
    last_name VARCHAR(25),
    gender VARCHAR(25),
    date_of_birth DATE,
    position VARCHAR(25),
    salary INT,
    branch_name VARCHAR(25) NOT NULL,
    CONSTRAINT pk_emp_id PRIMARY KEY(emp_id),
    CONSTRAINT fk_branch_name FOREIGN KEY(branch_name) REFERENCES branch(branch_name)
);

CREATE TABLE house
(
    house_id INT NOT NULL,
    street_name VARCHAR(25),
    city_name VARCHAR(25),
    postcode INT,
    type VARCHAR(25),
    num_of_rooms INT,
    rent NUMBER NOT NULL,
    CONSTRAINT pk_house_id_primary PRIMARY KEY(house_id)
);

CREATE TABLE client
(
    c_id INT NOT NULL,
    first_name VARCHAR(25),
    last_name VARCHAR(25),
    telephone_num NUMBER,
    email VARCHAR(25),
    accomodation_type VARCHAR(25),
    branch_name VARCHAR(25) NOT NULL,
    max_rent NUMBER NOT NULL,
    contact_person_id INT NOT NULL,
    house_id INT NOT NULL,
    CONSTRAINT pk_c_id PRIMARY KEY(c_id),
    CONSTRAINT fk_branch_name FOREIGN KEY(branch_name) REFERENCES branch(branch_name),
    CONSTRAINT fk_house_id FOREIGN KEY(house_id) REFERENCES house(house_id),
    CONSTRAINT fk_contact_person_id FOREIGN KEY(contact_person_id) REFERENCES employee(emp_id)
);

CREATE TABLE owners
(
    owner_id INT NOT NULL,
    first_name VARCHAR(25),
    last_name VARCHAR(25),
    telephone_num NUMBER,
    email VARCHAR(25),
    password VARCHAR(25),
    house_id INT NOT NULL,
    CONSTRAINT pk_owner_id PRIMARY KEY(owner_id),
    CONSTRAINT fk_house_id FOREIGN KEY(house_id) REFERENCES house(house_id)
);

CREATE TABLE houseOwningInfo
(
    house_id INT NOT NULL,
    owner_id INT NOT NULL,
    emp_id INT NOT NULL,
    CONSTRAINT pk_house_owning PRIMARY KEY(house_id, owner_id, emp_id),
    CONSTRAINT fk_house_id FOREIGN KEY(house_id) REFERENCES house(house_id),
    CONSTRAINT fk_owner_id FOREIGN KEY(owner_id) REFERENCES owners(owner_id),
    CONSTRAINT fk_emp_id FOREIGN KEY(emp_id) REFERENCES employee(emp_id)
);

CREATE TABLE propertyVisit
(
    house_id INT NOT NULL,
    date_of_visit DATE NOT NULL,
    comments VARCHAR(255),
    CONSTRAINT pk_property_visit PRIMARY KEY(house_id, date_of_visit),
    CONSTRAINT fk_house_id FOREIGN KEY(house_id) REFERENCES houseOwningInfo(house_id)
);
