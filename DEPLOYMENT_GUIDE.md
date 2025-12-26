# Guide de Déploiement Gratuit - GestionFlotte

Ce guide vous explique comment déployer **GestionFlotte** gratuitement avec une base de données PostgreSQL. La solution proposée est **100% gratuite** et durable pour votre client.

## 🎯 Solution Recommandée : Railway + Supabase

### Pourquoi cette combinaison ?
- ✅ **Railway** : Hébergement gratuit pour applications .NET (500 heures/mois gratuites)
- ✅ **Supabase** : PostgreSQL gratuit (500 MB de stockage, illimité en temps)
- ✅ **Facile à configurer** : Interface graphique simple
- ✅ **Durable** : Pas de limite de temps, seulement des limites d'utilisation
- ✅ **Professionnel** : URLs personnalisées, SSL automatique

---

## 📋 Prérequis

1. Un compte GitHub (gratuit)
2. Un compte Railway (gratuit) : https://railway.app
3. Un compte Supabase (gratuit) : https://supabase.com

---

## 🗄️ Étape 1 : Configuration de la Base de Données (Supabase)

### 1.1 Créer un compte Supabase

1. Allez sur https://supabase.com
2. Cliquez sur "Start your project"
3. Connectez-vous avec GitHub
4. Créez un nouveau projet :
   - **Nom du projet** : `gestionflotte-db`
   - **Mot de passe** : Choisissez un mot de passe fort (notez-le !)
   - **Région** : Choisissez la plus proche (Europe pour la Tunisie)
   - **Plan** : Free

### 1.2 Récupérer la chaîne de connexion

1. Une fois le projet créé, allez dans **Settings** → **Database**
2. Faites défiler jusqu'à **Connection string**
3. Sélectionnez **URI** (ou **Connection pooling** pour de meilleures performances)
4. Copiez la chaîne de connexion. Elle ressemble à :
   ```
   postgresql://postgres:[YOUR-PASSWORD]@db.xxxxx.supabase.co:5432/postgres
   ```

### 1.3 Formater la chaîne pour .NET

Remplacez la chaîne par le format suivant :
```
Host=db.xxxxx.supabase.co;Port=5432;Database=postgres;Username=postgres;Password=[YOUR-PASSWORD];SSL Mode=Require;
```

**Note importante** : Ajoutez `;SSL Mode=Require;` à la fin pour la sécurité.

---

## 🚀 Étape 2 : Déploiement sur Railway

### 2.1 Préparer le projet

1. Assurez-vous que votre code est sur GitHub
2. Créez un fichier `railway.json` à la racine du projet (dans `DIG4ALL-FLOT/`) :

```json
{
  "$schema": "https://railway.app/railway.schema.json",
  "build": {
    "builder": "NIXPACKS"
  },
  "deploy": {
    "startCommand": "dotnet DIG4ALL-FLOT.dll",
    "restartPolicyType": "ON_FAILURE",
    "restartPolicyMaxRetries": 10
  }
}
```

### 2.2 Créer un fichier Railway.toml

Créez `railway.toml` à la racine du projet :

```toml
[build]
builder = "NIXPACKS"

[deploy]
startCommand = "dotnet DIG4ALL-FLOT.dll"
healthcheckPath = "/"
healthcheckTimeout = 100
restartPolicyType = "ON_FAILURE"
restartPolicyMaxRetries = 10
```

### 2.3 Créer un compte Railway

1. Allez sur https://railway.app
2. Cliquez sur "Login" et connectez-vous avec GitHub
3. Cliquez sur "New Project"
4. Sélectionnez "Deploy from GitHub repo"
5. Choisissez votre repository

### 2.4 Configurer les variables d'environnement

Dans Railway, allez dans votre projet → **Variables** et ajoutez :

```
POSTGRES_CONNECTION=Host=db.xxxxx.supabase.co;Port=5432;Database=postgres;Username=postgres;Password=[YOUR-PASSWORD];SSL Mode=Require;
```

**Important** : Remplacez `[YOUR-PASSWORD]` par le mot de passe Supabase que vous avez noté.

### 2.5 Configurer le port

Railway utilise le port défini par la variable `PORT`. Ajoutez cette variable :

```
PORT=8080
```

### 2.6 Déployer

1. Railway détectera automatiquement que c'est un projet .NET
2. Il va builder et déployer l'application
3. Une fois terminé, vous obtiendrez une URL comme : `https://votre-app.up.railway.app`

---

## 🔧 Étape 3 : Configuration Post-Déploiement

### 3.1 Accéder à l'application

1. Ouvrez l'URL fournie par Railway
2. Vous devriez voir la page de login

### 3.2 Configuration initiale

1. Créez le compte root (premier utilisateur)
2. Allez dans **Settings** → **Server Settings**
3. Vérifiez que la connexion PostgreSQL est bien configurée
4. Configurez les autres paramètres selon vos besoins

---

## 🌐 Étape 4 : URL Personnalisée (Optionnel mais Recommandé)

### 4.1 Ajouter un domaine personnalisé

1. Dans Railway, allez dans **Settings** → **Domains**
2. Cliquez sur "Custom Domain"
3. Entrez votre domaine (ex: `gestionflotte.votredomaine.com`)
4. Suivez les instructions pour configurer le DNS

### 4.2 Configuration DNS

Ajoutez un enregistrement CNAME dans votre DNS :
```
Type: CNAME
Name: gestionflotte (ou @ pour le domaine racine)
Value: votre-app.up.railway.app
```

---

## 📊 Limites Gratuites

### Railway
- ✅ **500 heures/mois** gratuites (suffisant pour 24/7)
- ✅ **5 $ de crédit gratuit** par mois
- ✅ Pas de limite de temps

### Supabase
- ✅ **500 MB** de stockage PostgreSQL
- ✅ **2 GB** de bande passante/mois
- ✅ **500 MB** de sauvegarde
- ✅ Pas de limite de temps

**Note** : Pour un usage normal (quelques véhicules, quelques utilisateurs), ces limites sont largement suffisantes.

---

## 🔄 Alternatives Gratuites

Si Railway ne vous convient pas, voici d'autres options :

### Option 2 : Render + Supabase

1. **Render** : https://render.com
   - Plan gratuit : 750 heures/mois
   - Auto-sleep après 15 min d'inactivité (se réveille au premier accès)

**Configuration Render** :
- Créez un nouveau "Web Service"
- Connectez votre repo GitHub
- Build Command : `dotnet publish -c Release -o ./publish`
- Start Command : `dotnet ./publish/DIG4ALL-FLOT.dll --urls http://0.0.0.0:$PORT`
- Variables d'environnement : Même `POSTGRES_CONNECTION` que Supabase

### Option 3 : Fly.io + Supabase

1. **Fly.io** : https://fly.io
   - 3 VMs gratuites (256 MB RAM chacune)
   - Parfait pour .NET

**Configuration Fly.io** :
- Installez `flyctl`
- `fly launch` dans le dossier du projet
- Configurez les variables d'environnement

---

## 🛠️ Fichiers de Configuration à Créer

### 1. Procfile (pour certains hébergeurs)

Créez `Procfile` à la racine :

```
web: dotnet DIG4ALL-FLOT.dll --urls http://0.0.0.0:$PORT
```

### 2. .dockerignore (optionnel)

```
bin/
obj/
.vs/
.vscode/
*.user
*.suo
```

---

## 🔐 Sécurité

### Variables d'environnement sensibles

Ne commitez JAMAIS :
- Les mots de passe
- Les chaînes de connexion complètes
- Les clés API

Utilisez toujours les variables d'environnement de la plateforme d'hébergement.

---

## 📝 Checklist de Déploiement

- [ ] Compte Supabase créé
- [ ] Base de données PostgreSQL configurée
- [ ] Chaîne de connexion récupérée et formatée
- [ ] Compte Railway créé
- [ ] Projet connecté à GitHub
- [ ] Variables d'environnement configurées
- [ ] Application déployée
- [ ] Test de connexion réussi
- [ ] Compte root créé
- [ ] Configuration serveur vérifiée

---

## 🆘 Dépannage

### L'application ne démarre pas

1. Vérifiez les logs dans Railway
2. Vérifiez que `POSTGRES_CONNECTION` est bien configurée
3. Vérifiez que le port est correct (8080 ou PORT)

### Erreur de connexion à la base de données

1. Vérifiez que la chaîne de connexion est correcte
2. Vérifiez que `SSL Mode=Require;` est présent
3. Vérifiez que le mot de passe est correct
4. Vérifiez que Supabase est actif (pas en pause)

### L'application se met en veille

- **Render** : Se met en veille après 15 min. Se réveille au premier accès (peut prendre 30-60 secondes)
- **Railway** : Ne se met pas en veille avec le plan gratuit
- **Fly.io** : Ne se met pas en veille

---

## 💡 Conseils pour votre Client

1. **Surveillance** : Configurez des alertes email dans Railway pour les erreurs
2. **Sauvegardes** : Supabase fait des sauvegardes automatiques, mais vous pouvez aussi exporter manuellement
3. **Monitoring** : Utilisez les outils de monitoring de Railway pour suivre l'utilisation
4. **Évolutivité** : Si les limites gratuites sont atteintes, les plans payants sont très abordables

---

## 📞 Support

- **Railway Docs** : https://docs.railway.app
- **Supabase Docs** : https://supabase.com/docs
- **Render Docs** : https://render.com/docs

---

## ✅ Résumé

Avec cette configuration, vous avez :
- ✅ Hébergement gratuit et durable
- ✅ Base de données PostgreSQL gratuite
- ✅ SSL automatique
- ✅ Déploiement automatique depuis GitHub
- ✅ Pas de limite de temps
- ✅ Solution professionnelle pour votre client

**Temps de configuration estimé** : 30-45 minutes

**Coût mensuel** : 0 € (gratuit à vie dans les limites)




