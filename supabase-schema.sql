-- Run this entire script in Supabase Dashboard > SQL Editor.
-- Row Level Security ensures each user can only access their own records.
create extension if not exists pgcrypto;

create table if not exists public.reminders (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  vehicle_name text not null check (char_length(vehicle_name) between 1 and 80),
  registration text,
  service_type text not null,
  due_date date not null,
  odometer integer check (odometer is null or odometer >= 0),
  estimated_cost numeric(12,2) check (estimated_cost is null or estimated_cost >= 0),
  notes text,
  completed boolean not null default false,
  created_at timestamptz not null default now()
);

create table if not exists public.service_history (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  reminder_id uuid,
  vehicle_name text not null,
  registration text,
  service_type text not null,
  completed_date date not null,
  odometer integer check (odometer is null or odometer >= 0),
  estimated_cost numeric(12,2),
  final_cost numeric(12,2) check (final_cost is null or final_cost >= 0),
  notes text,
  created_at timestamptz not null default now()
);

create index if not exists reminders_user_due_idx on public.reminders(user_id, due_date);
create index if not exists history_user_date_idx on public.service_history(user_id, completed_date desc);

alter table public.reminders enable row level security;
alter table public.service_history enable row level security;

drop policy if exists "Users can view their own reminders" on public.reminders;
create policy "Users can view their own reminders" on public.reminders for select to authenticated using (auth.uid() = user_id);
drop policy if exists "Users can create their own reminders" on public.reminders;
create policy "Users can create their own reminders" on public.reminders for insert to authenticated with check (auth.uid() = user_id);
drop policy if exists "Users can update their own reminders" on public.reminders;
create policy "Users can update their own reminders" on public.reminders for update to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id);
drop policy if exists "Users can delete their own reminders" on public.reminders;
create policy "Users can delete their own reminders" on public.reminders for delete to authenticated using (auth.uid() = user_id);

drop policy if exists "Users can view their own service history" on public.service_history;
create policy "Users can view their own service history" on public.service_history for select to authenticated using (auth.uid() = user_id);
drop policy if exists "Users can create their own service history" on public.service_history;
create policy "Users can create their own service history" on public.service_history for insert to authenticated with check (auth.uid() = user_id);
drop policy if exists "Users can delete their own service history" on public.service_history;
create policy "Users can delete their own service history" on public.service_history for delete to authenticated using (auth.uid() = user_id);
