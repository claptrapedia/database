-- migrate:up
CREATE SCHEMA catalogue;

-- migrate:down
DROP SCHEMA IF EXISTS catalogue;
