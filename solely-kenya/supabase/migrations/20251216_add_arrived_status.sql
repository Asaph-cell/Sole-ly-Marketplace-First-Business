-- ================================================================
-- Add 'arrived' status to order_status enum
-- ================================================================
-- This migration adds the new 'arrived' status to support the updated
-- order timeline system where vendors mark orders as "arrived" instead
-- of "shipped" when the product reaches the buyer.
-- ================================================================

-- Step 1: Add 'arrived' to the order_status enum
ALTER TYPE order_status ADD VALUE IF NOT EXISTS 'arrived';

-- Step 2: Update existing shipped orders to arrived (if any)
-- Note: This may need to be run as a separate statement after the ALTER TYPE commits
-- UPDATE orders SET status = 'arrived' WHERE status = 'shipped';

-- ================================================================
-- Timeline System Update (December 2024)
-- ================================================================
-- Old flow: pending -> confirmed -> shipped -> delivered -> completed
-- New flow: pending -> confirmed -> arrived -> completed
-- 
-- 'arrived' means the vendor has marked the order as delivered to buyer
-- Buyer then has 24 hours to verify (delivery) or unlimited time (pickup)
-- ================================================================
