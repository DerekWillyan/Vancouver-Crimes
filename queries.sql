-- Quantidade de Crimes ao Longo do Tempo (Diariamente)
-- Quantidade de crimes por dia

SELECT 
    DATE(DATECRIME) AS date,
    COUNT(*) AS crime_count
FROM (
    SELECT DATECRIME FROM VancouverCrimesWithoutPrivacy
    UNION ALL
    SELECT DATECRIME FROM VancouverCrimesPrivacy
) AS combined_crimes
GROUP BY DATE(DATECRIME)
ORDER BY date;
-- Tendências Sazonais (Por Mês)

SELECT 
    CASE 
        WHEN MONTH(DATE(DATECRIME)) = 1 THEN 'January'
        WHEN MONTH(DATE(DATECRIME)) = 2 THEN 'February'
        WHEN MONTH(DATE(DATECRIME)) = 3 THEN 'March'
        WHEN MONTH(DATE(DATECRIME)) = 4 THEN 'April'
        WHEN MONTH(DATE(DATECRIME)) = 5 THEN 'May'
        WHEN MONTH(DATE(DATECRIME)) = 6 THEN 'June'
        WHEN MONTH(DATE(DATECRIME)) = 7 THEN 'July'
        WHEN MONTH(DATE(DATECRIME)) = 8 THEN 'August'
        WHEN MONTH(DATE(DATECRIME)) = 9 THEN 'September'
        WHEN MONTH(DATE(DATECRIME)) = 10 THEN 'October'
        WHEN MONTH(DATE(DATECRIME)) = 11 THEN 'November'
        WHEN MONTH(DATE(DATECRIME)) = 12 THEN 'December'
    END AS month,
    COUNT(*) AS crime_count
FROM (
    SELECT DATECRIME FROM VancouverCrimesWithoutPrivacy
    UNION ALL
    SELECT DATECRIME FROM VancouverCrimesPrivacy
) AS combined_crimes
GROUP BY month
ORDER BY FIELD(month, 'January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December');

-- Distribuição Geográfica de Crimes (Usando apenas VancouverCrimesWithoutPrivacy)

SELECT 
    Latitude,
    Longitude,
    COUNT(*) AS crime_count
FROM VancouverCrimesWithoutPrivacy
GROUP BY Latitude, Longitude
ORDER BY crime_count DESC;

-- Padrões por Bairro

SELECT 
    NEIGHBOURHOOD,
    COUNT(*) AS crime_count
FROM (
    SELECT NEIGHBOURHOOD FROM VancouverCrimesWithoutPrivacy
    UNION ALL
    SELECT NEIGHBOURHOOD FROM VancouverCrimesPrivacy
) AS combined_crimes
GROUP BY NEIGHBOURHOOD
ORDER BY crime_count DESC;

-- Distribuição de Tipos de Crimes

SELECT 
    TYPE,
    COUNT(*) AS crime_count
FROM VancouverCrimesWithoutPrivacy
GROUP BY TYPE
ORDER BY crime_count DESC;

-- Comparação entre Tabelas (Frequência de Tipos de Crimes)

SELECT 
    TYPE,
    SUM(CASE WHEN source = 'Without Privacy' THEN crime_count ELSE 0 END) AS count_without_privacy,
    SUM(CASE WHEN source = 'With Privacy' THEN crime_count ELSE 0 END) AS count_with_privacy
FROM (
    SELECT 
        TYPE,
        COUNT(*) AS crime_count,
        'Without Privacy' AS source
    FROM VancouverCrimesWithoutPrivacy
    GROUP BY TYPE

    UNION ALL

    SELECT 
        TYPE,
        COUNT(*) AS crime_count,
        'With Privacy' AS source
    FROM VancouverCrimesPrivacy
    GROUP BY TYPE
) AS combined_crimes
GROUP BY TYPE
ORDER BY count_without_privacy DESC, count_with_privacy DESC;

