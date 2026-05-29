# Régression multiple, polynomiale et ANOVA
# Datasets E (data5), D (data4), G (data7)
# Packages : car, lmtest ajoutés par l'IA


# ----- Régression multiple (data5 = E) -----

## partie étudiant

modele_E <- lm(Y ~ X1 + X2 + X3 + X4 + X5, data = E)
summary(modele_E)

pairs(E)
cor(E)

par(mfrow = c(2, 2))
plot(modele_E)
par(mfrow = c(1, 1))

confint(modele_E)

# X2 a une p-value trop grande, on l'enlève
modele_E2 <- lm(Y ~ X1 + X3 + X4 + X5, data = E)
summary(modele_E2)

# est-ce qu'on perd quelque chose en enlevant X2 ?
anova(modele_E2, modele_E)


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

# on essaie d'abord une droite
modele_lin <- lm(Y ~ X, data = D)
summary(modele_lin)

# Y a l'air de suivre X au carré plutôt que X
cor(D$X, D$Y)
cor(D$X^2, D$Y)

# modèle quadratique
modele_poly2 <- lm(Y ~ X + I(X^2), data = D)
summary(modele_poly2)

plot(D$X, D$Y, main = "data4")

x_seq <- seq(min(D$X), max(D$X), length.out = 100)
plot(D$X, D$Y, main = "data4")
lines(x_seq, predict(modele_poly2, data.frame(X = x_seq)), col = "red")

# le terme X^2 est-il utile ?
anova(modele_lin, modele_poly2)

par(mfrow = c(2, 2))
plot(modele_poly2)
par(mfrow = c(1, 1))

summary(modele_lin)$r.squared
summary(modele_poly2)$r.squared


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

G$F1 <- factor(G$X6)
G$F2 <- cut(G$X7, breaks = c(-Inf, 6, 9, Inf), labels = c("bas", "moyen", "haut"))

tapply(G$Y, G$F1, mean)
tapply(G$Y, G$F2, mean)

par(mfrow = c(1, 2))
boxplot(Y ~ F1, data = G)
boxplot(Y ~ F2, data = G)
par(mfrow = c(1, 1))

# ANOVA à 1 facteur
aov_F1 <- aov(Y ~ F1, data = G)
summary(aov_F1)

aov_F2 <- aov(Y ~ F2, data = G)
summary(aov_F2)

# ANOVA à 2 facteurs avec interaction
aov_2f <- aov(Y ~ F1 * F2, data = G)
summary(aov_2f)

interaction.plot(G$F2, G$F1, G$Y)

# normalité des résidus
qqnorm(rstudent(aov_2f))
qqline(rstudent(aov_2f))


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
