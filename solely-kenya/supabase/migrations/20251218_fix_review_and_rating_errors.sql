-- Ensure order_id exists in reviews
ALTER TABLE public.reviews 
ADD COLUMN IF NOT EXISTS order_id uuid REFERENCES public.orders(id) ON DELETE SET NULL;

-- Update REVIEWS Policies
DROP POLICY IF EXISTS "Users can create reviews for their completed orders" ON public.reviews;
DROP POLICY IF EXISTS "Authenticated users can create reviews" ON public.reviews;

CREATE POLICY "Users can create reviews for their orders" 
ON public.reviews 
FOR INSERT 
WITH CHECK (
  auth.uid() = user_id 
  AND (
    order_id IS NULL 
    OR EXISTS (
      SELECT 1 FROM public.orders o
      WHERE o.id = order_id
      AND o.customer_id = auth.uid()
      AND o.status IN ('arrived', 'delivered', 'completed')
    )
  )
);

-- Update VENDOR_RATINGS Policies
DROP POLICY IF EXISTS "Buyers can rate vendors they ordered from" ON public.vendor_ratings;

CREATE POLICY "Buyers can rate vendors they ordered from"
ON public.vendor_ratings
FOR INSERT
WITH CHECK (
  auth.uid() = buyer_id 
  AND EXISTS (
    SELECT 1 FROM public.orders
    WHERE orders.id = order_id
    AND orders.vendor_id = vendor_ratings.vendor_id
    AND orders.customer_id = auth.uid()
    AND orders.status IN ('arrived', 'delivered', 'completed')
  )
);
