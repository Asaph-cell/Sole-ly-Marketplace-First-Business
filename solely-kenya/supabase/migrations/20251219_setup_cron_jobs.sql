-- Enable pg_cron extension (required for scheduled jobs)
CREATE EXTENSION IF NOT EXISTS pg_cron;
CREATE EXTENSION IF NOT EXISTS pg_net;

-- Grant usage to postgres user
GRANT USAGE ON SCHEMA cron TO postgres;

-- =============================================
-- CRON JOB: Auto-Cancel Stale Orders
-- Runs every hour to cancel orders not confirmed by vendor within 48 hours
-- =============================================
DO $$ BEGIN
  PERFORM cron.unschedule('auto-cancel-stale-orders');
EXCEPTION WHEN OTHERS THEN NULL;
END $$;

SELECT cron.schedule(
  'auto-cancel-stale-orders',
  '0 * * * *',
  $$
  SELECT net.http_post(
    url := 'https://cqcklvdblhcdowisjnsf.supabase.co/functions/v1/auto-cancel-stale-orders',
    headers := '{"Content-Type": "application/json", "Authorization": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNxY2tsdmRibGhjZG93aXNqbnNmIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc2MTc2NzQwMywiZXhwIjoyMDc3MzQzNDAzfQ.t5tp0h-OrF3o6r7kClRkkPGPKL4a-g90W_0V70A8OZw"}'::jsonb,
    body := '{}'::jsonb
  );
  $$
);

-- =============================================
-- CRON JOB: Auto-Release Escrow
-- =============================================
DO $$ BEGIN
  PERFORM cron.unschedule('auto-release-escrow');
EXCEPTION WHEN OTHERS THEN NULL;
END $$;

SELECT cron.schedule(
  'auto-release-escrow',
  '30 * * * *',
  $$
  SELECT net.http_post(
    url := 'https://cqcklvdblhcdowisjnsf.supabase.co/functions/v1/auto-release-escrow',
    headers := '{"Content-Type": "application/json", "Authorization": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNxY2tsdmRibGhjZG93aXNqbnNmIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc2MTc2NzQwMywiZXhwIjoyMDc3MzQzNDAzfQ.t5tp0h-OrF3o6r7kClRkkPGPKL4a-g90W_0V70A8OZw"}'::jsonb,
    body := '{}'::jsonb
  );
  $$
);

-- =============================================
-- CRON JOB: Auto-Refund Unshipped Orders
-- =============================================
DO $$ BEGIN
  PERFORM cron.unschedule('auto-refund-unshipped');
EXCEPTION WHEN OTHERS THEN NULL;
END $$;

SELECT cron.schedule(
  'auto-refund-unshipped',
  '0 */6 * * *',
  $$
  SELECT net.http_post(
    url := 'https://cqcklvdblhcdowisjnsf.supabase.co/functions/v1/auto-refund-unshipped',
    headers := '{"Content-Type": "application/json", "Authorization": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNxY2tsdmRibGhjZG93aXNqbnNmIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc2MTc2NzQwMywiZXhwIjoyMDc3MzQzNDAzfQ.t5tp0h-OrF3o6r7kClRkkPGPKL4a-g90W_0V70A8OZw"}'::jsonb,
    body := '{}'::jsonb
  );
  $$
);

-- =============================================
-- CRON JOB: Check Payment Status
-- =============================================
DO $$ BEGIN
  PERFORM cron.unschedule('check-payment-status');
EXCEPTION WHEN OTHERS THEN NULL;
END $$;

SELECT cron.schedule(
  'check-payment-status',
  '*/15 * * * *',
  $$
  SELECT net.http_post(
    url := 'https://cqcklvdblhcdowisjnsf.supabase.co/functions/v1/check-payment-status',
    headers := '{"Content-Type": "application/json", "Authorization": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNxY2tsdmRibGhjZG93aXNqbnNmIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc2MTc2NzQwMywiZXhwIjoyMDc3MzQzNDAzfQ.t5tp0h-OrF3o6r7kClRkkPGPKL4a-g90W_0V70A8OZw"}'::jsonb,
    body := '{}'::jsonb
  );
  $$
);

-- =============================================
-- CRON JOB: Process Payouts
-- =============================================
DO $$ BEGIN
  PERFORM cron.unschedule('process-payouts');
EXCEPTION WHEN OTHERS THEN NULL;
END $$;

SELECT cron.schedule(
  'process-payouts',
  '0 6 * * *',
  $$
  SELECT net.http_post(
    url := 'https://cqcklvdblhcdowisjnsf.supabase.co/functions/v1/process-payouts',
    headers := '{"Content-Type": "application/json", "Authorization": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNxY2tsdmRibGhjZG93aXNqbnNmIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc2MTc2NzQwMywiZXhwIjoyMDc3MzQzNDAzfQ.t5tp0h-OrF3o6r7kClRkkPGPKL4a-g90W_0V70A8OZw"}'::jsonb,
    body := '{}'::jsonb
  );
  $$
);
