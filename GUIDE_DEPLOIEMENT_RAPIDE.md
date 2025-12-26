# 🚀 Guide de Déploiement Rapide - GestionFlotte

## Solution 100% Gratuite : Railway + Supabase

### ⏱️ Temps estimé : 30-45 minutes

---

## 📝 Étape 1 : Base de Données (Supabase) - 10 min

1. **Créer un compte** : https://supabase.com → "Start your project"
2. **Créer un projet** :
   - Nom : `gestionflotte-db`
   - Région : Europe (le plus proche)
   - Plan : **Free**
   - Notez le mot de passe !

3. **Récupérer la chaîne de connexion** :
   - Settings → Database → Connection string
   - Sélectionnez **URI**
   - Format pour .NET :
   ```
   Host=db.xxxxx.supabase.co;Port=5432;Database=postgres;Username=postgres;Password=VOTRE_MOT_DE_PASSE;SSL Mode=Require;
   ```

---

## 🚂 Étape 2 : Hébergement (Railway) - 20 min

1. **Créer un compte** : https://railway.app → Login avec GitHub

2. **Créer un projet** :
   - "New Project" → "Deploy from GitHub repo"
   - Sélectionnez votre repository

3. **Configurer les variables** :
   - Variables → Add Variable
   - Nom : `POSTGRES_CONNECTION`
   - Valeur : La chaîne de connexion de l'étape 1

4. **Déployer** :
   - Railway détecte automatiquement .NET
   - Attendez la fin du build (5-10 min)
   - Vous obtenez une URL : `https://votre-app.up.railway.app`

---

## ✅ Étape 3 : Vérification - 5 min

1. **Ouvrez l'URL** Railway
2. **Créez le compte root** (premier utilisateur)
3. **Allez dans Settings → Server Settings**
4. **Vérifiez** que PostgreSQL est bien configuré

---

## 🎯 C'est tout !

Votre application est maintenant en ligne, **gratuitement et pour toujours** (dans les limites gratuites).

---

## 📊 Limites Gratuites

| Service | Limite Gratuite |
|---------|----------------|
| **Railway** | 500 heures/mois (24/7) |
| **Supabase** | 500 MB stockage, 2 GB bande passante/mois |

**Suffisant pour** : Plusieurs véhicules, plusieurs utilisateurs, usage normal.

---

## 🔧 Fichiers Créés

Les fichiers suivants ont été créés pour faciliter le déploiement :
- ✅ `railway.json` - Configuration Railway
- ✅ `railway.toml` - Configuration alternative
- ✅ `Procfile` - Pour Render/Fly.io
- ✅ `DEPLOYMENT_GUIDE.md` - Guide détaillé complet

---

## 🆘 Problèmes Courants

### L'app ne démarre pas
- Vérifiez les logs dans Railway
- Vérifiez que `POSTGRES_CONNECTION` est bien configurée

### Erreur de connexion DB
- Vérifiez que `SSL Mode=Require;` est présent
- Vérifiez le mot de passe

### L'app se met en veille (Render uniquement)
- Normal après 15 min d'inactivité
- Se réveille au premier accès (30-60 sec)

---

## 💡 Alternative : Render

Si Railway ne vous convient pas, utilisez **Render** :
1. https://render.com
2. New → Web Service
3. Connectez GitHub
4. Build : `dotnet publish -c Release -o ./publish`
5. Start : `dotnet ./publish/DIG4ALL-FLOT.dll --urls http://0.0.0.0:$PORT`
6. Variables : Même `POSTGRES_CONNECTION`

**Note** : Render se met en veille après 15 min (gratuit), mais se réveille automatiquement.

---

## 📞 Besoin d'aide ?

Consultez le guide complet : `DEPLOYMENT_GUIDE.md`

---

**🎉 Félicitations ! Votre application est prête pour la production !**


