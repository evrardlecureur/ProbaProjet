# 📊 Exploration en Probabilités et Statistiques : Autour de la Régression Linéaire

## 🎯 Contexte et Objectif
Ce projet d'une semaine est une exploration pratique des fondements et des limites de la régression linéaire. À partir d'un jeu de données simulé et fixé sous R, l'objectif est de tester les limites de la méthode des moindres carrés ordinaires (MCO) face à des perturbations du bruit et de chercher des solutions par changement de variables lorsque la relation devient polynomiale.

---

## 👥 L'Équipe et Répartition des Rôles

### 🛠️ Evrard (Planification & Structure)
* **Partie 1 - Gestion du Dépôt :** Initialisation du GitHub, rédaction et mise à jour du `README.md`, organisation de l'architecture des dossiers.
* **Partie 2 - Planification & Coordination :** Distribution des tâches, définition du calendrier interne, suivi des avancées de l'équipe et structuration logique du rapport final.

### 📈 Romain (Modélisation de Base & Crash-Test)
* Génération du jeu de données initial (`set.seed()`, `runif()`) et ajustement de la régression linéaire simple idéale.
* Implémentation des scénarios de dégradation : introduction d'un bruit non centré et d'une variance non constante (hétéroscédasticité).
* Génération des premiers graphiques de diagnostic pour l'analyse des résidus standardisés.

### 📐 Thibaud (Transformations & Modèles Avancés)
* Étude et implémentation du changement de variable pour linéariser et résoudre le modèle $aX^2+b$.
* Exploration empirique du modèle quadratique complet $aX^2+bX+c$ (analyse de ce que l'on peut faire et ne pas faire).
* Comparaison des résidus standardisés entre les modèles polynomiaux et le modèle linéaire simple.

---

## 🗺️ Feuille de Route Exploratoire

### Étape 1 : Le Socle (Génération des Données)
* Fixation de la graine via `set.seed()` pour garantir un jeu de données unique et reproductible sur toute la durée du projet.
* Génération de la variable explicative avec $n$ observations via `runif(n, li, la)`.

### Étape 2 : Le Scénario Idéal
* Ajout d'un bruit gaussien centré et homoscédastique.
* Ajustement du modèle linéaire par la méthode des moindres carrés ordinaires.

### Étape 3 : Le Crash-Test (Dégradation des Hypothèses)
* Simulation d'un biais systématique (bruit non centré).
* Simulation d'une instabilité de la variance (variance non constante).
* Identification des impacts visuels et mathématiques sur les résidus standardisés.

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
