-- This query filters bank institutions that are established within the last 20 years and selects the FDIC number, name, total assets, branch name, branch address, branch city, and zip code.
WITH
    ActiveBanks AS (
        -- Calculates the date 20 years ago from the current date and filters the banks whose established date is more recent.
        SELECT
            i.fdic_certificate_number,
            i.institution_name,
            i.total_assets,
            i.established_date,
            l.branch_name,
            l.branch_address,
            l.branch_city,
            l.zip_code
        FROM
            `bigquery-public-data.fdic_banks.institutions` AS i
            JOIN `bigquery-public-data.fdic_banks.locations` AS l ON i.fdic_certificate_number = l.branch_fdic_uninum
        WHERE
            i.active = TRUE
            AND i.established_date >= DATE_SUB (CURRENT_DATE(), INTERVAL 20 YEAR)
    )
    -- The main SELECT statement selects the banks' FDIC number, assets, address, and branch data from the CTE.
SELECT
    fdic_certificate_number,
    institution_name,
    total_assets,
    branch_name,
    branch_address,
    branch_city,
    zip_code
FROM
    ActiveBanks
ORDER BY
    total_assets DESC;