use Project;

CREATE TABLE New_Vehicle_Data (
    Engine_rpm INT,
    Lub_oil_pressure FLOAT,
    Fuel_pressure FLOAT,
    Coolant_pressure FLOAT,
    lub_oil_temp FLOAT,
    Coolant_temp FLOAT,
    Engine_Condition INT
);

show variables like 'secure_file_priv';
show variables like '%local%';
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Engine_Condition Prediction.csv' 
INTO TABLE New_Vehicle_Data 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS;

select * from New_Vehicle_Data;

set sql_safe_updates = 0;

-- Update 'Engine Condition' column based on specified conditions and rename the column
    
ALTER TABLE New_Vehicle_Data MODIFY COLUMN Engine_Condition VARCHAR(50);    
UPDATE New_Vehicle_Data 
SET Engine_Condition = 
    CASE 
        WHEN Engine_Condition = 0 THEN 'No Breakdown'
        ELSE 'Breakdown'
    END;
    
ALTER TABLE New_Vehicle_Data RENAME COLUMN Engine_Condition to Vehicle_condition;   
    
--   Perform exploratory data analysis 
-- Querying counts of `Breakdown / NoBreakdown`

SELECT Vehicle_condition, COUNT(*) AS count
FROM New_Vehicle_Data
GROUP BY Vehicle_condition;

-- ( 1ST Moment Business Decision )
# Measure Of Central Tendency 

-- MEAN Calculation -- FOR INPUT FEATURES

SELECT 
    AVG(Engine_rpm) AS mean_rpm,
    AVG(Lub_oil_pressure) AS mean_lub_oil_pressure,
    AVG(Fuel_pressure) AS mean_fuel_pressure,
    AVG(Coolant_pressure) AS mean_coolant_pressure,
    AVG(lub_oil_temp) AS mean_lub_oil_temp,
    AVG(Coolant_temp) AS mean_coolant_temp
FROM New_Vehicle_Data;


-- MODE CALCULATION FOR INPUT VARIABLES


SELECT 'Engine_rpm' AS column_name, mode_engine_rpm AS mode_value FROM (
    SELECT Engine_rpm AS mode_engine_rpm, COUNT(*) AS frequency
    FROM New_Vehicle_Data
    GROUP BY Engine_rpm
    ORDER BY frequency DESC
    LIMIT 1
) AS engine_rpm_mode
UNION ALL
SELECT 'Lub_oil_pressure' AS column_name, mode_lub_oil_pressure AS mode_value FROM (
    SELECT Lub_oil_pressure AS mode_lub_oil_pressure, COUNT(*) AS frequency
    FROM New_Vehicle_Data
    GROUP BY Lub_oil_pressure
    ORDER BY frequency DESC
    LIMIT 1
) AS lub_oil_pressure_mode
UNION ALL
SELECT 'Fuel_pressure' AS column_name, mode_fuel_pressure AS mode_value FROM (
    SELECT Fuel_pressure AS mode_fuel_pressure, COUNT(*) AS frequency
    FROM New_Vehicle_Data
    GROUP BY Fuel_pressure
    ORDER BY frequency DESC
    LIMIT 1
) AS fuel_pressure_mode
UNION ALL
SELECT 'Coolant_pressure' AS column_name, mode_coolant_pressure AS mode_value FROM (
    SELECT Coolant_pressure AS mode_coolant_pressure, COUNT(*) AS frequency
    FROM New_Vehicle_Data
    GROUP BY Coolant_pressure
    ORDER BY frequency DESC
    LIMIT 1
) AS coolant_pressure_mode
UNION ALL
SELECT 'lub_oil_temp' AS column_name, mode_lub_oil_temp AS mode_value FROM (
    SELECT lub_oil_temp AS mode_lub_oil_temp, COUNT(*) AS frequency
    FROM New_Vehicle_Data
    GROUP BY lub_oil_temp
    ORDER BY frequency DESC
    LIMIT 1
) AS lub_oil_temp_mode
UNION ALL
SELECT 'Coolant_temp' AS column_name, mode_coolant_temp AS mode_value FROM (
    SELECT Coolant_temp AS mode_coolant_temp, COUNT(*) AS frequency
    FROM New_Vehicle_Data
    GROUP BY Coolant_temp
    ORDER BY frequency DESC
    LIMIT 1
) AS coolant_temp_mode;


--  MEDIAN CALCULATION


(
SELECT 'Engine_rpm' AS column_name, Engine_rpm AS median
FROM (
    SELECT Engine_rpm, ROW_NUMBER() OVER (ORDER BY Engine_rpm) AS row_num,
           COUNT(*) OVER () AS total_count
    FROM New_Vehicle_Data
) AS subquery
WHERE row_num = (total_count + 1) / 2 OR row_num = (total_count + 2) / 2
)
UNION ALL
(
SELECT 'Lub_oil_pressure' AS column_name, Lub_oil_pressure AS median
FROM (
    SELECT Lub_oil_pressure, ROW_NUMBER() OVER (ORDER BY Lub_oil_pressure) AS row_num,
           COUNT(*) OVER () AS total_count
    FROM New_Vehicle_Data
) AS subquery
WHERE row_num = (total_count + 1) / 2 OR row_num = (total_count + 2) / 2
)
UNION ALL
(
SELECT 'Fuel_pressure' AS column_name, Fuel_pressure AS median
FROM (
    SELECT Fuel_pressure, ROW_NUMBER() OVER (ORDER BY Fuel_pressure) AS row_num,
           COUNT(*) OVER () AS total_count
    FROM New_Vehicle_Data
) AS subquery
WHERE row_num = (total_count + 1) / 2 OR row_num = (total_count + 2) / 2
)
UNION ALL
(
SELECT 'Coolant_pressure' AS column_name, Coolant_pressure AS median
FROM (
    SELECT Coolant_pressure, ROW_NUMBER() OVER (ORDER BY Coolant_pressure) AS row_num,
           COUNT(*) OVER () AS total_count
    FROM New_Vehicle_Data
) AS subquery
WHERE row_num = (total_count + 1) / 2 OR row_num = (total_count + 2) / 2
)
UNION ALL
(
SELECT 'lub_oil_temp' AS column_name, lub_oil_temp AS median
FROM (
    SELECT lub_oil_temp, ROW_NUMBER() OVER (ORDER BY lub_oil_temp) AS row_num,
           COUNT(*) OVER () AS total_count
    FROM New_Vehicle_Data
) AS subquery
WHERE row_num = (total_count + 1) / 2 OR row_num = (total_count + 2) / 2
)
UNION ALL
(
SELECT 'Coolant_temp' AS column_name, Coolant_temp AS median
FROM (
    SELECT Coolant_temp, ROW_NUMBER() OVER (ORDER BY Coolant_temp) AS row_num,
           COUNT(*) OVER () AS total_count
    FROM New_Vehicle_Data
) AS subquery
WHERE row_num = (total_count + 1) / 2 OR row_num = (total_count + 2) / 2
);

# Second Moment Business Decision/Measures of Dispersion

# Variance

SELECT 
    VARIANCE(Engine_rpm) AS rpm_variance,
    VARIANCE(Lub_oil_pressure) AS lub_oil_pressure_variance,
    VARIANCE(Fuel_pressure) AS fuel_pressure_variance,
    VARIANCE(Coolant_pressure) AS coolant_pressure_variance,
    VARIANCE(lub_oil_temp) AS lub_oil_temp_variance,
    VARIANCE(Coolant_temp) AS coolant_temp_variance
FROM New_Vehicle_Data;

#        Standard Deviation

SELECT 
    STDDEV(Engine_rpm) AS rpm_stddev,
    STDDEV(Lub_oil_pressure) AS lub_oil_pressure_stddev,
    STDDEV(Fuel_pressure) AS fuel_pressure_stddev,
    STDDEV(Coolant_pressure) AS coolant_pressure_stddev,
    STDDEV(lub_oil_temp) AS lub_oil_temp_stddev,
    STDDEV(Coolant_temp) AS coolant_temp_stddev
FROM New_Vehicle_Data;

#  RANGE CALCULATIONS

SELECT 
    MAX(Engine_rpm) - MIN(Engine_rpm) AS rpm_range,
    MAX(Lub_oil_pressure) - MIN(Lub_oil_pressure) AS lub_oil_pressure_range,
    MAX(Fuel_pressure) - MIN(Fuel_pressure) AS fuel_pressure_range,
    MAX(Coolant_pressure) - MIN(Coolant_pressure) AS coolant_pressure_range,
    MAX(lub_oil_temp) - MIN(lub_oil_temp) AS lub_oil_temp_range,
    MAX(Coolant_temp) - MIN(Coolant_temp) AS coolant_temp_range
FROM New_Vehicle_Data;

# Third and Fourth Moment Business Decision

# skewness and kurtosis

SELECT 'Engine_rpm' AS column_name,
       (
           SUM(POWER(Engine_rpm - (SELECT AVG(Engine_rpm) FROM New_Vehicle_Data), 3)) / 
           (COUNT(*) * POWER((SELECT STDDEV(Engine_rpm) FROM New_Vehicle_Data), 3))
       ) AS skewness,
       (
           (SUM(POWER(Engine_rpm - (SELECT AVG(Engine_rpm) FROM New_Vehicle_Data), 4)) / 
           (COUNT(*) * POWER((SELECT STDDEV(Engine_rpm) FROM New_Vehicle_Data), 4))) - 3
       ) AS kurtosis
FROM New_Vehicle_Data
UNION ALL
SELECT 'Lub_oil_pressure' AS column_name,
       (
           SUM(POWER(Lub_oil_pressure - (SELECT AVG(Lub_oil_pressure) FROM New_Vehicle_Data), 3)) / 
           (COUNT(*) * POWER((SELECT STDDEV(Lub_oil_pressure) FROM New_Vehicle_Data), 3))
       ) AS skewness,
       (
           (SUM(POWER(Lub_oil_pressure - (SELECT AVG(Lub_oil_pressure) FROM New_Vehicle_Data), 4)) / 
           (COUNT(*) * POWER((SELECT STDDEV(Lub_oil_pressure) FROM New_Vehicle_Data), 4))) - 3
       ) AS kurtosis
FROM New_Vehicle_Data
UNION ALL
SELECT 'Fuel_pressure' AS column_name,
       (
           SUM(POWER(Fuel_pressure - (SELECT AVG(Fuel_pressure) FROM New_Vehicle_Data), 3)) / 
           (COUNT(*) * POWER((SELECT STDDEV(Fuel_pressure) FROM New_Vehicle_Data), 3))
       ) AS skewness,
       (
           (SUM(POWER(Fuel_pressure - (SELECT AVG(Fuel_pressure) FROM New_Vehicle_Data), 4)) / 
           (COUNT(*) * POWER((SELECT STDDEV(Fuel_pressure) FROM New_Vehicle_Data), 4))) - 3
       ) AS kurtosis
FROM New_Vehicle_Data
UNION ALL
SELECT 'Coolant_pressure' AS column_name,
       (
           SUM(POWER(Coolant_pressure - (SELECT AVG(Coolant_pressure) FROM New_Vehicle_Data), 3)) / 
           (COUNT(*) * POWER((SELECT STDDEV(Coolant_pressure) FROM New_Vehicle_Data), 3))
       ) AS skewness,
       (
           (SUM(POWER(Coolant_pressure - (SELECT AVG(Coolant_pressure) FROM New_Vehicle_Data), 4)) / 
           (COUNT(*) * POWER((SELECT STDDEV(Coolant_pressure) FROM New_Vehicle_Data), 4))) - 3
       ) AS kurtosis
FROM New_Vehicle_Data
UNION ALL
SELECT 'lub_oil_temp' AS column_name,
       (
           SUM(POWER(lub_oil_temp - (SELECT AVG(lub_oil_temp) FROM New_Vehicle_Data), 3)) / 
           (COUNT(*) * POWER((SELECT STDDEV(lub_oil_temp) FROM New_Vehicle_Data), 3))
       ) AS skewness,
       (
           (SUM(POWER(lub_oil_temp - (SELECT AVG(lub_oil_temp) FROM New_Vehicle_Data), 4)) / 
           (COUNT(*) * POWER((SELECT STDDEV(lub_oil_temp) FROM New_Vehicle_Data), 4))) - 3
       ) AS kurtosis
FROM New_Vehicle_Data
UNION ALL
SELECT 'Coolant_temp' AS column_name,
       (
           SUM(POWER(Coolant_temp - (SELECT AVG(Coolant_temp) FROM New_Vehicle_Data), 3)) / 
           (COUNT(*) * POWER((SELECT STDDEV(Coolant_temp) FROM New_Vehicle_Data), 3))
       ) AS skewness,
       (
           (SUM(POWER(Coolant_temp - (SELECT AVG(Coolant_temp) FROM New_Vehicle_Data), 4)) / 
           (COUNT(*) * POWER((SELECT STDDEV(Coolant_temp) FROM New_Vehicle_Data), 4))) - 3
       ) AS kurtosis
FROM New_Vehicle_Data;

-- find is there any duplicates 

SELECT 
    Engine_rpm, Lub_oil_pressure, Fuel_pressure, Coolant_pressure, lub_oil_temp, Coolant_temp, COUNT(*) AS duplicates_count
FROM 
    New_Vehicle_Data
GROUP BY 
    Engine_rpm, Lub_oil_pressure, Fuel_pressure, Coolant_pressure, lub_oil_temp, Coolant_temp
HAVING 
    COUNT(*) > 1;
    
    
-- FIND IS THERE ANY MISSING VALUES

SELECT 
    SUM(CASE WHEN Engine_rpm IS NULL THEN 1 ELSE 0 END) AS rpm_missing_count,
    SUM(CASE WHEN Lub_oil_pressure IS NULL THEN 1 ELSE 0 END) AS lub_oil_pressure_missing_count,
    SUM(CASE WHEN Fuel_pressure IS NULL THEN 1 ELSE 0 END) AS fuel_pressure_missing_count,
    SUM(CASE WHEN Coolant_pressure IS NULL THEN 1 ELSE 0 END) AS coolant_pressure_missing_count,
    SUM(CASE WHEN lub_oil_temp IS NULL THEN 1 ELSE 0 END) AS lub_oil_temp_missing_count,
    SUM(CASE WHEN Coolant_temp IS NULL THEN 1 ELSE 0 END) AS coolant_temp_missing_count
FROM 
    New_Vehicle_Data;
    
    
--     check whether there are any outliers present or not 

SELECT 
    column_name,
    MAX(outliers_present) AS "Outliers Present / Not",
    GROUP_CONCAT(DISTINCT outliers_value ORDER BY outliers_value) AS outliers_values
FROM (
    SELECT 
        'Engine_rpm' AS column_name,
        CASE 
            WHEN ABS((Engine_rpm - avg_Engine_rpm) / std_dev_Engine_rpm) > 3 THEN 'Outlier'
            ELSE 'Not Outlier'
        END AS outliers_present,
        CASE 
            WHEN ABS((Engine_rpm - avg_Engine_rpm) / std_dev_Engine_rpm) > 3 THEN ROUND(Engine_rpm, 1)
            ELSE NULL
        END AS outliers_value
    FROM 
        (SELECT 
            AVG(Engine_rpm) AS avg_Engine_rpm,
            STDDEV(Engine_rpm) AS std_dev_Engine_rpm
        FROM 
            New_Vehicle_Data) AS stats,
        New_Vehicle_Data

    UNION ALL

    SELECT 
        'Lub_oil_pressure' AS column_name,
        CASE 
            WHEN ABS((Lub_oil_pressure - avg_Lub_oil_pressure) / std_dev_Lub_oil_pressure) > 3 THEN 'Outlier'
            ELSE 'Not Outlier'
        END AS outliers_present,
        CASE 
            WHEN ABS((Lub_oil_pressure - avg_Lub_oil_pressure) / std_dev_Lub_oil_pressure) > 3 THEN ROUND(Lub_oil_pressure, 1)
            ELSE NULL
        END AS outliers_value
    FROM 
        (SELECT 
            AVG(Lub_oil_pressure) AS avg_Lub_oil_pressure,
            STDDEV(Lub_oil_pressure) AS std_dev_Lub_oil_pressure
        FROM 
            New_Vehicle_Data) AS stats,
        New_Vehicle_Data

    UNION ALL

    SELECT 
        'Fuel_pressure' AS column_name,
        CASE 
            WHEN ABS((Fuel_pressure - avg_Fuel_pressure) / std_dev_Fuel_pressure) > 3 THEN 'Outlier'
            ELSE 'Not Outlier'
        END AS outliers_present,
        CASE 
            WHEN ABS((Fuel_pressure - avg_Fuel_pressure) / std_dev_Fuel_pressure) > 3 THEN ROUND(Fuel_pressure, 1)
            ELSE NULL
        END AS outliers_value
    FROM 
        (SELECT 
            AVG(Fuel_pressure) AS avg_Fuel_pressure,
            STDDEV(Fuel_pressure) AS std_dev_Fuel_pressure
        FROM 
            New_Vehicle_Data) AS stats,
        New_Vehicle_Data

    UNION ALL

    SELECT 
        'Coolant_pressure' AS column_name,
        CASE 
            WHEN ABS((Coolant_pressure - avg_Coolant_pressure) / std_dev_Coolant_pressure) > 3 THEN 'Outlier'
            ELSE 'Not Outlier'
        END AS outliers_present,
        CASE 
            WHEN ABS((Coolant_pressure - avg_Coolant_pressure) / std_dev_Coolant_pressure) > 3 THEN ROUND(Coolant_pressure, 1)
            ELSE NULL
        END AS outliers_value
    FROM 
        (SELECT 
            AVG(Coolant_pressure) AS avg_Coolant_pressure,
            STDDEV(Coolant_pressure) AS std_dev_Coolant_pressure
        FROM 
            New_Vehicle_Data) AS stats,
        New_Vehicle_Data

    UNION ALL

    SELECT 
        'lub_oil_temp' AS column_name,
        CASE 
            WHEN ABS((lub_oil_temp - avg_lub_oil_temp) / std_dev_lub_oil_temp) > 3 THEN 'Outlier'
            ELSE 'Not Outlier'
        END AS outliers_present,
        CASE 
            WHEN ABS((lub_oil_temp - avg_lub_oil_temp) / std_dev_lub_oil_temp) > 3 THEN ROUND(lub_oil_temp, 1)
            ELSE NULL
        END AS outliers_value
    FROM 
        (SELECT 
            AVG(lub_oil_temp) AS avg_lub_oil_temp,
            STDDEV(lub_oil_temp) AS std_dev_lub_oil_temp
        FROM 
            New_Vehicle_Data) AS stats,
        New_Vehicle_Data

    UNION ALL

    SELECT 
        'Coolant_temp' AS column_name,
        CASE 
            WHEN ABS((Coolant_temp - avg_Coolant_temp) / std_dev_Coolant_temp) > 3 THEN 'Outlier'
            ELSE 'Not Outlier'
        END AS outliers_present,
        CASE 
            WHEN ABS((Coolant_temp - avg_Coolant_temp) / std_dev_Coolant_temp) > 3 THEN ROUND(Coolant_temp, 1)
            ELSE NULL
        END AS outliers_value
    FROM 
        (SELECT 
            AVG(Coolant_temp) AS avg_Coolant_temp,
            STDDEV(Coolant_temp) AS std_dev_Coolant_temp
        FROM 
            New_Vehicle_Data) AS stats,
        New_Vehicle_Data
) AS outliers_summary
GROUP BY column_name;


select * from New_Vehicle_Data;

 --                             END OF EDA PART                                  --
   


