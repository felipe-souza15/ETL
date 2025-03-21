-- Filter valid customers based on business rules
WITH ValidCustomers AS (
    SELECT c.customerCode
    FROM Customer c
    JOIN Franchise f ON c.franchiseCode = f.franchiseCode
    WHERE c.customerStatus = 'S'  -- Only active customers
      AND c.customerTypeCode <> '13'  -- Exclude SH and pre-registration
      AND f.masterFranchiseCode IN ('850','675','375','B94')  -- Only direct channel franchises
      AND f.franchiseGroup NOT IN ('996')  -- Exclude demo codes
      AND c.customerCode NOT IN (
          SELECT customerCode 
          FROM [FATURAMENTO].[dbo].[BillingSuspendedCustomers] 
          WHERE cancellationDate IS NULL  -- Exclude customers with active billing suspension
      )
      AND c.customerCode NOT IN (
          SELECT DISTINCT customerId 
          FROM DelinquentCustomers 
          WHERE invoiceReference <> '202502'  -- Exclude delinquent customers (except current month)
      )
),

-- Select customers with no Serasa Alert transactions (codes 00194, 30659, 30704, 30707)
CustomersWithoutSerasaAlert AS (
    SELECT t.customerCode
    FROM faturamento..Transactions_202502 t
    JOIN ValidCustomers vc ON t.customerCode = vc.customerCode
    GROUP BY t.customerCode
    HAVING COUNT(CASE WHEN t.serviceCode + t.serviceDetailCode IN ('00194','30659','30704','30707') THEN 1 END) = 0
),

-- Identify whether the customer has the MeProteja service (00180)
MeProtejaByCustomer AS (
    SELECT 
        t.customerCode,
        MAX(CASE WHEN t.serviceCode + t.serviceDetailCode = '00180' THEN 'YES' ELSE 'NO' END) AS HasMeProteja
    FROM faturamento..Transactions_202502 t
    JOIN CustomersWithoutSerasaAlert c ON t.customerCode = c.customerCode
    GROUP BY t.customerCode
),

-- Identify whether the customer uses only the minimum package (VCM: 00118 and 00186)
MinimumPackageByCustomer AS (
    SELECT 
        t.customerCode,
        CASE 
            WHEN COUNT(DISTINCT CASE WHEN t.serviceCode + t.serviceDetailCode NOT IN ('00118', '00186') THEN t.serviceCode + t.serviceDetailCode END) = 0 
            THEN 'YES' ELSE 'NO'
        END AS UsesOnlyMinimumPackage
    FROM faturamento..Transactions_202502 t
    JOIN MeProtejaByCustomer mp ON t.customerCode = mp.customerCode
    GROUP BY t.customerCode
)

-- Final output: valid customers without Serasa Alert, with MeProteja and VCM flags
SELECT 
    c.customerCode,
    mp.HasMeProteja,
    mpkg.UsesOnlyMinimumPackage
FROM CustomersWithoutSerasaAlert c
LEFT JOIN MeProtejaByCustomer mp ON c.customerCode = mp.customerCode
LEFT JOIN MinimumPackageByCustomer mpkg ON c.customerCode = mpkg.customerCode
ORDER BY c.customerCode;
