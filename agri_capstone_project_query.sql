use agri_capstone;


-- Top 7 RICE PRODUCTION State
select sum(cd.production_1000_tons)as total_rice_production,s.state_name from crop_data cd
inner join states s
on cd.state_code = s.state_code
where cd.crop_id = 10
group by cd.state_code
order by total_rice_production desc
limit 7;

select * from states
order by  state_code;

-- Top 5 Wheat Producing States
select sum(cd.production_1000_tons)as total_wheat_production,s.state_name from crop_data cd
inner join states s
on cd.state_code = s.state_code
where cd.crop_id = 18
group by cd.state_code
order by total_wheat_production desc
limit 5;


-- Oil seed production by top 5 states
select sum(cd.production_1000_tons)as total_oil_seed_production,s.state_name from crop_data cd
inner join states s
on cd.state_code = s.state_code
where cd.crop_id = 13
group by cd.state_code
order by total_oil_seed_production desc
limit 5;


-- Top 7 SUNFLOWER PRODUCTION  State
select sum(cd.production_1000_tons)as total_sun_flower_production,s.state_name from crop_data cd
inner join states s
on cd.state_code = s.state_code
where cd.crop_id = 4
group by cd.state_code
order by total_sun_flower_production desc
limit 7;


-- India's SUGARCANE PRODUCTION From Last 50 Years(Line_plot)
SELECT production_year, 
       SUM(production_1000_tons) AS total_sugarcane_production
FROM crop_data
WHERE crop_id = 21
GROUP BY production_year;


-- Rice Production Vs Wheat Production (Last 50y)
-- Rice Production
SELECT production_year, 
       SUM(production_1000_tons) AS total_rice_production
FROM crop_data
WHERE crop_id = 10
GROUP BY production_year;

-- Wheat Production
SELECT production_year, 
       SUM(production_1000_tons) AS total_wheat_production
FROM crop_data
WHERE crop_id = 18
GROUP BY production_year;

-- Rice Production By West Bengal Districts
SELECT  dist_code,
       SUM(production_1000_tons) AS total_rice_production
FROM crop_data
WHERE crop_id = 10 and state_code = 13
GROUP BY dist_code;

-- Top 10 Wheat Production Years From UP
SELECT production_year, 
       SUM(production_1000_tons) AS total_wheat_production
FROM crop_data
WHERE crop_id = 18 and state_code = 12
GROUP BY production_year
order by total_wheat_production desc;

-- Millet Production (Last 50y)
SELECT production_year, 
       SUM(production_1000_tons) AS total_millet_production
FROM crop_data
WHERE crop_id = 17
GROUP BY production_year;

-- Sorghum Production (Kharif and Rabi) by Region
SELECT state_code, 
       SUM(production_1000_tons) AS total_sorghum_production
FROM crop_data
WHERE crop_id = 7 or crop_id = 16
GROUP BY state_code;

-- Top 7 States for Groundnut Production

SELECT state_code, 
       SUM(production_1000_tons) AS total_groundnut_production
FROM crop_data
WHERE crop_id = 5
GROUP BY state_code;


-- Soybean Production by Top 5 States and Yield Efficiency
SELECT state_code, 
       SUM(production_1000_tons) AS total_soyabean_production,
       round(avg(yield_kg_per_ha),2)as soyabean_yield
FROM crop_data
WHERE crop_id = 15
GROUP BY state_code
order by total_soyabean_production desc
limit 5;

-- Impact of Area Cultivated on Production (Rice, Wheat, Maize)
SELECT 
    c.state_code,
    c.crop_id,
    SUM(c.area_1000_ha) AS total_area_1000_ha,
    SUM(c.production_1000_tons) AS total_production_1000_tons
FROM crop_data c
WHERE c.crop_id IN (18, 10, 19)
GROUP BY c.state_code, c.crop_id
ORDER BY c.state_code, c.crop_id;

-- Rice vs. Wheat Yield Across States

SELECT 
    s.state_code,
    s.state_name,
    MAX(CASE WHEN c.crop_name = 'Rice' THEN cd.yield_kg_per_ha ELSE NULL END) AS rice_yield,
    MAX(CASE WHEN c.crop_name = 'Wheat' THEN cd.yield_kg_per_ha ELSE NULL END) AS wheat_yield
FROM crop_data cd
JOIN states s ON cd.state_code = s.state_code
JOIN crops c ON cd.crop_id = c.crop_id
WHERE c.crop_name IN ('Rice', 'Wheat')
GROUP BY s.state_code, s.state_name
ORDER BY s.state_name;
