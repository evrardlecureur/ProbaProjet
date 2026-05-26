# 📊 Exploration en Probabilités et Statistiques : Autour de la Régression Linéaire

## 🎯 Contexte et Objectif
Ce projet d'une semaine est une exploration pratique des fondements et des limites de la régression linéaire. Plutôt que d'appliquer aveuglément des formules, notre objectif est de simuler nos propres données en R, de tester les limites de la méthode des moindres carrés ordinaires (MCO), et de chercher des solutions par changement de variables lorsque la relation n'est plus strictement linéaire.

## 👥 L'Équipe
* **Evrard** : Planification, coordination des expérimentations et structure du projet.
* **Romain** : (Rôle à préciser)
* **Thibaud** : (Rôle à préciser)

---

## 🗺️ Feuille de Route Exploratoire (Étape par Étape)

### Étape 1 : Le Socle (Génération des Données)
Notre première mission est de construire un environnement de test fiable et reproductible.
* **Support R** : Utilisation stricte de la fonction `set.seed()` pour figer le jeu de données sur toute la durée du projet.
* **Variables explicatives** : Génération de $n$ observations via un tirage uniforme `runif(n, li, la)`. (Valeurs de $n$, `li` et `la` à définir par l'équipe).

### Étape 2 : Le Scénario Idéal (Régression Linéaire Simple)
Nous allons d'abord tester la théorie dans les meilleures conditions possibles.
* Ajout d'un bruit gaussien parfaitement centré et de variance constante (Homoscédasticité).
* Résolution et ajustement du modèle via la méthode des moindres carrés.
* Extraction et première analyse des résidus standardisés.

### Étape 3 : Le Crash-Test (Dégradation des Hypothèses)
C'est ici que l'exploration commence réellement. Nous allons volontairement "casser" les hypothèses de base pour observer le comportement de notre modèle.
* **Bruit non centré** : Que se passe-t-il si l'erreur systématique n'est pas nulle ?
* **Hétéroscédasticité** : Introduction d'une variance non constante dans le bruit.
* **Diagnostic** : Comment ces dégradations se traduisent-elles visuellement et mathématiquement sur nos résidus standardisés ? Qu'est-ce qu'on ne doit absolument pas faire dans ces cas-là ?

### Étape 4 : Sortir de la Ligne (Transformations Polynomiales)
La réalité n'est pas toujours une droite. Nous allons générer de nouvelles relations et tenter de les résoudre avec nos outils linéaires.
* **Modèle $aX^2+b$** : Recherche du bon changement de variable pour se ramener à une équation linéaire soluble par les MCO.
* **Modèle $aX^2+bX+c$** : Tests, ajustements et limites de la linéarisation sur un polynôme de degré 2 complet. Ce qui fonctionne, et ce qui est à éviter.

### Étape 5 : Synthèse et Rapport
* Rédaction d'un rapport linéaire et argumenté qui retrace notre parcours, nos échecs instructifs et nos réussites.
* Mise en relation des graphiques générés sous R avec la théorie statistique.

---

## 🛠️ Exécution du Code
(Instructions à venir pour lancer les scripts R du projet...)
