-- Migration: Add accessory_type column to products table
-- Run this when ready to deploy accessories feature
-- DO NOT run until all code changes are deployed

ALTER TABLE products 
ADD COLUMN accessory_type TEXT;

-- Add comment for documentation
COMMENT ON COLUMN products.accessory_type IS 'For products where category=accessories, stores the specific accessory type (suede_brush, polish, etc)';

-- Optional: Add check constraint to ensure accessory_type is set for accessories
-- Commented out for now - can be enabled later if needed
-- ALTER TABLE products
-- ADD CONSTRAINT check_accessory_type 
-- CHECK (
--   (category = 'accessories' AND accessory_type IS NOT NULL) OR
--   (category != 'accessories' AND accessory_type IS NULL)
-- );
