# Configuration Railway - Dépannage

## Problème : Healthcheck échoue

Si le healthcheck échoue, vérifiez :

1. **Logs de déploiement** : Dans Railway → Deployments → Cliquez sur le dernier déploiement → Voir les logs
2. **Logs en temps réel** : Dans Railway → Votre service → Onglet "Logs"

## Vérifications importantes

### 1. Variable POSTGRES_CONNECTION
Assurez-vous que la variable est définie dans Railway :
- Nom : `POSTGRES_CONNECTION`
- Valeur : `Host=db.xxxxx.supabase.co;Port=5432;Database=postgres;Username=postgres;Password=VOTRE_MOT_DE_PASSE;SSL Mode=Require;`

### 2. Port
Railway définit automatiquement `PORT`. Le Dockerfile utilise `ASPNETCORE_URLS=http://0.0.0.0:${PORT:-8080}`

### 3. Logs à chercher
Dans les logs, cherchez :
- ✅ "Application started" ou "Now listening on"
- ❌ Erreurs de connexion PostgreSQL
- ❌ Erreurs de démarrage
- ❌ "Failed to bind to address"

## Solution si l'application ne démarre pas

1. Vérifiez les logs Railway pour voir l'erreur exacte
2. Vérifiez que `POSTGRES_CONNECTION` est correcte
3. Vérifiez que Supabase est actif (pas en pause)

## Test local du Dockerfile

Pour tester localement :
```bash
docker build -t gestionflotte .
docker run -p 8080:8080 -e POSTGRES_CONNECTION="votre-chaine" gestionflotte
```

