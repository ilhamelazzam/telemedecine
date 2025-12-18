# 🔌 Guide de Connexion Backend ↔️ Frontend ↔️ IA

## 📋 Architecture du Projet

```
telemedecine/
├── backend/                    # Backend Java Spring Boot
│   ├── src/
│   │   └── main/
│   │       ├── java/
│   │       │   └── com/telemedecine/
│   │       │       ├── controller/
│   │       │       │   ├── AuthController.java
│   │       │       │   ├── AnalysisController.java
│   │       │       │   └── PatientController.java
│   │       │       ├── service/
│   │       │       └── model/
│   │       └── resources/
│   │           └── application.properties
│   └── pom.xml
│
├── frontend/                   # Frontend Flutter
│   ├── lib/
│   │   ├── services/
│   │   │   ├── api_config.dart
│   │   │   ├── http_service.dart
│   │   │   ├── auth_service.dart
│   │   │   └── analysis_service.dart
│   │   ├── screens/
│   │   └── models/
│   └── pubspec.yaml
│
└── ai_models/                  # Modèles IA (à créer)
    ├── ml_model/               # Modèle ML pour l'analyse de symptômes
    └── cnn_model/              # Modèle CNN pour l'analyse d'images
```

---

## 🚀 1. Démarrer le Backend

### Prérequis
- Java 17+
- Maven 3.6+
- MySQL (Aiven Cloud configuré)

### Configuration

1. **Variables d'environnement** (créer `.env` ou configurer dans l'IDE):
```bash
AIVEN_DB_PASSWORD=votre_mot_de_passe
MAIL_USERNAME=votre_email@gmail.com
MAIL_PASSWORD=votre_mot_de_passe_app
MAIL_FROM=no-reply@telemedecine.com
```

2. **Lancer le backend**:

```bash
cd backend

# Avec Maven
mvn spring-boot:run

# Ou avec Gradle
./gradlew bootRun
```

Le backend sera accessible sur: **http://localhost:8080**

### Endpoints disponibles

#### **Auth**
- `POST /api/auth/register` - Inscription
- `POST /api/auth/login` - Connexion
- `POST /api/auth/reset-request` - Demande de réinitialisation
- `POST /api/auth/verify-code` - Vérification du code
- `POST /api/auth/reset-password` - Réinitialisation

#### **Analysis**
- `POST /api/analysis` - Soumettre une analyse
- `GET /api/analysis/history` - Historique des analyses
- `GET /api/analysis/{id}` - Détails d'une analyse

#### **Patient**
- `GET /api/profile` - Récupérer le profil
- `PUT /api/profile` - Mettre à jour le profil

---

## 📱 2. Configurer le Frontend Flutter

### Configuration de l'URL backend

Dans `frontend/lib/services/api_config.dart`:

```dart
class ApiConfig {
  // CHOISIR SELON VOTRE CONFIGURATION:
  
  // 1. Pour émulateur Android:
  static const String baseUrl = 'http://10.0.2.2:8080/api';
  
  // 2. Pour appareil physique (même réseau WiFi):
  // Trouver votre IP locale avec: ipconfig (Windows) ou ifconfig (Linux/Mac)
  // static const String baseUrl = 'http://192.168.X.X:8080/api';
  
  // 3. Pour iOS Simulator:
  // static const String baseUrl = 'http://localhost:8080/api';
  
  // 4. Pour le web:
  // static const String baseUrl = 'http://localhost:8080/api';
  
  // Mode démo (sans backend)
  static const bool useDemoMode = false; // false pour utiliser le vrai backend
}
```

### Trouver votre adresse IP locale

**Windows:**
```bash
ipconfig
# Chercher "IPv4 Address" sous votre connexion WiFi
```

**Linux/Mac:**
```bash
ifconfig
# ou
ip addr show
```

### Lancer l'application Flutter

```bash
cd frontend

# Installer les dépendances
flutter pub get

# Lancer sur Android
flutter run

# Lancer sur iOS
flutter run -d ios

# Lancer sur le web
flutter run -d chrome
```

---

## 🤖 3. Intégrer les Modèles d'IA

### Architecture IA recommandée

#### Option A: API Python Flask/FastAPI (Recommandé)

Créer un service Python séparé pour les modèles IA:

```python
# ai_models/app.py
from flask import Flask, request, jsonify
import tensorflow as tf
import numpy as np

app = Flask(__name__)

# Charger les modèles
ml_model = tf.keras.models.load_model('models/symptom_model.h5')
cnn_model = tf.keras.models.load_model('models/image_model.h5')

@app.route('/api/ai/analyze-symptoms', methods=['POST'])
def analyze_symptoms():
    data = request.json
    symptoms = data.get('symptoms', '')
    # Preprocessing et prédiction
    prediction = ml_model.predict(...)
    return jsonify({
        'diagnosis': prediction,
        'confidence': 0.85
    })

@app.route('/api/ai/analyze-image', methods=['POST'])
def analyze_image():
    image = request.files['image']
    # Preprocessing et prédiction CNN
    prediction = cnn_model.predict(...)
    return jsonify({
        'result': prediction,
        'confidence': 0.92
    })

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
```

**Démarrer le service IA:**
```bash
cd ai_models
pip install flask tensorflow numpy pillow
python app.py
```

#### Option B: Intégration directe dans Spring Boot

Utiliser **Deeplearning4j** (DL4J) pour charger des modèles dans Java:

```java
// AnalysisService.java
import org.deeplearning4j.nn.multilayer.MultiLayerNetwork;

@Service
public class AnalysisService {
    
    private MultiLayerNetwork mlModel;
    
    @PostConstruct
    public void loadModels() {
        mlModel = ModelSerializer.restoreMultiLayerNetwork("path/to/model.zip");
    }
    
    public String analyzeSym ptoms(String symptoms) {
        // Utiliser le modèle
        INDArray input = preprocessSymptoms(symptoms);
        INDArray output = mlModel.output(input);
        return interpretPrediction(output);
    }
}
```

### Mise à jour du Backend pour utiliser l'IA

**AnalysisService.java:**
```java
@Service
public class AnalysisService {
    
    @Value("${ai.service.url:http://localhost:5000}")
    private String aiServiceUrl;
    
    private final RestTemplate restTemplate;
    
    public Analysis createAnalysis(Patient patient, AnalysisRequest request) {
        // Appeler le service IA
        Map<String, Object> aiRequest = Map.of(
            "symptoms", request.getSymptoms(),
            "categories", request.getCategories()
        );
        
        ResponseEntity<Map> aiResponse = restTemplate.postForEntity(
            aiServiceUrl + "/api/ai/analyze-symptoms",
            aiRequest,
            Map.class
        );
        
        // Créer l'analyse avec les résultats de l'IA
        Analysis analysis = new Analysis();
        analysis.setPatient(patient);
        analysis.setSymptoms(request.getSymptoms());
        analysis.setDiagnosis(aiResponse.getBody().get("diagnosis").toString());
        analysis.setConfidence((Double) aiResponse.getBody().get("confidence"));
        
        return analysisRepository.save(analysis);
    }
}
```

### Mise à jour application.properties

```properties
# AI Service Configuration
ai.service.url=http://localhost:5000
ai.service.timeout=30000
```

---

## 🔄 4. Flux de Communication Complet

```
┌──────────────┐         ┌──────────────┐         ┌──────────────┐
│              │  HTTP   │              │  HTTP   │              │
│   Flutter    │────────▶│ Spring Boot  │────────▶│  Service IA  │
│   Frontend   │◀────────│   Backend    │◀────────│  (Python)    │
│              │  JSON   │              │  JSON   │              │
└──────────────┘         └──────────────┘         └──────────────┘
                                │
                                │ JDBC
                                ▼
                         ┌──────────────┐
                         │    MySQL     │
                         │   (Aiven)    │
                         └──────────────┘
```

### Exemple de flux pour une analyse:

1. **Utilisateur soumet des symptômes** (Flutter)
   ```dart
   await analysisService.submitAnalysis(
     symptoms: "Toux, fièvre",
     categories: ["Respiratoire", "Général"]
   );
   ```

2. **Frontend envoie au Backend** (HTTP POST)
   ```
   POST http://10.0.2.2:8080/api/analysis
   Headers: Authorization: Bearer <token>
   Body: { "symptoms": "Toux, fièvre", "categories": [...] }
   ```

3. **Backend traite et appelle l'IA** (Python)
   ```
   POST http://localhost:5000/api/ai/analyze-symptoms
   Body: { "symptoms": "Toux, fièvre" }
   ```

4. **Service IA retourne la prédiction**
   ```json
   {
     "diagnosis": "Infection respiratoire probable",
     "confidence": 0.87,
     "recommendations": ["Repos", "Hydratation"]
   }
   ```

5. **Backend enregistre en base de données** (MySQL)

6. **Backend retourne la réponse** (Frontend)
   ```json
   {
     "id": "123",
     "symptoms": "Toux, fièvre",
     "diagnosis": "Infection respiratoire probable",
     "performedAt": "2025-12-12T10:30:00"
   }
   ```

---

## 🧪 5. Tests

### Tester le Backend directement

```bash
# Test de connexion
curl -X POST http://localhost:8080/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"password123"}'

# Test d'analyse (avec token)
curl -X POST http://localhost:8080/api/analysis \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <votre_token>" \
  -d '{"symptoms":"Mal de tête","categories":["Neurologique"]}'
```

### Tester le service IA

```bash
curl -X POST http://localhost:5000/api/ai/analyze-symptoms \
  -H "Content-Type: application/json" \
  -d '{"symptoms":"Toux persistante depuis 3 jours"}'
```

---

## 🐛 Dépannage

### Backend ne démarre pas
- Vérifier que le port 8080 est libre
- Vérifier les credentials MySQL dans application.properties
- Vérifier les logs: `mvn spring-boot:run`

### Frontend ne se connecte pas
- Vérifier l'URL dans `api_config.dart`
- Pour Android: Utiliser `10.0.2.2` au lieu de `localhost`
- Vérifier que le backend est accessible: `curl http://10.0.2.2:8080/api/health`
- Désactiver temporairement le pare-feu Windows

### Service IA ne répond pas
- Vérifier que Flask/FastAPI tourne sur port 5000
- Vérifier les logs Python
- Tester avec curl pour isoler le problème

### Erreur CORS
Ajouter dans le backend:
```java
@CrossOrigin(origins = {"http://localhost:3000", "http://10.0.2.2:*"})
```

---

## 📚 Ressources

- [Spring Boot REST API](https://spring.io/guides/tutorials/rest/)
- [Flutter HTTP Package](https://pub.dev/packages/http)
- [Flask REST API](https://flask.palletsprojects.com/en/2.3.x/)
- [TensorFlow Models](https://www.tensorflow.org/tutorials)

---

## ✅ Checklist de Démarrage

- [ ] Backend Java Spring Boot lancé (port 8080)
- [ ] Base de données MySQL configurée et accessible
- [ ] Service IA Python lancé (port 5000)
- [ ] Frontend Flutter configuré avec la bonne URL
- [ ] Test de connexion backend réussi
- [ ] Test d'inscription/connexion réussi
- [ ] Test d'analyse avec IA réussi

Bon développement ! 🚀
