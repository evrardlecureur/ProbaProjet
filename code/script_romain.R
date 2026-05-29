# Régression linéaire simple
# Datasets A, B, C, D (Data1.R, Data2.R, Data3.R, Data4.R)
# Packages : MASS, lmtest, sandwich, boot, segmented ajouté par l'IA


# ----- Dataset A (Data1.R) : cas idéal -----

## partie étudiant

modele_A <- lm(Y ~ X, data = A)
summary(modele_A)

plot(A$X, A$Y, main = "Dataset A")
abline(modele_A, col = "red")

# résidus
plot(fitted(modele_A), rstudent(modele_A))
abline(h = 0)

qqnorm(rstudent(modele_A))
qqline(rstudent(modele_A))

n_A <- nrow(A)
ks.test(rstudent(modele_A), "pt", df = n_A - 3)


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

plot(B$X, B$Y, main = "Dataset B")
abline(modele_B, col = "red")

plot(fitted(modele_B), rstudent(modele_B))
abline(h = 0)
abline(h = c(-3, 3), lty = 2)

qqnorm(rstudent(modele_B))
qqline(rstudent(modele_B))

n_B <- nrow(B)
ks.test(rstudent(modele_B), "pt", df = n_B - 3)

# on enlève les points avec un résidu trop grand
out <- which(abs(rstudent(modele_B)) > 3)
out

plot(B$X, B$Y, main = "outliers")
points(B$X[out], B$Y[out], col = "red")
abline(modele_B, col = "red")

B2 <- B[-out, ]
modele_B2 <- lm(Y ~ X, data = B2)
summary(modele_B2)

plot(fitted(modele_B2), rstudent(modele_B2))
abline(h = 0)
qqnorm(rstudent(modele_B2))
qqline(rstudent(modele_B2))
ks.test(rstudent(modele_B2), "pt", df = nrow(B2) - 3)

plot(B2$X, B2$Y, main = "B sans outliers")
abline(modele_B2, col = "red")

coef(modele_B)[2]
coef(modele_B2)[2]


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

plot(C$X, C$Y, main = "Dataset C")
abline(modele_C, col = "red")

plot(fitted(modele_C), rstudent(modele_C))
abline(h = 0)
qqnorm(rstudent(modele_C))
qqline(rstudent(modele_C))

n_C <- nrow(C)
ks.test(rstudent(modele_C), "pt", df = n_C - 3)

# l'écart-type de la pente est plus grand qu'avec A
summary(modele_C)$coefficients[2, 2]
confint(modele_C)


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

## partie étudiant - on essaie une droite

modele_D <- lm(Y ~ X, data = D)
summary(modele_D)

plot(D$X, D$Y, main = "Dataset D")
abline(modele_D, col = "red")

plot(fitted(modele_D), rstudent(modele_D))
abline(h = 0)
# ça fait un V, la droite marche pas

ks.test(rstudent(modele_D), "pt", df = nrow(D) - 3)


## partie étudiant - on coupe en deux à X = 30

D_g <- D[D$X < 30, ]
D_d <- D[D$X >= 30, ]
mod_g <- lm(Y ~ X, data = D_g)
mod_d <- lm(Y ~ X, data = D_d)
summary(mod_g)
summary(mod_d)

plot(D$X, D$Y, main = "deux droites")
abline(mod_g, col = "blue")
abline(mod_d, col = "red")

summary(mod_g)$r.squared
summary(mod_d)$r.squared


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
