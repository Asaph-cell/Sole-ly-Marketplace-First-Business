-- Enable pg_cron extension (required for scheduled jobs)
CREATE EXTENSION IF NOT EXISTS pg_cron;
CREATE EXTENSION IF NOT EXISTS pg_net;

-- Grant usage to postgres user
GRANT USAGE ON SCHEMA cron TO postgres;

-- =============================================
-- CRON JOB: Auto-Cancel Stale Orders
-- Runs every hour to cancel orders not confirmed by vendor within 48 hours
-- =============================================
SELECT cron.unschedule('auto-cancel-stale-orders');

SELECT cron.schedule(
  'auto-cancel-stale-orders',
  '0 * * * *', -- Every hour at minute 0
  $$
  SELECT
    net.http_post(
      url := 'https://cqcklvdblhcdowisjnsf.supabase.co/functions/v1/auto-cancel-stale-orders',
      headers := '{"Content-Type": "application/json", "Authorization": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNxY2tsdmRibGhjZG93aXNqbnNmIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc2MTc2NzQwMywiZXhwIjoyMDc3MzQzNDAzfQ.t5tp0h-OrF3o6r7kClRkkPGPKL4a-g90W_0V70A8OZw"}'::jsonb,
      body := '{}'::jsonb
    );
  $$
);

-- =============================================
-- CRON JOB: Auto-Release Escrow
-- Runs every hour to release escrow for delivered orders after 24h buyer confirmation window
-- =============================================
SELECT cron.unschedule('auto-release-escrow');

SELECT cron.schedule(
  'auto-release-escrow',
  '30 * * * *', -- Every hour at minute 30
  $$
  SELECT
    net.http_post(
      url := 'https://cqcklvdblhcdowisjnsf.supabase.co/functions/v1/auto-release-escrow',
      headers := '{"Content-Type": "application/json", "Authorization": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNxY2tsdmRibGhjZG93aXNqbnNmIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc2MTc2NzQwMywiZXhwIjoyMDc3MzQzNDAzfQ.t5tp0h-OrF3o6r7kClRkkPGPKL4a-g90W_0V70A8OZw"}'::jsonb,
      body := '{}'::jsonb
    );
  $$
);

-- =============================================
-- CRON JOB: Auto-Refund Unshipped Orders
-- Runs every 6 hours to refund orders not shipped within 5 days
-- =============================================
SELECT cron.unschedule('auto-refund-unshipped');

SELECT cron.schedule(
  'auto-refund-unshipped',
  '0 */6 * * *', -- Every 6 hours
  $$
  SELECT
    net.http_post(
      url := 'https://cqcklvdblhcdowisjnsf.supabase.co/functions/v1/auto-refund-unshipped',
      headers := '{"Content-Type": "application/json", "Authorization": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNxY2tsdmRibGhjZG93aXNqbnNmIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc2MTc2NzQwMywiZXhwIjoyMDc3MzQzNDAzfQ.t5tp0h-OrF3o6r7kClRkkPGPKL4a-g90W_0V70A8OZw"}'::jsonb,
      body := '{}'::jsonb
    );
  $$
);

-- =============================================
-- CRON JOB: Check Payment Status
-- Runs every 15 minutes to verify pending payments
-- =============================================
SELECT cron.unschedule('check-payment-status');

SELECT cron.schedule(
  'check-payment-status',
  '*/15 * * * *', -- Every 15 minutes
  $$
  SELECT
    net.http_post(
      url := 'https://cqcklvdblhcdowisjnsf.supabase.co/functions/v1/check-payment-status',
      headers := '{"Content-Type": "application/json", "Authorization": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNxY2tsdmRibGhjZG93aXNqbnNmIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc2MTc2NzQwMywiZXhwIjoyMDc3MzQzNDAzfQ.t5tp0h-OrF3o6r7kClRkkPGPKL4a-g90W_0V70A8OZw"}'::jsonb,
      body := '{}'::jsonb
    );
  $$
);

-- =============================================
-- CRON JOB: Process Payouts
-- Runs daily at 9 AM EAT to process vendor payouts
-- =============================================
SELECT cron.unschedule('process-payouts');

SELECT cron.schedule(
  'process-payouts',
  '0 6 * * *', -- 6:00 UTC = 9:00 AM EAT
  $$
  SELECT
    net.http_post(
      url := 'https://cqcklvdblhcdowisjnsf.supabase.co/functions/v1/process-payouts',
      headers := '{"Content-Type": "application/json", "Authorization": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNxY2tsdmRibGhjZG93aXNqbnNmIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc2MTc2NzQwMywiZXhwIjoyMDc3MzQzNDAzfQ.t5tp0h-OrF3o6r7kClRkkPGPKL4a-g90W_0V70A8OZw"}'::jsonb,
      body := '{}'::jsonb
    );
  $$
);
