# Régression multiple, polynomiale et ANOVA
# Datasets E (data5), D (data4), G (data7)
# Packages : car, lmtest ajoutés par l'IA


# ----- Régression multiple (data5 = E) -----

## partie étudiant

modele_E <- lm(Y ~ X1 + X2 + X3 + X4 + X5, data = E)
summary(modele_E)

pairs(E, pch = 16, cex = 0.4, main = "data5")

# matrice de corrélation
round(cor(E), 3)

# diagnostic
par(mfrow = c(2, 2))
plot(modele_E)
par(mfrow = c(1, 1))

# normalité des résidus studentisés contre T(n-p-1)
n_E <- nrow(E)
ks.test(rstudent(modele_E), "pt", df = n_E - 6)

# intervalles de confiance des coefficients
confint(modele_E)

# X2 n'est pas significative : on la retire
modele_E2 <- lm(Y ~ X1 + X3 + X4 + X5, data = E)
summary(modele_E2)

# comparaison par test F emboîté
anova(modele_E2, modele_E)
# pas de différence significative => on garde le modèle réduit


## partie IA

# sélection backward automatique par AIC
modele_E_step <- step(modele_E, direction = "backward", trace = 0)
summary(modele_E_step)

# multicolinéarité (VIF)
library(car)
vif(modele_E)
# VIF proches de 1 => pas de problème

# test formel d'homoscédasticité
library(lmtest)
bptest(modele_E)


# ----- Régression polynomiale (data4 = D) -----

## partie étudiant

# tentative d'un modèle linéaire simple
modele_lin <- lm(Y ~ X, data = D)
summary(modele_lin)

# la corrélation entre X^2 et Y est plus forte que celle entre X et Y
cat("cor(X,Y) =", cor(D$X, D$Y),
    "| cor(X^2,Y) =", cor(D$X^2, D$Y), "\n")

# modèle quadratique
modele_poly2 <- lm(Y ~ X + I(X^2), data = D)
summary(modele_poly2)

# tracé : nuage + droite linéaire + parabole + IC prédiction 95%
x_seq <- seq(min(D$X), max(D$X), length.out = 300)
y_hat <- predict(modele_poly2, newdata = data.frame(X = x_seq),
                 interval = "prediction", level = 0.95)

plot(D$X, D$Y, pch = 16, cex = 0.5,
     main = "D - régression polynomiale degré 2")
lines(x_seq, y_hat[, "fit"], col = "red", lwd = 2)
lines(x_seq, y_hat[, "lwr"], col = "blue", lty = 2)
lines(x_seq, y_hat[, "upr"], col = "blue", lty = 2)
abline(modele_lin, col = "darkgreen", lwd = 2, lty = 3)
legend("topleft", c("polynomial deg.2", "IC prédiction 95%", "linéaire"),
       col = c("red", "blue", "darkgreen"), lty = c(1, 2, 3))

# test F : le terme X^2 apporte-t-il vraiment quelque chose ?
anova(modele_lin, modele_poly2)

# diagnostic
par(mfrow = c(2, 2))
plot(modele_poly2)
par(mfrow = c(1, 1))

ks.test(rstudent(modele_poly2), "pt", df = nrow(D) - 4)

cat("R² linéaire :", summary(modele_lin)$r.squared,
    "| R² deg.2 :", summary(modele_poly2)$r.squared, "\n")


## partie IA

# comparaison automatique des degrés 2, 3, 4
modele_poly3 <- lm(Y ~ poly(X, 3, raw = TRUE), data = D)
modele_poly4 <- lm(Y ~ poly(X, 4, raw = TRUE), data = D)

cat("AIC deg.2 :", AIC(modele_poly2),
    "| deg.3 :", AIC(modele_poly3),
    "| deg.4 :", AIC(modele_poly4), "\n")

anova(modele_poly2, modele_poly3, modele_poly4)

# poly() en base orthogonale (plus stable numériquement aux degrés élevés)
modele_poly_orth <- lm(Y ~ poly(X, 3), data = D)
summary(modele_poly_orth)


# ----- ANOVA (data7 = G) -----

## partie étudiant

# X6 binaire et X7 entier 1-15 traités comme facteurs
G$F1 <- factor(G$X6, labels = c("groupe0", "groupe1"))
G$F2 <- cut(G$X7, breaks = c(-Inf, 6, 9, Inf),
            labels = c("bas", "moyen", "haut"))

table(G$F1, G$F2)
tapply(G$Y, G$F1, mean)
tapply(G$Y, G$F2, mean)

# visualisation
par(mfrow = c(1, 2))
boxplot(Y ~ F1, data = G, col = "lightblue",  main = "Y par F1")
boxplot(Y ~ F2, data = G, col = "lightgreen", main = "Y par F2")
par(mfrow = c(1, 1))

# ANOVA à 1 facteur
aov_F1 <- aov(Y ~ F1, data = G)
summary(aov_F1)

aov_F2 <- aov(Y ~ F2, data = G)
summary(aov_F2)

# ANOVA à 2 facteurs avec interaction
aov_2f <- aov(Y ~ F1 * F2, data = G)
summary(aov_2f)

interaction.plot(G$F2, G$F1, G$Y,
                 xlab = "F2", ylab = "Y moyenne", trace.label = "F1",
                 col = c("red", "blue"), lwd = 2,
                 main = "interaction F1 x F2")

# homoscédasticité (Bartlett)
bartlett.test(Y ~ F1, data = G)
bartlett.test(Y ~ F2, data = G)

# normalité des résidus
qqnorm(rstudent(aov_2f), main = "ANOVA - QQ-plot")
qqline(rstudent(aov_2f), col = "red")


## partie IA

# post-hoc de Tukey : quelles modalités diffèrent réellement ?
TukeyHSD(aov_2f, which = "F2")

# alternative : garder X7 quantitative plutôt que la découper en classes
# (le découpage fait perdre de l'information)
modele_X7_quanti <- lm(Y ~ X6 + X7, data = G)
summary(modele_X7_quanti)

# test de Levene : plus robuste que Bartlett à la non-normalité
leveneTest(Y ~ F1, data = G)
leveneTest(Y ~ F2, data = G)
