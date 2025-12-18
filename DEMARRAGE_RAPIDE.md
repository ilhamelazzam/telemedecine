# 🚀 Guide Rapide de Démarrage

## 📋 Ordre de démarrage

### 1️⃣ **Démarrer le service IA** (Port 5000)

```bash
cd ai_models
python -m venv venv
venv\Scripts\activate    # Windows
pip install -r requirements.txt
python app.py
```

✅ Vérifier: http://localhost:5000/health

---

### 2️⃣ **Démarrer le Backend** (Port 8080)

```bash
cd backend

# Configurer les variables d'environnement (créer .env ou configurer dans IDE)
# AIVEN_DB_PASSWORD=votre_mot_de_passe
# MAIL_USERNAME=votre_email@gmail.com
# MAIL_PASSWORD=votre_mot_de_passe_app

mvn spring-boot:run
```

✅ Vérifier: http://localhost:8080/api/auth/login (doit retourner une erreur 405 ou 400)

---

### 3️⃣ **Démarrer le Frontend** (Flutter)

```bash
cd frontend

# Configurer l'URL dans lib/services/api_config.dart:
# Pour émulateur Android: http://10.0.2.2:8080/api
# Pour téléphone physique: http://192.168.X.X:8080/api (votre IP locale)

flutter pub get
flutter run
```

---

## 🧪 Test Rapide

### Test du service IA (PowerShell)

```powershell
# Test de santé
Invoke-WebRequest -Uri "http://localhost:5000/health" -Method GET

# Test d'analyse de symptômes
$body = @{
    symptoms = "Toux et fièvre"
} | ConvertTo-Json

Invoke-WebRequest -Uri "http://localhost:5000/api/ai/analyze-symptoms" `
    -Method POST `
    -ContentType "application/json" `
    -Body $body
```

### Test du Backend (PowerShell)

```powershell
# Test d'inscription
$registerBody = @{
    fullName = "Test User"
    email = "test@example.com"
    password = "password123"
} | ConvertTo-Json

Invoke-WebRequest -Uri "http://localhost:8080/api/auth/register" `
    -Method POST `
    -ContentType "application/json" `
    -Body $registerBody
```

---

## 🔧 Configuration Frontend

### Pour Émulateur Android

`lib/services/api_config.dart`:
```dart
static const String baseUrl = 'http://10.0.2.2:8080/api';
static const bool useDemoMode = false;
```

### Pour Téléphone Physique

1. Trouver votre IP locale:
```powershell
ipconfig
# Chercher "IPv4 Address" (ex: 192.168.1.10)
```

2. Mettre à jour `api_config.dart`:
```dart
static const String baseUrl = 'http://192.168.1.10:8080/api';
```

3. S'assurer que le pare-feu Windows autorise le port 8080

---

## 📱 Test de l'application complète

1. **Ouvrir l'app Flutter**
2. **S'inscrire** avec un email et mot de passe
3. **Se connecter**
4. **Faire une analyse de symptômes** :
   - Sélectionner des catégories
   - Décrire les symptômes
   - Soumettre
5. **Vérifier l'historique**

---

## 🐛 Problèmes courants

### Backend ne démarre pas
- ✅ Vérifier que le port 8080 est libre
- ✅ Vérifier les credentials MySQL
- ✅ Vérifier les variables d'environnement

### Frontend ne se connecte pas
- ✅ Utiliser `10.0.2.2` pour émulateur Android (pas `localhost`)
- ✅ Vérifier que le backend est accessible
- ✅ Désactiver temporairement le pare-feu Windows
- ✅ Vérifier que `useDemoMode = false`

### Service IA ne répond pas
- ✅ Vérifier que Python Flask tourne sur port 5000
- ✅ Vérifier l'environnement virtuel activé
- ✅ Vérifier les dépendances installées

---

## 📚 Documentation complète

Voir [CONNEXION_BACKEND.md](CONNEXION_BACKEND.md) pour plus de détails.

---

## ✅ Checklist

- [ ] Service IA lancé et accessible (port 5000)
- [ ] Backend lancé et accessible (port 8080)
- [ ] Base de données connectée
- [ ] Frontend configuré avec la bonne URL
- [ ] Test d'inscription réussi
- [ ] Test d'analyse avec IA réussi

Bonne chance ! 🎉
