// ─── WPP Quiz · Configuration ────────────────────────────────────────────
// Remplace les deux valeurs ci-dessous par celles de ton projet Supabase.
//   1. SUPABASE_URL  : Project Settings → API → Project URL
//   2. SUPABASE_ANON_KEY : Project Settings → API → anon / public key
// L'anon key est SÛRE à exposer côté client (les RLS policies du SQL la limitent).
// Tant que ces champs sont vides, le quiz fonctionne en localStorage uniquement.
window.WPP_CONFIG = {
  SUPABASE_URL: "",
  SUPABASE_ANON_KEY: ""
};
