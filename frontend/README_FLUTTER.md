# TeleMedecine - Application Flutter

## 📱 Transformation React vers Flutter

Ce projet est la transformation complète de l'application React de télémédecine vers Flutter. L'application conserve toutes les fonctionnalités originales avec une interface native Flutter.

## 🎯 Fonctionnalités

### Authentification
- ✅ Connexion (Login)
- ✅ Inscription (Register)
- ✅ Réinitialisation de mot de passe (Reset Password)
- ✅ Vérification d'identité

### Interface Patient
- ✅ Tableau de bord (Dashboard)
- ✅ Analyse de symptômes avec IA
- ✅ Résultats d'analyse détaillés
- ✅ Historique des analyses
- ✅ Centre de notifications
- ✅ Profil utilisateur

## 📁 Structure du Projet

```
lib/
├── main.dart                    # Point d'entrée de l'application
├── models/                      # Modèles de données
│   ├── user.dart
│   ├── analysis.dart
│   ├── notification.dart
│   └── profile.dart
├── services/                    # Services API
│   ├── api_config.dart
│   ├── auth_service.dart
│   └── analysis_service.dart
├── screens/                     # Écrans de l'application
│   ├── auth/                   # Écrans d'authentification
│   │   ├── login_screen.dart
│   │   ├── register_screen.dart
│   │   └── reset_password_screen.dart
│   └── patient/                # Écrans du patient
│       ├── patient_page.dart
│       ├── patient_navigation.dart
│       ├── dashboard_screen.dart
│       ├── symptom_analysis_screen.dart
│       ├── results_screen.dart
│       ├── history_screen.dart
│       ├── notifications_screen.dart
│       └── profile_screen.dart
├── widgets/                     # Widgets réutilisables
│   └── common/
│       ├── app_button.dart
│       ├── app_input.dart
│       └── app_card.dart
└── theme/                       # Thème de l'application
    └── app_theme.dart
```

## 🚀 Installation

### Prérequis

- Flutter SDK (3.0.0 ou supérieur)
- Dart SDK
- Un éditeur de code (VS Code, Android Studio, etc.)

### Étapes d'installation

1. **Installer Flutter**
   ```bash
   # Téléchargez Flutter depuis https://flutter.dev
   # Ajoutez Flutter à votre PATH
   ```

2. **Vérifier l'installation**
   ```bash
   flutter doctor
   ```

3. **Installer les dépendances**
   ```bash
   flutter pub get
   ```

4. **Configurer l'URL de l'API**

   Modifiez le fichier `lib/services/api_config.dart` pour configurer l'URL de votre backend :
   ```dart
   static const String baseUrl = 'http://localhost:8080/api';
   // ou
   static const String baseUrl = 'http://localhost:4000';
   ```

   Pour Android, utilisez `10.0.2.2` au lieu de `localhost` :
   ```dart
   static const String baseUrl = 'http://10.0.2.2:8080/api';
   ```

## ▶️ Lancer l'application

### Sur un émulateur/Simulateur

1. **Android**
   ```bash
   flutter run
   ```

2. **iOS** (Mac uniquement)
   ```bash
   flutter run
   ```

3. **Web**
   ```bash
   flutter run -d chrome
   ```

### Sur un appareil physique

1. Activez le mode développeur sur votre appareil
2. Connectez votre appareil via USB
3. Autorisez le débogage USB
4. Lancez l'application :
   ```bash
   flutter run
   ```

## 🎨 Thème

L'application utilise un thème mauve/violet cohérent avec l'application React originale :

- **Couleur principale** : `#7C3AED` (Violet)
- **Couleur accent** : `#F472B6` (Rose)
- **Fond** : `#F9F5FF` (Lavande clair)

Les couleurs peuvent être modifiées dans `lib/theme/app_theme.dart`.

## 🔧 Configuration Backend

L'application est configurée pour se connecter à un backend REST. Assurez-vous que votre backend est en cours d'exécution et accessible.

### Endpoints requis

- `POST /api/auth/login` - Connexion
- `POST /api/auth/register` - Inscription
- `POST /api/auth/reset-request` - Demande de réinitialisation
- `POST /api/auth/verify-code` - Vérification du code
- `POST /api/auth/reset-password` - Réinitialisation du mot de passe
- `POST /api/analysis` - Soumettre une analyse
- `GET /api/analysis/history` - Historique des analyses

## 📦 Dépendances Principales

- `provider` - Gestion d'état
- `http` / `dio` - Requêtes HTTP
- `shared_preferences` - Stockage local
- `go_router` - Navigation
- `image_picker` - Sélection d'images

## 🔄 Différences avec React

### Navigation
- **React** : React Router avec gestion d'état locale
- **Flutter** : Navigation par routes nommées avec MaterialApp

### Gestion d'état
- **React** : useState, props
- **Flutter** : setState, Provider (préparé pour l'extension)

### Styles
- **React** : CSS avec classes
- **Flutter** : Theme et widgets stylisés

### Stockage
- **React** : localStorage
- **Flutter** : SharedPreferences

## 📱 Fonctionnalités Implémentées

✅ Authentification complète
✅ Interface patient complète
✅ Analyse de symptômes
✅ Historique des analyses
✅ Notifications
✅ Profil utilisateur
✅ Thème cohérent
✅ Navigation intuitive
✅ Validation de formulaires
✅ Gestion d'erreurs

## 🚧 Améliorations Futures

- [ ] Gestion d'état avec Provider/Riverpod
- [ ] Cache des données
- [ ] Mode hors ligne
- [ ] Tests unitaires et d'intégration
- [ ] Internationalisation (i18n)
- [ ] Mode sombre
- [ ] Animations améliorées
- [ ] Notifications push

## 📝 Notes

- L'application inclut des données mockées pour la démonstration lorsque le backend n'est pas disponible
- Les images sont stockées localement pour la démonstration
- Certaines fonctionnalités peuvent nécessiter une configuration backend supplémentaire

## 🤝 Contribution

Pour contribuer au projet :

1. Fork le projet
2. Créez une branche pour votre fonctionnalité
3. Committez vos changements
4. Poussez vers la branche
5. Ouvrez une Pull Request

## 📄 Licence

Ce projet est une transformation de l'application React originale de télémédecine.

---

**Développé avec ❤️ en Flutter**



