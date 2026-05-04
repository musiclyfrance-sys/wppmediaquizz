# WPP Media · Quiz Paid Social

Quiz d'intégration interactif et fun pour les nouveaux arrivants de l'équipe Paid Social.

- 24 questions (QCM, vrai/faux, qui suis-je, intrus, estimation)
- Système de codes à usage unique (1 code = 1 candidat)
- Leaderboard partagé en temps réel
- Interface admin pour gérer codes, classement et questions
- Sauvegarde via Supabase (fallback localStorage si non configuré)

## Stack

- 100 % statique (HTML + CSS + JS vanilla)
- Hébergé sur **Vercel**
- Persistance via **Supabase** (table `wpp_quiz_state` + Realtime)

## Mise en route — 3 étapes

### 1. Supabase

1. Ouvre ton projet sur [supabase.com](https://supabase.com).
2. Onglet **SQL Editor → New query** → colle le contenu de `supabase-schema.sql` → **Run**.
3. **Project Settings → API** → copie :
   - `Project URL`
   - `anon / public key`

### 2. GitHub

Édite `config.js` et colle les deux valeurs :

```js
window.WPP_CONFIG = {
  SUPABASE_URL: "https://xxxxxxxxxxxx.supabase.co",
  SUPABASE_ANON_KEY: "eyJhbGc..."
};
```

Commit + push sur `main`.

### 3. Vercel

1. **Add New → Project** → choisis le repo `wppmediaquizz`.
2. Framework Preset : **Other** (rien à builder, c'est statique).
3. **Deploy**.

À chaque push sur `main`, Vercel redéploie automatiquement.

## Utilisation

### Côté admin

- Bouton **Admin** en bas à droite.
- Login : `yassir.sabounji@wppmedia.com` / `yassir123` (modifiable dans `index.html`).
- Onglet **Codes** → génère un code, copie-le, donne-le au nouvel arrivant.
- Onglet **Classement** → vue d'ensemble de tous les passages.
- Onglet **Questions** → ajout/édition/suppression de questions.

### Côté candidat

1. Récupère un code WPP-XXXXX auprès du manager.
2. Lit le guide de révision (optionnel).
3. Renseigne son prénom, entre le code, fait les 10 questions.
4. Score sauvegardé dans le leaderboard partagé.

## Architecture du sync

Le front utilise toujours `localStorage` pour rester synchrone et rapide. Une couche
au-dessus (`sbHydrate` / `sbPushDebounced`) :

- hydrate `localStorage` depuis Supabase au chargement,
- pousse chaque écriture (debounced 250 ms) vers Supabase,
- s'abonne aux changements Realtime pour mettre à jour le dashboard admin en direct.

Si `config.js` n'est pas rempli, tout retombe sur `localStorage` pur — l'app reste
fonctionnelle.

## Hardening (optionnel)

Pour un vrai contrôle d'accès admin, remplacer la connexion email/password
hardcodée par Supabase Auth, et restreindre les `update` policies à un rôle
authentifié. Voir les commentaires dans `supabase-schema.sql`.

## Charte couleurs WPP

| Couleur     | Hex      |
|-------------|----------|
| Navy        | #000050  |
| Cyan        | #93DFE3  |
| Lime        | #B0F467  |
| Blue        | #5465FF  |
| White       | #FFFFFF  |
