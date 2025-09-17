-- World Data

SELECT *
FROM city;

SELECT *
FROM country;

SELECT *
FROM countrylanguage;

SELECT country.code, country.Continent, country.Population
FROM country
LEFT JOIN city
ON country.code = city.CountryCode;

-- Spanish speaking
SELECT c.code, c.Continent, c.Name, cl.*, ci.Name, ci.Population
FROM country AS C
LEFT JOIN countrylanguage AS cl
	ON c.code = cl.CountryCode
LEFT JOIN city AS ci
	ON c.code = ci.CountryCode
WHERE cl.Language = 'Spanish' 
;

-- Top 20 populated City's (English or Spanish Spoken) where population is minimum 20,000
SELECT city.Name, city.Population, country.Name, country.Population, country.LifeExpectancy, CL.Language
FROM city
LEFT JOIN country
	ON city.CountryCode = country.code
LEFT JOIN countrylanguage AS CL 
	ON city.CountryCode = CL.CountryCode
WHERE city.Population > 20000 AND CL.Language = 'English' OR 'Spanish'
ORDER BY city.Population DESC
LIMIT 20;
    
    
-- Countries with highest population and their life Expectancy average city population
SELECT c.Name, AVG(c.Population) AS Average_pop, AVG(c.LifeExpectancy) AS Average_life_exp, AVG(ci.Population) AS Avg_city_pop
FROM country AS c
LEFT JOIN city AS ci
	ON c.Code = ci.CountryCode
GROUP BY c.Name
ORDER BY Average_pop DESC;    



