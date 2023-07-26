drop table central_system;
drop table division;
drop table accident;
drop table license;
drop table citizen;
drop table hospital;
drop table district;

create table district
(
    district_name varchar2(25) not null,
    district_size number,
    district_description varchar2(50),
    constraint pk_district_name primary key(district_name)
);

create table citizen
(
    nid number not null,
    citizen_name varchar2(50),
    date_of_birth date,
    occupation varchar2(25),
    blood_group varchar2(5),
    district_name varchar2(25),
    constraint pk_nid primary key(nid),
    constraint fk_district_name foreign key(district_name) 
    references district(district_name)
);

create table division
(
    division_name varchar2(25) not null,
    division_size number,
    division_description varchar2(50),
    district_name varchar2(25),
    constraint pk_division_name primary key(division_name),
    constraint fk_div_district_name foreign key(district_name) 
    references district(district_name)
);

create table license
(
    license_id number not null,
    license_type varchar2(25),
    issue_date date,
    expired_date date,
    nid number,
    constraint pk_license_id primary key(license_id),
    constraint fk_nid foreign key(nid) 
    references citizen(nid)
);

create table hospital
(
    hospital_id number not null,
    contact number,
    hospital_name varchar2(25),
    district_name varchar2(25),
    constraint pk_hospital_id primary key(hospital_id),
    constraint fk_hosp_district_name foreign key(district_name) 
    references district(district_name)
);

create table accident
(
    accident_id number not null,
    no_deaths number,
    place_of_accident varchar2(25),
    date_of_accident date,
    license_id number,
    constraint pk_accident_id primary key(accident_id),
    constraint fk_license_id foreign key(license_id) 
    references license(license_id)
);

create table central_system
(
    nid number not null,
    hospital_id number not null,
    accident_desc varchar2(50),
    date_of_admission date,
    release_date date,
    constraint pk_log primary key(hospital_id, nid),
    constraint fk_cs_nid foreign key(nid) 
    references citizen(nid),
    constraint fk_cs_hospital_id foreign key(hospital_id) 
    references hospital(hospital_id)
);
