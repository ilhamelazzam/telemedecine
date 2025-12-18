"""
Service IA pour l'analyse de symptômes et d'images médicales
Architecture: Flask REST API avec TensorFlow/Keras

Endpoints:
- POST /api/ai/analyze-symptoms : Analyse de texte (ML)
- POST /api/ai/analyze-image : Analyse d'image (CNN)
"""

from flask import Flask, request, jsonify
from flask_cors import CORS
import numpy as np
import pickle
import os
from datetime import datetime
from io import BytesIO
from PIL import Image
import tensorflow as tf
from tensorflow.keras.models import load_model
from tensorflow.keras.preprocessing import image as keras_image
from tensorflow.keras.applications.mobilenet_v2 import preprocess_input

app = Flask(__name__)
CORS(app)  # Autoriser les requêtes cross-origin

# Chemins des modèles
BASE_DIR = os.path.dirname(os.path.abspath(__file__))
ML_MODEL_PATH = os.path.join(BASE_DIR, 'models', 'model.pkl')
CNN_MODEL_PATH = os.path.join(BASE_DIR, 'models', 'mobilenetv2_model.h5')

# ============================================
# Modèle ML pour l'analyse de symptômes
# ============================================

class SymptomAnalyzer:
    """Analyseur de symptômes utilisant le modèle ML pickle"""
    
    def __init__(self, model_path):
        self.model = None
        self.model_loaded = False
        
        # Charger le modèle ML
        try:
            if os.path.exists(model_path):
                with open(model_path, 'rb') as f:
                    self.model = pickle.load(f)
                self.model_loaded = True
                print(f"✅ Modèle ML chargé depuis: {model_path}")
            else:
                print(f"⚠️ Modèle ML non trouvé: {model_path}")
                print("   Utilisation du mode fallback (règles)")
        except Exception as e:
            print(f"❌ Erreur lors du chargement du modèle ML: {e}")
            print("   Utilisation du mode fallback (règles)")
        
        # Base de connaissances de secours
        self.knowledge_base = {
            'respiratoire': {
                'symptoms': ['toux', 'essoufflement', 'respiration', 'gorge', 'nez', 'rhume'],
                'diagnosis': 'Infection respiratoire possible',
                'severity': 'modéré',
                'recommendations': [
                    'Repos et hydratation',
                    'Surveiller la température',
                    'Consulter si aggravation'
                ]
            },
            'digestif': {
                'symptoms': ['nausée', 'vomissement', 'diarrhée', 'ventre', 'estomac', 'abdomen'],
                'diagnosis': 'Trouble digestif',
                'severity': 'faible',
                'recommendations': [
                    'Diète légère',
                    'Hydratation importante',
                    'Consulter si persistance > 48h'
                ]
            },
            'neurologique': {
                'symptoms': ['mal de tête', 'migraine', 'vertige', 'étourdissement', 'tête'],
                'diagnosis': 'Symptôme neurologique',
                'severity': 'modéré',
                'recommendations': [
                    'Repos dans un endroit calme',
                    'Éviter les écrans',
                    'Consulter si douleur intense'
                ]
            },
            'musculaire': {
                'symptoms': ['douleur', 'muscle', 'articulation', 'dos', 'courbature'],
                'diagnosis': 'Douleur musculaire ou articulaire',
                'severity': 'faible',
                'recommendations': [
                    'Repos de la zone affectée',
                    'Application de chaleur/froid',
                    'Consulter si douleur persistante'
                ]
            },
            'fevr e': {
                'symptoms': ['fièvre', 'température', 'chaud', 'froid', 'frisson'],
                'diagnosis': 'État fébrile - Infection possible',
                'severity': 'élevé',
                'recommendations': [
                    'Prendre la température régulièrement',
                    'Hydratation importante',
                    'Consulter un médecin rapidement'
                ]
            },
            'allergique': {
                'symptoms': ['éternuement', 'démangeaison', 'allergie', 'rougeur', 'gonflement'],
                'diagnosis': 'Réaction allergique possible',
                'severity': 'modéré',
                'recommendations': [
                    'Identifier et éviter l\'allergène',
                    'Antihistaminique si nécessaire',
                    'Urgence si difficultés respiratoires'
                ]
            },
        }
    
    def analyze(self, symptoms_text):
        """Analyse le texte des symptômes avec le modèle ML ou fallback"""
        
        # Si le modèle est chargé, l'utiliser
        if self.model_loaded and self.model is not None:
            try:
                # Préparer les données pour le modèle
                # Adapter selon votre preprocessing
                prediction = self._predict_with_model(symptoms_text)
                return prediction
            except Exception as e:
                print(f"⚠️ Erreur prédiction ML: {e}, utilisation fallback")
                # Continuer avec la méthode de secours
        
        # Méthode de secours basée sur des règles
        symptoms_lower = symptoms_text.lower()
        
        # Compter les correspondances pour chaque catégorie
        matches = {}
        for category, data in self.knowledge_base.items():
            count = sum(1 for symptom in data['symptoms'] if symptom in symptoms_lower)
            if count > 0:
                matches[category] = {
                    'count': count,
                    'diagnosis': data['diagnosis'],
                    'severity': data['severity'],
                    'recommendations': data['recommendations']
                }
        
        # Trouver la meilleure correspondance
        if not matches:
            return {
                'diagnosis': 'Symptômes non spécifiques',
                'severity': 'indéterminé',
                'confidence': 0.3,
                'recommendations': [
                    'Décrire les symptômes plus en détail',
                    'Consulter un professionnel de santé',
                    'Surveiller l\'évolution'
                ],
                'categories_detected': [],
                'model_used': 'fallback'
            }
        
        # Tri par nombre de correspondances
        best_match = max(matches.items(), key=lambda x: x[1]['count'])
        category_name = best_match[0]
        category_data = best_match[1]
        
        # Calcul de la confiance basé sur le nombre de correspondances
        confidence = min(0.5 + (category_data['count'] * 0.15), 0.95)
        
        return {
            'diagnosis': category_data['diagnosis'],
            'severity': category_data['severity'],
            'confidence': round(confidence, 2),
            'recommendations': category_data['recommendations'],
            'categories_detected': list(matches.keys()),
            'model_used': 'fallback'
        }
    
    def _predict_with_model(self, symptoms_text):
        """Prédiction avec le modèle ML chargé"""
        # TODO: Adapter selon votre preprocessing et format de données
        # Exemple basique:
        # features = vectorize_text(symptoms_text)
        # prediction = self.model.predict([features])
        
        # Pour l'instant, retourner un placeholder
        # Vous devrez adapter cette fonction selon votre modèle
        return {
            'diagnosis': 'Diagnostic ML - À implémenter',
            'severity': 'modéré',
            'confidence': 0.75,
            'recommendations': [
                'Résultat du modèle ML',
                'Consulter un professionnel de santé'
            ],
            'categories_detected': [],
            'model_used': 'ml_pickle'
        }


# ============================================
# Modèle CNN pour l'analyse d'images
# ============================================

class ImageAnalyzer:
    """Analyseur d'images médicales utilisant MobileNetV2"""
    
    def __init__(self, model_path):
        self.model = None
        self.model_loaded = False
        self.img_size = (224, 224)  # Taille standard MobileNetV2
        
        # Charger le modèle CNN
        try:
            if os.path.exists(model_path):
                self.model = load_model(model_path)
                self.model_loaded = True
                print(f"✅ Modèle CNN MobileNetV2 chargé depuis: {model_path}")
                
                # Afficher l'architecture du modèle
                print(f"   Input shape: {self.model.input_shape}")
                print(f"   Output shape: {self.model.output_shape}")
            else:
                print(f"⚠️ Modèle CNN non trouvé: {model_path}")
                print("   Utilisation du mode fallback (simulation)")
        except Exception as e:
            print(f"❌ Erreur lors du chargement du modèle CNN: {e}")
            print("   Utilisation du mode fallback (simulation)")
        
        # Classes de prédiction (à adapter selon votre modèle)
        self.class_labels = [
            'Normal',
            'Anomalie légère',
            'Anomalie modérée',
            'Anomalie sévère'
        ]
    
    def analyze(self, image_data):
        """Analyse une image médicale"""
        
        # Si le modèle est chargé, l'utiliser
        if self.model_loaded and self.model is not None:
            try:
                prediction = self._predict_with_cnn(image_data)
                return prediction
            except Exception as e:
                print(f"⚠️ Erreur prédiction CNN: {e}, utilisation fallback")
                # Continuer avec la simulation
        
        # Mode fallback (simulation)
        import random
        conditions = [
            'Peau normale - Pas d\'anomalie détectée',
            'Possibilité d\'inflammation légère',
            'Zone suspecte détectée - Consultation recommandée',
            'Pas d\'anomalie visible',
        ]
        
        diagnosis = random.choice(conditions)
        confidence = round(random.uniform(0.70, 0.95), 2)
        
        return {
            'diagnosis': diagnosis,
            'confidence': confidence,
            'recommendations': [
                'Image analysée par IA - Non diagnostic médical',
                'Consulter un professionnel pour confirmation',
                'Surveiller l\'évolution'
            ],
            'requires_medical_attention': confidence > 0.85 and 'suspecte' in diagnosis,
            'model_used': 'fallback'
        }
    
    def _predict_with_cnn(self, image_data):
        """Prédiction avec le modèle CNN MobileNetV2"""
        # Charger et prétraiter l'image
        if isinstance(image_data, str):
            # Si c'est un chemin de fichier
            img = keras_image.load_img(image_data, target_size=self.img_size)
        else:
            # Si c'est un objet fichier
            img = Image.open(image_data)
            img = img.resize(self.img_size)
        
        # Convertir en array et prétraiter
        img_array = keras_image.img_to_array(img)
        img_array = np.expand_dims(img_array, axis=0)
        img_array = preprocess_input(img_array)
        
        # Prédiction
        predictions = self.model.predict(img_array, verbose=0)
        
        # Interpréter les résultats
        if len(predictions[0]) > 1:
            # Classification multi-classes
            predicted_class_idx = np.argmax(predictions[0])
            confidence = float(predictions[0][predicted_class_idx])
            
            if predicted_class_idx < len(self.class_labels):
                diagnosis = self.class_labels[predicted_class_idx]
            else:
                diagnosis = f"Classe {predicted_class_idx}"
        else:
            # Classification binaire
            confidence = float(predictions[0][0])
            diagnosis = 'Anomalie détectée' if confidence > 0.5 else 'Normal'
        
        # Générer des recommandations basées sur la prédiction
        if 'Normal' in diagnosis or confidence < 0.6:
            recommendations = [
                'Aucune anomalie significative détectée',
                'Surveillance régulière recommandée',
                'Consulter si symptômes apparaissent'
            ]
            requires_attention = False
        elif confidence < 0.8:
            recommendations = [
                'Anomalie légère possible détectée',
                'Surveillance accrue recommandée',
                'Consulter un professionnel si aggravation'
            ]
            requires_attention = False
        else:
            recommendations = [
                'Anomalie détectée avec forte confiance',
                'Consultation médicale fortement recommandée',
                'Ne pas négliger ce résultat'
            ]
            requires_attention = True
        
        return {
            'diagnosis': diagnosis,
            'confidence': round(confidence, 2),
            'recommendations': recommendations,
            'requires_medical_attention': requires_attention,
            'model_used': 'mobilenetv2_cnn',
            'all_predictions': {
                self.class_labels[i]: float(predictions[0][i])
                for i in range(min(len(predictions[0]), len(self.class_labels)))
            } if len(predictions[0]) > 1 else None
        }


# Initialiser les analyseurs
symptom_analyzer = SymptomAnalyzer()
image_analyzer = ImageAnalyzer()


# ============================================
# Routes API
# ============================================

@app.route('/health', methods=['GET'])
def health_check():
    """Vérification de l'état du service"""
    return jsonify({
        'status': 'healthy',
        'service': 'AI Analysis Service',
        'version': '1.0.0',
        'timestamp': datetime.now().isoformat()
    })


@app.route('/api/ai/analyze-symptoms', methods=['POST'])
def analyze_symptoms():
    """
    Analyse des symptômes textuels
    
    Body JSON:
    {
        "symptoms": "J'ai mal à la tête et de la fièvre",
        "categories": ["Neurologique", "Général"] (optionnel)
    }
    """
    try:
        data = request.get_json()
        
        if not data or 'symptoms' not in data:
            return jsonify({
                'error': 'Le champ "symptoms" est requis'
            }), 400
        
        symptoms = data.get('symptoms', '')
        categories = data.get('categories', [])
        
        if not symptoms.strip():
            return jsonify({
                'error': 'Les symptômes ne peuvent pas être vides'
            }), 400
        
        # Analyser les symptômes
        result = symptom_analyzer.analyze(symptoms)
        
        # Ajouter des métadonnées
        result['timestamp'] = datetime.now().isoformat()
        result['model_version'] = 'ML-v1.0'
        result['input_categories'] = categories
        
        return jsonify(result), 200
        
    except Exception as e:
        return jsonify({
            'error': f'Erreur lors de l\'analyse: {str(e)}'
        }), 500


@app.route('/api/ai/analyze-image', methods=['POST'])
def analyze_image():
    """
    Analyse d'image médicale
    
    Body: multipart/form-data avec 'image' file
    Ou JSON avec 'imageUrl' ou 'imageBase64'
    """
    try:
        # Vérifier si c'est un fichier ou des données JSON
        if request.files and 'image' in request.files:
            image_file = request.files['image']
            # Dans une vraie application, traiter l'image ici
            result = image_analyzer.analyze(image_file)
            
        elif request.is_json:
            data = request.get_json()
            if 'imageUrl' in data or 'imageBase64' in data:
                # Simuler l'analyse
                result = image_analyzer.analyze(data)
            else:
                return jsonify({
                    'error': 'Image requise (file, imageUrl ou imageBase64)'
                }), 400
        else:
            return jsonify({
                'error': 'Format de requête invalide'
            }), 400
        
        # Ajouter des métadonnées
        result['timestamp'] = datetime.now().isoformat()
        result['model_version'] = 'CNN-v1.0'
        
        return jsonify(result), 200
        
    except Exception as e:
        return jsonify({
            'error': f'Erreur lors de l\'analyse d\'image: {str(e)}'
        }), 500


@app.route('/api/ai/models/info', methods=['GET'])
def models_info():
    """Informations sur les modèles IA disponibles"""
    return jsonify({
        'models': {
            'symptom_analyzer': {
                'type': 'ML - Rule-based',
                'version': '1.0',
                'categories': list(symptom_analyzer.knowledge_base.keys()),
                'status': 'active'
            },
            'image_analyzer': {
                'type': 'CNN - Simulated',
                'version': '1.0',
                'input': 'Images médicales',
                'status': 'active (demo mode)'
            }
        },
        'capabilities': [
            'Analyse de symptômes textuels',
            'Analyse d\'images médicales',
            'Recommandations personnalisées',
            'Niveau de confiance des prédictions'
        ]
    })


# ============================================
# Démarrage du serveur
# ============================================

if __name__ == '__main__':
    print("=" * 60)
    print("🤖 Service IA - Télémédecine")
    print("=" * 60)
    print("Port: 5000")
    print("Endpoints:")
    print("  - GET  /health")
    print("  - POST /api/ai/analyze-symptoms")
    print("  - POST /api/ai/analyze-image")
    print("  - GET  /api/ai/models/info")
    print("=" * 60)
    
    app.run(
        host='0.0.0.0',  # Accessible depuis n'importe quelle IP
        port=5000,
        debug=True
    )
