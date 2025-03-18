create database agri_capstone;
use agri_capstone;


-- Stores state-level information.
CREATE TABLE states (
    state_code INT PRIMARY KEY,
    state_name VARCHAR(255) NOT NULL
);

-- Stores district-level information, linked to states.
CREATE TABLE districts (
    dist_code INT PRIMARY KEY,
    dist_name VARCHAR(255) NOT NULL,states
    state_code INT NOT NULL,
    FOREIGN KEY (state_code) REFERENCES states(state_code)
);

-- Stores crop types
CREATE TABLE crops (
    crop_id INT PRIMARY KEY AUTO_INCREMENT,
    crop_name VARCHAR(255) NOT NULL UNIQUE
);

-- Stores yearly crop metrics at the district level (with a unique row ID)
drop table crop_data;
CREATE TABLE crop_data (
    crop_data_id INT PRIMARY KEY AUTO_INCREMENT,  -- Unique row identifier
    dist_code INT NOT NULL,
    state_code INT NOT NULL,
    production_year INT NOT NULL,
    crop_id INT NOT NULL,
    area_1000_ha DECIMAL(10,2) NOT NULL,
    production_1000_tons DECIMAL(10,2) NOT NULL,
    yield_kg_per_ha DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (dist_code) REFERENCES districts(dist_code),
    FOREIGN KEY (state_code) REFERENCES states(state_code),
    FOREIGN KEY (crop_id) REFERENCES crops(crop_id),
    UNIQUE (dist_code, year, crop_id)  -- Ensures no duplicate entries for the same crop in the same district-year
);

ALTER TABLE crop_data 
RENAME COLUMN `year` TO `production_year`;


select count(*) from crop_data;
#delete empty rows
SET SQL_SAFE_UPDATES = 0;
DELETE FROM agri_capstone.crop_data
WHERE area_1000_ha = 0 
  AND production_1000_tons = 0 
  AND yield_kg_per_ha = 0;
  

