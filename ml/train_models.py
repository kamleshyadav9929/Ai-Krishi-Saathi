import sys
import os
import json
import csv
import numpy as np
from sklearn.model_selection import train_test_split, cross_val_score
from sklearn.ensemble import RandomForestClassifier, GradientBoostingClassifier
from sklearn.metrics import accuracy_score, classification_report, precision_recall_fscore_support
import joblib

if hasattr(sys.stdout, 'reconfigure'):
    sys.stdout.reconfigure(encoding='utf-8')

os.makedirs("ml/models", exist_ok=True)

def train_crop_recommender():
    print("--- 1. Training Crop Recommendation ML Model ---")
    data_path = "data/datasets/crop_recommendation.csv"
    
    X = []
    y = []
    crops_map = {}
    
    with open(data_path, "r", encoding="utf-8") as f:
        reader = csv.DictReader(f)
        for row in reader:
            features = [
                float(row["N"]),
                float(row["P"]),
                float(row["K"]),
                float(row["temperature"]),
                float(row["humidity"]),
                float(row["ph"]),
                float(row["rainfall"])
            ]
            X.append(features)
            crop_name = row["label"]
            if crop_name not in crops_map:
                crops_map[crop_name] = len(crops_map)
            y.append(crops_map[crop_name])
            
    X = np.array(X)
    y = np.array(y)
    
    X_train, X_test, y_train, y_test = train_test_split(
        X, y, test_size=0.2, random_state=42, stratify=y
    )
    
    # Train Random Forest Classifier
    rf_model = RandomForestClassifier(n_estimators=100, max_depth=12, random_state=42)
    rf_model.fit(X_train, y_train)
    
    # Cross validation score
    cv_scores = cross_val_score(rf_model, X, y, cv=5)
    
    # Evaluation on holdout test set
    y_pred = rf_model.predict(X_test)
    test_accuracy = accuracy_score(y_test, y_pred)
    precision, recall, f1, _ = precision_recall_fscore_support(y_test, y_pred, average="weighted")
    
    inv_crops_map = {v: k for k, v in crops_map.items()}
    
    print(f"Dataset Size: {len(X)} records across {len(crops_map)} Indian crops")
    print(f"5-Fold Cross-Validation Accuracy: {cv_scores.mean() * 100:.2f}% (+/- {cv_scores.std() * 100:.2f}%)")
    print(f"Holdout Test Accuracy: {test_accuracy * 100:.2f}%")
    print(f"Weighted Precision: {precision:.4f} | Recall: {recall:.4f} | F1-Score: {f1:.4f}")
    
    # Save scikit-learn model
    joblib_path = "ml/models/crop_recommender.joblib"
    joblib.dump({
        "model": rf_model,
        "crops_map": crops_map,
        "features": ["N", "P", "K", "temperature", "humidity", "ph", "rainfall"]
    }, joblib_path)
    print(f"Saved trained model to {joblib_path}")
    
    # Save inference metadata for mobile Flutter app
    meta_path = "ml/models/crop_model_metadata.json"
    metadata = {
        "modelName": "RandomForest-CropRecommender-v1",
        "accuracy": round(float(test_accuracy), 4),
        "f1Score": round(float(f1), 4),
        "cvAccuracyMean": round(float(cv_scores.mean()), 4),
        "crops": crops_map,
        "featureOrder": ["N", "P", "K", "temperature", "humidity", "ph", "rainfall"],
        "featureImportances": {
            feat: round(float(imp), 4)
            for feat, imp in zip(["N", "P", "K", "temperature", "humidity", "ph", "rainfall"], rf_model.feature_importances_)
        }
    }
    with open(meta_path, "w", encoding="utf-8") as f:
        json.dump(metadata, f, indent=2)
    print(f"Saved model metadata & feature importances to {meta_path}\n")
    return metadata

def train_disease_classifier():
    print("--- 2. Training Crop Disease Diagnostic ML Model ---")
    disease_data_path = "data/datasets/crop_disease_dataset.json"
    with open(disease_data_path, "r", encoding="utf-8") as f:
        diseases = json.load(f)
        
    # Synthesize disease diagnostic feature training cases based on pathogen triggers
    # Features: [temp, humidity, is_lower_leaf, has_concentric_rings, has_white_pustules, has_spindle_lesions, is_yellow_powder]
    np.random.seed(42)
    X_dis = []
    y_dis = []
    disease_labels = [d["diseaseName"] for d in diseases]
    
    for idx, d in enumerate(diseases):
        temp_min, temp_max = d["tempRangeCelsius"]
        hum_min = d["humidityMinPercent"]
        shape = d["lesionShape"].lower()
        pos = d["leafPosition"].lower()
        color = d["color"].lower()
        
        for _ in range(60): # 60 synthetic variations per authentic clinical disease
            t = np.random.uniform(temp_min - 2, temp_max + 2)
            h = np.random.uniform(hum_min - 5, min(99, hum_min + 15))
            lower_leaf = 1.0 if "lower" in pos or "stem base" in pos else (0.0 if np.random.rand() > 0.1 else 1.0)
            concentric = 1.0 if "concentric" in shape else 0.0
            white_pustule = 1.0 if "chalk-white" in shape or "white" in color else 0.0
            spindle = 1.0 if "spindle" in shape or "eye" in shape else 0.0
            yellow_powder = 1.0 if "yellow" in color or "stripes" in shape else 0.0
            
            # Add slight sensor noise
            X_dis.append([t, h, lower_leaf, concentric, white_pustule, spindle, yellow_powder])
            y_dis.append(idx)
            
    X_dis = np.array(X_dis)
    y_dis = np.array(y_dis)
    
    X_tr, X_te, y_tr, y_te = train_test_split(X_dis, y_dis, test_size=0.25, random_state=42, stratify=y_dis)
    
    clf = RandomForestClassifier(n_estimators=80, max_depth=8, random_state=42)
    clf.fit(X_tr, y_tr)
    
    y_pr = clf.predict(X_te)
    acc = accuracy_score(y_te, y_pr)
    
    print(f"Disease Diagnostic Model Accuracy: {acc * 100:.2f}%")
    
    joblib_path = "ml/models/disease_classifier.joblib"
    joblib.dump({"model": clf, "classes": disease_labels}, joblib_path)
    print(f"Saved trained disease classifier to {joblib_path}")
    
    metrics = {
        "diseaseClassifierAccuracy": round(float(acc), 4),
        "totalDiseases": len(disease_labels),
        "classes": disease_labels
    }
    with open("ml/models/disease_model_metrics.json", "w", encoding="utf-8") as f:
        json.dump(metrics, f, indent=2)
    print("Saved disease model metrics to ml/models/disease_model_metrics.json")

if __name__ == "__main__":
    train_crop_recommender()
    train_disease_classifier()
    print("All ML models trained and validated successfully!")
