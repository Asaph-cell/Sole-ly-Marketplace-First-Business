
create table if not exists webhook_logs (
  id uuid default gen_random_uuid() primary key,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null,
  payload jsonb,
  error_message text,
  status text
);

alter table webhook_logs enable row level security;

create policy "Enable insert for service role only" ON webhook_logs
  for insert with check (true);

create policy "Enable select for service role only" ON webhook_logs
  for select using (true);
