-- Answer the below questions through your analysis and visualizations:
-- 1.Year-wise Trend of Rice Production Across States (Top 3)

use agri_capstone;

select * from crop_data
limit 10;


select s.state_name,sum(cd.area_1000_ha)as total_area,sum(cd.production_1000_tons) as total_production
from crop_data cd
inner join states s
on s.state_code = cd.state_code
where cd.crop_id = 10
group by cd.state_code
order by total_production desc
limit 3;

-- Top 5 Districts by Wheat Yield Increase Over the Last 5 Years
with last_5y_cte as(
select distinct production_year from crop_data
order by production_year desc limit 5),

yield_increase_last_5 AS (
    SELECT cd.area_1000_ha,cd.yield_kg_per_ha,cd.state_code,cd.crop_id,last_5.production_year AS last_5_production_year
    FROM crop_data cd
    INNER JOIN last_5y_cte last_5
    ON last_5.production_year = cd.production_year
    WHERE cd.crop_id = 18
)

select s.state_name,sum(ly.area_1000_ha)as total_area,sum(ly.yield_kg_per_ha) as total_yield
from yield_increase_last_5 ly
inner join states s
on s.state_code = ly.state_code
where ly.crop_id = 18
group by ly.state_code
order by total_yield desc
limit 3;


-- States with the Highest Growth in Oilseed Production (5-Year Growth Rate)
with current_year_production as(
select state_code,sum(production_1000_tons) as total_production,production_year as final_production_year
from crop_data
where crop_id = 13 and (production_year = (select max(production_year) from crop_data where crop_id = 13))
group by state_code,production_year
),
last_year_production as(
select state_code,sum(production_1000_tons) as total_production,production_year as final_production_year
from crop_data
where crop_id = 13 and (production_year = (select (max(production_year)-5) from crop_data where crop_id = 13))
group by state_code,production_year
)

SELECT 
    c.state_code,
    s.state_name,
    c.total_production AS current_year_production, 
    l.total_production AS last_year_production,
    CASE
        WHEN l.total_production = 0 OR l.total_production IS NULL THEN 'N/A' 
        ELSE ROUND(((c.total_production - l.total_production) / l.total_production) * 100, 2) 
    END AS growth_rate
FROM current_year_production c
LEFT JOIN last_year_production l ON c.state_code = l.state_code
inner join states s on c.state_code = s.state_code;

-- Yearly Production Growth of Cotton in Top 5 Cotton Producing States
with top_5_cotton_production_state as(
select state_code,production_year,sum(production_1000_tons) as yearly_production
from crop_data
where crop_id = 12
group by state_code,production_year
)
select t5.state_code,s.state_name,sum(t5.yearly_production) as total_production from top_5_cotton_production_state t5
inner join states s on s.state_code = t5.state_code
group by t5.state_code
order by total_production desc limit 3;


-- Top 10 Districts with the Highest Groundnut Production in 2017

select s.state_name,d.dist_name,cd.dist_code,cd.production_1000_tons as yearly_production,cd.production_year from crop_data cd
inner join districts d on d.dist_code = cd.dist_code
inner join states s on s.state_code = cd.state_code
where cd.crop_id = 5 and cd.production_year = (select max(production_year) from crop_data c where c.crop_id = 5)
order by yearly_production desc limit 10;


-- Annual Average Maize Yield Across All States
select cd.state_code,s.state_name,round(avg(cd.yield_kg_per_ha),2)as average_maize_yield
from crop_data cd
inner join states s on s.state_code = cd.state_code
where cd.crop_id = 19
group by cd.state_code
order by average_maize_yield desc;

-- Total Area Cultivated for Oilseeds in Each State
select cd.state_code,s.state_name,sum(cd.area_1000_ha) as total_oil_seed_cultivated_area
from crop_data cd
inner join states s on s.state_code = cd.state_code
where cd.crop_id = 13
group by cd.state_code
order by total_oil_seed_cultivated_area desc;

-- top 10 Districts with the Highest Rice Yield
select cd.dist_code,d.dist_name,sum(cd.yield_kg_per_ha) as total_rice_yield
from crop_data cd
inner join districts d on d.dist_code = cd.dist_code
where cd.crop_id = 10
group by cd.dist_code
order by total_rice_yield desc
limit 10;


-- 10.Compare the Production of Wheat and Rice for the Top 5 States Over 10 Years
with top5_rice_production as(
select cd.state_code,s.state_name,sum(cd.production_1000_tons) as total_rice_production
from crop_data cd
inner join states s on s.state_code = cd.state_code
where cd.crop_id = 10
group by cd.state_code
order by total_rice_production desc
limit 5
),
top5_wheat_production as(
select cd.state_code,s.state_name,sum(cd.production_1000_tons) as total_wheat_production
from crop_data cd
inner join states s on s.state_code = cd.state_code
where cd.crop_id = 18
group by cd.state_code
order by total_wheat_production desc
limit 5
)

-- select * from top5_rice_production;
select * from top5_wheat_production;
