# 🚀 Guide de Démarrage Rapide

## ✅ L'application est en cours de lancement !

L'application Flutter est en train de se compiler et s'ouvrira automatiquement dans Chrome.

## 📋 Étapes suivantes

### 1. Vérifier la compilation

Une fois la compilation terminée, vous verrez :
- L'application s'ouvre dans Chrome
- La console affiche "Application finished"
- L'URL sera généralement `http://localhost:xxxxx`

### 2. Configurer le backend (si nécessaire)

Si vous avez un backend à connecter, modifiez l'URL dans :
```
lib/services/api_config.dart
```

Par défaut, l'URL est :
```dart
static const String baseUrl = 'http://localhost:8080/api';
```

**Pour Chrome/Web** : Utilisez `localhost` normalement

**Pour Windows Desktop** : Si vous lancez sur Windows desktop, utilisez `localhost` normalement

### 3. Tester l'application

Vous pouvez maintenant :
- ✅ Tester la connexion
- ✅ Créer un compte
- ✅ Explorer le dashboard
- ✅ Faire une analyse de symptômes

### 4. Lancer sur différentes plateformes

#### Sur Chrome (Web)
```bash
flutter run -d chrome
```

#### Sur Windows Desktop (nécessite Visual Studio)
```bash
flutter run -d windows
```

#### Sur Android (si émulateur/appareil connecté)
```bash
flutter run -d android
```

## 🛠️ Commandes utiles

### Voir les appareils disponibles
```bash
flutter devices
```

### Nettoyer le projet
```bash
flutter clean
flutter pub get
```

### Vérifier les erreurs
```bash
flutter analyze
```

### Mode développement avec hot reload
Lorsque l'application est lancée :
- Appuyez sur `r` pour hot reload
- Appuyez sur `R` pour hot restart
- Appuyez sur `q` pour quitter

## 📱 Interface

L'application comprend :

1. **Écran de connexion** - Connexion avec email/mot de passe
2. **Écran d'inscription** - Création de compte
3. **Dashboard** - Vue d'ensemble de la santé
4. **Analyse de symptômes** - Formulaire d'analyse IA
5. **Résultats** - Résultats détaillés de l'analyse
6. **Historique** - Liste des analyses précédentes
7. **Notifications** - Centre de notifications
8. **Profil** - Gestion du profil utilisateur

## 🔧 Résolution de problèmes

### Si l'application ne se lance pas

1. Vérifiez que Flutter est bien installé :
   ```bash
   flutter doctor
   ```

2. Nettoyez et réinstallez les dépendances :
   ```bash
   flutter clean
   flutter pub get
   ```

3. Vérifiez les erreurs de compilation :
   ```bash
   flutter analyze
   ```

### Si le backend n'est pas accessible

- L'application fonctionne avec des données mockées
- Vous pouvez tester toutes les fonctionnalités sans backend
- Configurez l'URL du backend dans `lib/services/api_config.dart`

## 📚 Documentation

- `README.md` - Guide principal
- `README_FLUTTER.md` - Documentation complète Flutter
- `TRANSFORMATION_SUMMARY.md` - Résumé de la transformation

## 🎉 Bon développement !

L'application est maintenant prête à être utilisée et testée.



