# Régression linéaire simple
# Datasets A, B, C, D (Data1.R, Data2.R, Data3.R, Data4.R)
# Packages : MASS, lmtest, sandwich, boot, segmented ajouté par l'IA


# ----- Dataset A (Data1.R) : cas idéal -----

## partie étudiant

modele_A <- lm(Y ~ X, data = A)
summary(modele_A)

plot(A$X, A$Y, pch = 16, cex = 0.6, xlab = "X", ylab = "Y",
     main = "Dataset A")
abline(modele_A, col = "red", lwd = 2)

# résidus studentisés vs ajustés
plot(fitted(modele_A), rstudent(modele_A), pch = 16, cex = 0.6,
     xlab = "ajustés", ylab = "résidus stud.",
     main = "A : résidus vs ajustés")
abline(h = 0, col = "red", lty = 2)

# QQ-plot pour la normalité
qqnorm(rstudent(modele_A), main = "A : QQ-plot")
qqline(rstudent(modele_A), col = "red")

# test KS
n_A <- nrow(A)
ks.test(rstudent(modele_A), "pt", df = n_A - 3)

cat("R² =", summary(modele_A)$r.squared, "\n")
print(summary(modele_A)$coefficients)


## partie IA

# vérif des formules du cours à la main
x_bar <- mean(A$X)
y_bar <- mean(A$Y)
a_chap <- sum((A$X - x_bar) * (A$Y - y_bar)) / sum((A$X - x_bar)^2)
b_chap <- y_bar - a_chap * x_bar
cat("calcul manuel -> a =", a_chap, "| b =", b_chap, "\n")

# t-stat et région de rejet
sigma_chap <- sqrt(sum(residuals(modele_A)^2) / (n_A - 2))
se_a <- sigma_chap / sqrt(sum((A$X - x_bar)^2))
t_obs <- a_chap / se_a
seuil <- qt(0.975, df = n_A - 2)
cat("t_obs =", t_obs, "| seuil =", seuil, "\n")

curve(dt(x, df = n_A - 2), from = -5, to = 5, n = 500,
      xlab = "t", ylab = "densité", main = "A - région de rejet")
xd <- seq(seuil, 5, length.out = 100)
xg <- seq(-5, -seuil, length.out = 100)
polygon(c(seuil, xd, 5), c(0, dt(xd, n_A - 2), 0),
        col = rgb(1, 0, 0, 0.3), border = NA)
polygon(c(-5, xg, -seuil), c(0, dt(xg, n_A - 2), 0),
        col = rgb(1, 0, 0, 0.3), border = NA)
abline(v = c(-seuil, seuil), col = "red", lty = 2)

# tests formels en complément
library(lmtest)
bptest(modele_A)              # Breusch-Pagan : homoscédasticité
shapiro.test(residuals(modele_A))  # Shapiro-Wilk : normalité

# intervalle de prédiction
predict(modele_A, newdata = data.frame(X = c(0, 50)),
        interval = "prediction")


# ----- Dataset B : outliers -----

## partie étudiant

modele_B <- lm(Y ~ X, data = B)
summary(modele_B)

plot(B$X, B$Y, pch = 16, cex = 0.6, main = "Dataset B")
abline(modele_B, col = "red", lwd = 2)

plot(fitted(modele_B), rstudent(modele_B), pch = 16, cex = 0.6,
     main = "B - résidus")
abline(h = 0, col = "red", lty = 2)
abline(h = c(-3, 3), col = "blue", lty = 3)

qqnorm(rstudent(modele_B), main = "B - QQ-plot")
qqline(rstudent(modele_B), col = "red")

n_B <- nrow(B)
ks.test(rstudent(modele_B), "pt", df = n_B - 3)
# KS rejette, le QQ-plot dévie aux extrémités => outliers


# on identifie et on enlève les outliers (|résidu stud.| > 3)
out <- which(abs(rstudent(modele_B)) > 3)
cat("outliers détectés :", out, "\n")

plot(B$X, B$Y, pch = 16, cex = 0.6, main = "B : outliers en rouge")
points(B$X[out], B$Y[out], col = "red", pch = 16, cex = 1.4)
abline(modele_B, col = "red", lwd = 2)

# refit sur données nettoyées
B2 <- B[-out, ]
modele_B2 <- lm(Y ~ X, data = B2)
summary(modele_B2)

plot(fitted(modele_B2), rstudent(modele_B2), pch = 16, cex = 0.6,
     main = "B nettoyé : résidus")
abline(h = 0, col = "red", lty = 2)
qqnorm(rstudent(modele_B2), main = "B nettoyé : QQ-plot")
qqline(rstudent(modele_B2), col = "red")
ks.test(rstudent(modele_B2), "pt", df = nrow(B2) - 3)

plot(B2$X, B2$Y, pch = 16, cex = 0.6, main = "B nettoyé")
abline(modele_B2, col = "darkgreen", lwd = 2)

cat("pente avant :", coef(modele_B)[2],
    "| après :", coef(modele_B2)[2], "\n")


## partie IA

# distance de Cook (influence et pas seulement aberration)
cook_B <- cooks.distance(modele_B)
plot(cook_B, type = "h", main = "B - distance de Cook")
abline(h = 4 / n_B, col = "red", lty = 2)

# régression robuste (pondère les outliers au lieu de les supprimer)
library(MASS)
modele_B_rob <- rlm(Y ~ X, data = B)

cat("MCO :", coef(modele_B)[2],
    "| rlm :", coef(modele_B_rob)[2],
    "| sans outliers :", coef(modele_B2)[2], "\n")

plot(B$X, B$Y, pch = 16, cex = 0.6, main = "B : comparaison méthodes")
abline(modele_B, col = "red", lwd = 2)
abline(modele_B_rob, col = "blue", lwd = 2, lty = 2)
abline(modele_B2, col = "green", lwd = 2, lty = 3)
legend("topleft", c("MCO", "rlm", "sans outliers"),
       col = c("red", "blue", "green"), lty = c(1, 2, 3), lwd = 2)


# ----- Dataset C : petit échantillon (n=50) -----

## partie étudiant

modele_C <- lm(Y ~ X, data = C)
summary(modele_C)

plot(C$X, C$Y, pch = 16, cex = 0.8, main = "Dataset C (n=50)")
abline(modele_C, col = "red", lwd = 2)

plot(fitted(modele_C), rstudent(modele_C), pch = 16, cex = 0.8,
     main = "C - résidus")
abline(h = 0, col = "red", lty = 2)

qqnorm(rstudent(modele_C), main = "C - QQ-plot")
qqline(rstudent(modele_C), col = "red")

n_C <- nrow(C)
ks.test(rstudent(modele_C), "pt", df = n_C - 3)

# impact de n sur la précision des estimateurs
cat("SE(a) -> A :", summary(modele_A)$coefficients[2, 2],
    "| C :", summary(modele_C)$coefficients[2, 2], "\n")
cat("largeur IC95 -> A :", diff(confint(modele_A)[2, ]),
    "| C :", diff(confint(modele_C)[2, ]), "\n")


## partie IA

bptest(modele_C)  # test formel d'hétéroscédasticité

# erreurs standards robustes
library(sandwich)
coeftest(modele_C, vcov = vcovHC(modele_C, type = "HC1"))

# bootstrap pour IC de la pente (plus fiable en petit n)
library(boot)
boot_fn <- function(d, i) coef(lm(Y ~ X, data = d[i, ]))
set.seed(123)
b_C <- boot(C, boot_fn, R = 2000)
cat("IC classique :", confint(modele_C)[2, ], "\n")
cat("IC bootstrap :", boot.ci(b_C, type = "perc", index = 2)$percent[4:5], "\n")


# ----- Dataset D : relation en V (n=1000) -----

## partie étudiant - tentative directe

modele_D <- lm(Y ~ X, data = D)
summary(modele_D)

plot(D$X, D$Y, pch = 16, cex = 0.5, main = "D - régression simple")
abline(modele_D, col = "red", lwd = 2)

plot(fitted(modele_D), rstudent(modele_D), pch = 16, cex = 0.5,
     main = "D - résidus (pattern en V)")
abline(h = 0, col = "red", lty = 2)

cat("R² =", summary(modele_D)$r.squared, "\n")
ks.test(rstudent(modele_D), "pt", df = nrow(D) - 3)
# le modèle linéaire ne marche pas, on voit clairement un pattern


## partie étudiant - on coupe en deux à X = 30

seuil_X <- 30
D_g <- D[D$X <  seuil_X, ]
D_d <- D[D$X >= seuil_X, ]

mod_g <- lm(Y ~ X, data = D_g)
mod_d <- lm(Y ~ X, data = D_d)
summary(mod_g)
summary(mod_d)

plot(D$X, D$Y, pch = 16, cex = 0.5, main = "D - split à X=30")
abline(v = seuil_X, col = "gray", lty = 3)
x_g <- seq(min(D_g$X), seuil_X, length.out = 100)
x_d <- seq(seuil_X, max(D_d$X), length.out = 100)
lines(x_g, predict(mod_g, newdata = data.frame(X = x_g)),
      col = "blue", lwd = 2)
lines(x_d, predict(mod_d, newdata = data.frame(X = x_d)),
      col = "darkgreen", lwd = 2)
legend("topright", c("branche gauche", "branche droite"),
       col = c("blue", "darkgreen"), lwd = 2)

# diagnostics sur chaque branche
par(mfrow = c(2, 2))
plot(fitted(mod_g), rstudent(mod_g), pch = 16, cex = 0.5,
     main = "gauche - résidus")
abline(h = 0, col = "red", lty = 2)
qqnorm(rstudent(mod_g), main = "gauche - QQ")
qqline(rstudent(mod_g), col = "red")
plot(fitted(mod_d), rstudent(mod_d), pch = 16, cex = 0.5,
     main = "droite - résidus")
abline(h = 0, col = "red", lty = 2)
qqnorm(rstudent(mod_d), main = "droite - QQ")
qqline(rstudent(mod_d), col = "red")
par(mfrow = c(1, 1))

ks.test(rstudent(mod_g), "pt", df = nrow(D_g) - 3)
ks.test(rstudent(mod_d), "pt", df = nrow(D_d) - 3)

cat("R² gauche :", summary(mod_g)$r.squared,
    "| R² droite :", summary(mod_d)$r.squared, "\n")


## partie IA

# régression segmentée : le point de rupture est estimé automatiquement
library(segmented)
modele_D_seg <- segmented(modele_D, seg.Z = ~X, psi = 30)
summary(modele_D_seg)
cat("rupture estimée :", modele_D_seg$psi[, "Est."], "\n")

plot(D$X, D$Y, pch = 16, cex = 0.5, main = "D : régression segmentée")
plot(modele_D_seg, add = TRUE, col = "red", lwd = 2)

# version par morceaux : un seul lm() avec variable indicatrice
D$Z <- pmax(D$X - 30, 0)
mod_pcw <- lm(Y ~ X + Z, data = D)
summary(mod_pcw)

cat("R² simple    :", summary(modele_D)$r.squared, "\n")
cat("R² segmentée :", summary(modele_D_seg)$r.squared, "\n")
