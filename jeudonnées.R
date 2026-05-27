set.seed(1)

n  <- 1000
li <- 0
la <- 10

X <- runif(n, min = li, max = la)

a_reel <- 5
b_reel <- 5
signal_lineaire <- a_reel * X + b_reel

bruit_ideal       <- rnorm(n, mean = 0, sd = 1)
bruit_non_centre  <- rnorm(n, mean = 1, sd = 1)
bruit_hetero      <- rnorm(n, mean = 0, sd = X * 2)
bruit_pire        <- rnorm(n, mean = 1, sd = 0.5 * X)

df_lineaire <- data.frame(
  X            = X,
  Y_ideal      = signal_lineaire + bruit_ideal,
  Y_non_centre = signal_lineaire + bruit_non_centre,
  Y_hetero     = signal_lineaire + bruit_hetero,
  Y_pire       = signal_lineaire + bruit_pire
)

c_reel <- -1

df_polynomial <- data.frame(
  X               = X,
  Y_quadra_simple = a_reel * X^2 + b_reel + bruit_ideal,
  Y_poly_complet  = a_reel * X^2 + b_reel * X + c_reel + bruit_ideal
)

if (!dir.exists("data")) dir.create("data")

write.csv(df_lineaire,   "data/donnees_lineaires.csv",   row.names = FALSE)
write.csv(df_polynomial, "data/donnees_polynomiales.csv", row.names = FALSE)

cat("Génération finie\n")
