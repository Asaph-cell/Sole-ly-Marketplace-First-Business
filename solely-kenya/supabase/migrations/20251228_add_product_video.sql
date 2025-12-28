-- Add video_url column to products table for optional product videos
-- This migration is backward-compatible (nullable column)

ALTER TABLE public.products
ADD COLUMN IF NOT EXISTS video_url TEXT DEFAULT NULL;

-- Add comment for documentation
COMMENT ON COLUMN public.products.video_url IS 'Optional product video URL (4-12s duration, max 15MB)';
