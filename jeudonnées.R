## géneration du jeu de données 
set.seed(1)
## on va faire plusierus jeu de données pour mettre en évidences les différences 

n  <- 1000    # Nombre d'observations
li <- 0      # Limite inférieure du support
la <- 10     # Limite supérieure du support

X <- runif(n, min = li, max = la)

a_réel <- 5
b_réel <- 5
f_réel <- a_réel * X + b_réel

# on passe a la création des bruits 

# bruit centré a variance constante ( sd = 1)
b_centré <- rnorm(n,mean=0, sd = 1)
# bruit non centré ( mean = 1) a variance constante ( sd = 1)
b_n_centré <- rnorm(n,mean=1, sd = 1)
# bruit centré a variance non constante ( sd = X*2)
b_centré_variance_n_const <- rnorm(n,mean=0, sd = X*2)
# bruit non centré a variance non constante ( sd = X*2)
b_n_centré_variance_n_const <- rnorm(n, mean = 1, sd = 0.5 * X)

## faire le data frame 

df_lineaire <- data.frame(
  X = X,
  Y_ideal      = signal_lineaire + bruit_ideal,
  Y_non_centre = signal_lineaire + bruit_non_centre,
  Y_hetero     = signal_lineaire + bruit_hetero,
  Y_pire       = signal_lineaire + bruit_pire
)

## le cas avec les trucs pas linéaire 


c_réel <- -1

# Modèle aX^2 + b
Y_quadra_simple <- a_réel * (X^2) + b_réel + b_centré

# Modèle aX^2 + bX + c
Y_poly_complet  <- a_réel * (X^2) + b_réel * X + c_réel + b_centré

df_polynomial <- data.frame(
  X = X,
  Y_quadra_simple = Y_quadra_simple,
  Y_poly_complet  = Y_poly_complet
)

if(!dir.exists("data")) dir.create("data")

write.csv(df_lineaire, "data/donnees_lineaires.csv", row.names = FALSE)
write.csv(df_polynomial, "data/donnees_polynomiales.csv", row.names = FALSE)

cat("Génération finie")



