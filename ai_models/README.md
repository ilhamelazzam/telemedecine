# 🤖 Service IA - Télémédecine

Service d'intelligence artificielle pour l'analyse de symptômes et d'images médicales.

## 🚀 Installation

```bash
# Installer Python 3.8+
# https://www.python.org/downloads/

# Créer un environnement virtuel (recommandé)
python -m venv venv

# Activer l'environnement virtuel
# Windows:
venv\Scripts\activate
# Linux/Mac:
source venv/bin/activate

# Installer les dépendances
pip install -r requirements.txt
```

## 📦 Dépendances

- **Flask** : Framework web Python
- **TensorFlow** : Framework de machine learning
- **NumPy** : Calculs numériques
- **Pillow** : Traitement d'images
- **Flask-CORS** : Gestion CORS pour API

## 🏃 Démarrage

```bash
python app.py
```

Le service sera accessible sur **http://localhost:5000**

## 📡 Endpoints API

### 1. Vérification de santé
```http
GET /health
```

**Réponse:**
```json
{
  "status": "healthy",
  "service": "AI Analysis Service",
  "version": "1.0.0"
}
```

### 2. Analyse de symptômes
```http
POST /api/ai/analyze-symptoms
Content-Type: application/json

{
  "symptoms": "J'ai mal à la tête et de la fièvre",
  "categories": ["Neurologique", "Général"]
}
```

**Réponse:**
```json
{
  "diagnosis": "État fébrile - Infection possible",
  "severity": "élevé",
  "confidence": 0.85,
  "recommendations": [
    "Prendre la température régulièrement",
    "Hydratation importante",
    "Consulter un médecin rapidement"
  ],
  "categories_detected": ["fevre", "neurologique"]
}
```

### 3. Analyse d'image
```http
POST /api/ai/analyze-image
Content-Type: multipart/form-data

image: [fichier image]
```

**Réponse:**
```json
{
  "diagnosis": "Peau normale - Pas d'anomalie détectée",
  "confidence": 0.92,
  "recommendations": [
    "Image analysée par IA - Non diagnostic médical",
    "Consulter un professionnel pour confirmation"
  ],
  "requires_medical_attention": false
}
```

### 4. Informations sur les modèles
```http
GET /api/ai/models/info
```

## 🧪 Tests avec curl

```bash
# Test de santé
curl http://localhost:5000/health

# Test d'analyse de symptômes
curl -X POST http://localhost:5000/api/ai/analyze-symptoms \
  -H "Content-Type: application/json" \
  -d '{"symptoms":"Toux et fièvre depuis 2 jours"}'

# Test d'analyse d'image
curl -X POST http://localhost:5000/api/ai/analyze-image \
  -F "image=@/path/to/image.jpg"
```

## 🔧 Configuration

Pour modifier le port ou l'hôte, éditer `app.py`:

```python
app.run(
    host='0.0.0.0',  # Accessible depuis n'importe quelle IP
    port=5000,       # Port du service
    debug=True       # Mode debug (désactiver en production)
)
```

## 📊 Catégories de symptômes supportées

- **Respiratoire** : Toux, essoufflement, gorge, rhume
- **Digestif** : Nausée, vomissement, diarrhée, douleurs abdominales
- **Neurologique** : Mal de tête, migraine, vertiges
- **Musculaire** : Douleurs musculaires, courbatures
- **Fébrile** : Fièvre, frissons, température élevée
- **Allergique** : Éternuements, démangeaisons, rougeurs

## 🎯 Améliorations futures

### Modèle ML réel
Remplacer l'analyseur basé sur des règles par un vrai modèle ML:

```python
import tensorflow as tf
from tensorflow.keras.models import load_model

# Charger le modèle entraîné
symptom_model = load_model('models/symptom_classifier.h5')

def analyze_symptoms(text):
    # Vectoriser le texte
    vector = vectorize_text(text)
    # Prédiction
    prediction = symptom_model.predict(vector)
    return prediction
```

### Modèle CNN pour images
Intégrer un vrai CNN pour l'analyse d'images médicales:

```python
from tensorflow.keras.applications import ResNet50
from tensorflow.keras.preprocessing import image

# Modèle pré-entraîné
cnn_model = ResNet50(weights='imagenet')

def analyze_medical_image(img_path):
    # Prétraitement
    img = image.load_img(img_path, target_size=(224, 224))
    x = image.img_to_array(img)
    x = np.expand_dims(x, axis=0)
    # Prédiction
    prediction = cnn_model.predict(x)
    return prediction
```

## 🔐 Sécurité

⚠️ **Important** : Ce service est un PROTOTYPE à des fins éducatives.

Pour un usage en production:
- Ajouter une authentification (JWT, API Key)
- Implémenter un rate limiting
- Valider et nettoyer toutes les entrées
- Utiliser HTTPS
- Ajouter des logs et monitoring
- Conformité RGPD pour les données médicales

## 📚 Documentation

- [Flask Documentation](https://flask.palletsprojects.com/)
- [TensorFlow Guide](https://www.tensorflow.org/guide)
- [Keras API](https://keras.io/api/)

## 📄 Licence

Ce projet est à des fins éducatives uniquement.
