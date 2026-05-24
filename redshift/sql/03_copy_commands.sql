SET search_path TO import_basic;

-- Replace the S3 paths and IAM role before running.

COPY customers
FROM 's3://YOUR_BUCKET/study-import/customers.csv'
IAM_ROLE 'arn:aws:iam::123456789012:role/RedshiftCopyRole'
CSV
IGNOREHEADER 1;

COPY orders
FROM 's3://YOUR_BUCKET/study-import/orders.csv'
IAM_ROLE 'arn:aws:iam::123456789012:role/RedshiftCopyRole'
CSV
IGNOREHEADER 1;

COPY events
FROM 's3://YOUR_BUCKET/study-import/events.json'
IAM_ROLE 'arn:aws:iam::123456789012:role/RedshiftCopyRole'
FORMAT AS JSON 'auto';

COPY products
FROM 's3://YOUR_BUCKET/study-import/products.parquet'
IAM_ROLE 'arn:aws:iam::123456789012:role/RedshiftCopyRole'
FORMAT AS PARQUET;
