# Projet Régression Linéaire - Polytech Nice Sophia MAM3

## Contexte et objectif

Ce projet explore la régression linéaire sur un jeu de données réelles. L'objectif est d'expliquer une variable réponse à l'aide de modèles linéaires en justifiant chaque choix de modélisation.

**Particularité :** le projet est réalisé en deux temps. D'abord par les étudiants seuls (niveau bac+3), puis avec assistance IA. Chaque section du rapport comporte un paragraphe dédié comparant les deux approches.

---

## Répartition des rôles

### Evrard - Coordination + Sélection de variables

- Structure du dépôt, coordination de l'équipe, calendrier
- Génération et documentation des données simulées (`jeudonnées.R`)
- **Sélection de variables :** méthode exhaustive (comparaison des 2^p modèles par R²_a), méthodes pas à pas (forward, backward, stepwise)
- Rédaction des sections correspondantes du rapport

### Romain - Régression linéaire simple

- **Modélisation de base :** ajustement MCO, estimation de â et b̂, droite de régression
- **Inférence statistique :** test H0 : a = 0 via statistique de Student, région de rejet, p-valeur
- **Vérification des hypothèses :** résidus standardisés, graphique QQ-plot, test de Kolmogorov-Smirnov sur les résidus studentisés
- **Prédiction :** intervalles de confiance pour une nouvelle observation
- Rédaction des sections correspondantes du rapport

### Thibaud - Régression multiple, polynomiale et ANOVA

- **Régression multiple :** formulation matricielle Y = Xβ + U, estimateur (X'X)^{-1}X'Y, R² ajusté, test de Fisher global, tests individuels sur les βk
- **Régression polynomiale :** modèles aX² + b et aX² + bX + c comme cas particuliers de régression multiple, inférence sur chaque coefficient
- **ANOVA à un facteur :** connexion entre ANOVA et régression linéaire avec variable qualitative
- Rédaction des sections correspondantes du rapport

---

## Convention rapport - Comparaison IA / étudiant

Dans chaque section du rapport, la structure est la suivante :

1. **Approche étudiant (bac+3)** : démarche manuelle, interprétation des sorties R, raisonnement statistique classique
2. **Apport de l'IA** : ce que l'IA fait en plus ou différemment (automatisation, diagnostics avancés, choix de modèle, interprétations supplémentaires...)

L'objectif est de montrer concrètement ce que l'IA apporte par rapport à un travail d'étudiant de niveau bac+3 sur chacun des points traités.

---

## Roadmap

### Etape 1 - Exploration des données (tous)

- Chargement des jeux de données réels
- Choix de la variable réponse et des variables explicatives candidates
- Statistiques descriptives, matrices de corrélation, visualisations préliminaires

### Etape 2 - Régression linéaire simple (Romain)

- Ajustement `lm()` et lecture du `summary()`
- Graphique nuage de points + droite ajustée
- Test de Student sur la pente + graphique de la région de rejet sous la loi de Student
- Analyse des résidus : graphique résidus vs valeurs ajustées, détection d'hétéroscédasticité
- QQ-plot des résidus studentisés + test de Kolmogorov-Smirnov
- Intervalle de confiance pour la prédiction d'une nouvelle observation

### Etape 3 - Régression multiple, polynomiale et ANOVA (Thibaud)

- Extension au cas p variables explicatives, formulation matricielle
- R² ajusté et test de Fisher global
- Régression polynomiale : ajustement de aX² + b puis aX² + bX + c, comparaison des modèles
- ANOVA à un facteur : connexion avec la régression linéaire via variable indicatrice

### Etape 4 - Sélection de variables (Evrard)

- Calcul du R²_a pour l'ensemble des 2^p sous-modèles possibles
- Identification du modèle optimal
- Comparaison avec les méthodes pas à pas (forward, backward, stepwise) via critère AIC

### Etape 5 - Rapport final (tous)

- Rédaction en LaTeX (`rapport.tex`)
- Intégration des graphiques produits sous R
- Paragraphes de comparaison IA / étudiant dans chaque section
- Relecture croisée et cohérence globale

---

## Structure du dépôt

```
/
├── jeudonnées.R          # Génération des données simulées (Evrard)
├── rapport.tex           # Rapport LaTeX
├── script/
│   ├── script_romain.R   # Régression simple, inférence, résidus (Romain)
│   ├── script_thibaud.R  # Régression multiple, polynomiale, ANOVA (Thibaud)
│   └── script_evrard.R   # Sélection de variables (Evrard)
└── data/
    ├── donnees_lineaires.csv
    └── donnees_polynomiales.csv
```