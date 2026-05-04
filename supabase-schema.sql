-- ╔════════════════════════════════════════════════════════════════════╗
-- ║  WPP Quiz Paid Social — Schéma Supabase                            ║
-- ║  À exécuter une fois dans : Supabase → SQL Editor → New query      ║
-- ╚════════════════════════════════════════════════════════════════════╝

-- Table unique qui stocke tout l'état du quiz dans une seule ligne JSON.
-- Avantage : on garde le code front quasi inchangé (mêmes clés que localStorage).
create table if not exists public.wpp_quiz_state (
  id          text        primary key,
  payload     jsonb       not null default '{}'::jsonb,
  updated_at  timestamptz not null default now()
);

-- Ligne globale partagée par tous les utilisateurs.
insert into public.wpp_quiz_state (id, payload)
values ('global', '{}'::jsonb)
on conflict (id) do nothing;

-- ─── Row-Level Security ─────────────────────────────────────────────
-- On autorise la lecture/écriture publique sur cette ligne unique.
-- L'accès admin est protégé côté front (email + mot de passe).
-- Pour un vrai durcissement, voir la section "Hardening" du README.
alter table public.wpp_quiz_state enable row level security;

drop policy if exists "wpp_quiz_state_read"  on public.wpp_quiz_state;
drop policy if exists "wpp_quiz_state_write" on public.wpp_quiz_state;
drop policy if exists "wpp_quiz_state_upd"   on public.wpp_quiz_state;

create policy "wpp_quiz_state_read"
  on public.wpp_quiz_state for select
  using (true);

create policy "wpp_quiz_state_write"
  on public.wpp_quiz_state for insert
  with check (id = 'global');

create policy "wpp_quiz_state_upd"
  on public.wpp_quiz_state for update
  using (id = 'global')
  with check (id = 'global');

-- ─── Realtime ───────────────────────────────────────────────────────
-- Active la diffusion temps réel pour que l'admin voie les nouveaux scores
-- apparaître sans rafraîchir la page.
alter publication supabase_realtime add table public.wpp_quiz_state;
