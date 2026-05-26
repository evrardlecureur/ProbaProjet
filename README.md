# 📊 Exploration en Probabilités et Statistiques : Autour de la Régression Linéaire

## 🎯 Contexte et Objectif
Ce projet d'une semaine est une exploration pratique des fondements et des limites de la régression linéaire. À partir d'un jeu de données simulé et fixé sous R, l'objectif est de tester les limites de la méthode des moindres carrés ordinaires (MCO) face à des perturbations du bruit et de chercher des solutions par changement de variables lorsque la relation devient polynomiale.

---

## 👥 L'Équipe et Répartition des Rôles

### 🛠️ Evrard (Planification & Structure)
* **Partie 1 - Gestion du Dépôt :** Initialisation du GitHub, rédaction et mise à jour du `README.md`, organisation de l'architecture des dossiers.
* **Partie 2 - Planification & Coordination :** Distribution des tâches, définition du calendrier interne, suivi des avancées de l'équipe et structuration logique du rapport final.

### 📈 Romain (Modélisation de Base & Crash-Test)
* Génération du jeu de données initial et ajustement de la régression linéaire simple.
* **Inférence statistique :** Estimation des écarts-types des estimateurs ($\hat{a}$ et $\hat{b}$), calcul des t-statistiques, définition des régions de rejet et analyse des p-values pour le test de nullité de la pente ($H_0: a = 0$).
* **Crash-Test :** Observer comment un bruit non centré ou hétéroscédastique fausse les p-values et déplace la région de rejet (le risque d'erreur de type I).

### 📐 Thibaud (Transformations & Modèles Avancés)
* Implémentation et linéarisation du modèle $aX^2+b$ et du polynôme complet $aX^2+bX+c$.
* **Inférence multi-paramètres :** Analyse des p-values pour chaque coefficient (est-ce que le terme en $X^2$ apporte un vrai plus par rapport au terme en $X$ ?).

---

## 🗺️ Feuille de Route Exploratoire

### Étape 1 : Le Socle (Génération des Données)
* Fixation de la graine via `set.seed()` pour garantir un jeu de données unique et reproductible sur toute la durée du projet.
* Génération de la variable explicative avec $n$ observations via `runif(n, li, la)`.

### Étape 2 : Le Scénario Idéal (Régression Linéaire Simple)
* Ajout d'un bruit gaussien centré et homoscédastique.
* Ajustement du modèle par les moindres carrés.
* **Validation Statistique :** Analyse du sommaire du modèle (`summary(lm(...))`). Étude de la p-value associée au coefficient $a$. Si p-value < 5% (seuil classique), rejet de $H_0: a=0$, la pente est statistiquement significative.
* Graphique de la région de rejet sous la distribution de Student.

### Étape 3 : Le Crash-Test (Dégradation des Hypothèses)
* Simulation d'un biais (bruit non centré) et d'hétéroscédasticité.
* **Impact sur l'inférence :** Analyser comment ces violations d'hypothèses biaisent les estimateurs et rendent les p-values trompeuses (par exemple, rejeter $H_0$ à tort alors que le modèle est mauvais).

### Étape 4 : Sortir de la Ligne (Transformations)
* Application d'un changement de variable pour ramener le modèle $aX^2+b$ à une forme linéaire.
* Tentatives d'ajustement et limites de la linéarisation sur le polynôme complet $aX^2+bX+c$.

### Étape 5 : Synthèse et Rapport
* Compilation des codes R et des graphiques de résidus.
* Rédaction d'un rapport argumenté présentant nos observations et nos conclusions sur les pièges à éviter.

---

## 📂 Structure du Dépôt
* `/scripts/` : Scripts R (génération de données, modèles, graphiques).
* `/rapport/` : Documentation et rédaction du rapport final.
