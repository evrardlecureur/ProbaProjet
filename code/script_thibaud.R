# =============================================================
# Projet Régression linéaire - Polytech Nice Sophia MAM3
# Partie : Thibaud
#   1) Régression multiple        (data5)
#   2) Régression polynomiale     (data4)
#   3) Analyse de la variance     (data7)
# =============================================================

rm(list = ls())
graphics.off()

base_dir <- "C:/Users/thiba/OneDrive/Bureau/Projet régression linéaire"
data_dir <- file.path(base_dir, "data_extracted")
fig_dir  <- file.path(base_dir, "figures")
out_dir  <- file.path(base_dir, "sorties")

# Redirection des sorties texte
sink(file.path(out_dir, "resultats_thibaud.txt"), split = TRUE)

# =============================================================
# 1) REGRESSION MULTIPLE - data5
# =============================================================
cat("\n############################################################\n")
cat("# 1) Régression linéaire multiple - data5\n")
cat("############################################################\n\n")

load(file.path(data_dir, "data5.RData"))  # data.frame nommé E
dM <- E
cat("Dimensions :", dim(dM), "\n")
cat("Résumé :\n"); print(summary(dM))

# Matrice de corrélation
cat("\nMatrice de corrélation :\n")
print(round(cor(dM), 3))

png(file.path(fig_dir, "mult_pairs.png"), width = 900, height = 900)
pairs(dM, main = "Nuages de points - data5", pch = 20, cex = 0.4)
dev.off()

# Modèle complet
mod_full <- lm(Y ~ X1 + X2 + X3 + X4 + X5, data = dM)
cat("\n--- Modèle complet ---\n")
print(summary(mod_full))

# Intervalles de confiance des coefficients
cat("\nIntervalles de confiance à 95% des coefficients :\n")
print(confint(mod_full))

# ANOVA séquentielle
cat("\nTable d'ANOVA (séquentielle) :\n")
print(anova(mod_full))

# Diagnostic des résidus
png(file.path(fig_dir, "mult_diag.png"), width = 900, height = 700)
par(mfrow = c(2, 2)); plot(mod_full); par(mfrow = c(1, 1))
dev.off()

# Test de normalité des résidus studentisés (Kolmogorov-Smirnov)
rt_full <- rstudent(mod_full)
ks_full <- ks.test(rt_full, "pt", df = nrow(dM) - length(coef(mod_full)) - 1)
cat("\nTest de Kolmogorov-Smirnov sur les résidus studentisés :\n")
print(ks_full)

# Sélection manuelle par retrait des variables non significatives
# (la variable la moins significative est retirée si p-valeur > 0.05)
cat("\n--- Réduction du modèle (retrait des variables non significatives) ---\n")
mod_red <- step(mod_full, direction = "backward", trace = 0)
cat("Modèle retenu par step (AIC) :\n")
print(summary(mod_red))

# Comparaison des deux modèles
cat("\nComparaison modèle complet vs réduit (test F) :\n")
print(anova(mod_red, mod_full))

# =============================================================
# 2) REGRESSION POLYNOMIALE - data4
# =============================================================
cat("\n############################################################\n")
cat("# 2) Régression polynomiale - data4\n")
cat("############################################################\n\n")

load(file.path(data_dir, "data4.RData"))  # data.frame D
dP <- D
cat("Dimensions :", dim(dP), "\n")
cat("Corrélations : cor(X,Y) =", cor(dP$X, dP$Y),
    " cor(X^2,Y) =", cor(dP$X^2, dP$Y), "\n")

# Visualisation initiale
png(file.path(fig_dir, "poly_scatter.png"), width = 800, height = 600)
plot(dP$X, dP$Y, pch = 20, cex = 0.5, col = "grey40",
     xlab = "X", ylab = "Y", main = "data4 : nuage de points")
dev.off()

# Modèle linéaire simple (comparaison)
mod_lin <- lm(Y ~ X, data = dP)
cat("\n--- Modèle linéaire simple (Y ~ X) ---\n")
print(summary(mod_lin))

# Modèles polynomiaux de degrés croissants
for (deg in 2:4) {
  cat("\n--- Modèle polynomial degré", deg, "---\n")
  m <- lm(Y ~ poly(X, degree = deg, raw = TRUE), data = dP)
  print(summary(m))
}

# Modèle polynomial de degré 2 retenu
mod_poly <- lm(Y ~ poly(X, 2, raw = TRUE), data = dP)

# Comparaison linéaire vs polynomial (test F via anova emboîtée)
cat("\nTest F : Y ~ X  vs  Y ~ X + X^2\n")
print(anova(mod_lin, mod_poly))

# Tracé du modèle polynomial
xseq <- seq(min(dP$X), max(dP$X), length.out = 300)
yhat <- predict(mod_poly, newdata = data.frame(X = xseq),
                interval = "prediction", level = 0.95)

png(file.path(fig_dir, "poly_fit.png"), width = 800, height = 600)
plot(dP$X, dP$Y, pch = 20, cex = 0.5, col = "grey40",
     xlab = "X", ylab = "Y",
     main = "Régression polynomiale degré 2 (data4)")
lines(xseq, yhat[, "fit"], col = "red", lwd = 2)
lines(xseq, yhat[, "lwr"], col = "blue", lty = 2)
lines(xseq, yhat[, "upr"], col = "blue", lty = 2)
abline(mod_lin, col = "darkgreen", lwd = 1.5, lty = 3)
legend("topleft", c("Polynomial deg. 2", "IC prédiction 95%", "Modèle linéaire"),
       col = c("red", "blue", "darkgreen"), lty = c(1, 2, 3), bty = "n")
dev.off()

# Diagnostic
png(file.path(fig_dir, "poly_diag.png"), width = 900, height = 700)
par(mfrow = c(2, 2)); plot(mod_poly); par(mfrow = c(1, 1))
dev.off()

# Normalité des résidus
rt_poly <- rstudent(mod_poly)
ks_poly <- ks.test(rt_poly, "pt", df = nrow(dP) - 3 - 1)
cat("\nTest de Kolmogorov-Smirnov sur les résidus studentisés :\n")
print(ks_poly)

# =============================================================
# 3) ANALYSE DE LA VARIANCE - data7
# =============================================================
cat("\n############################################################\n")
cat("# 3) ANOVA - data7\n")
cat("############################################################\n\n")

load(file.path(data_dir, "data7.RData"))  # data.frame G
dA <- G
cat("Dimensions :", dim(dA), "\n")

# On utilise X6 (binaire, 0/1) comme facteur principal.
# X7 (entier, 1-15) regroupé en 3 classes pour servir de second facteur.
dA$F1 <- factor(dA$X6, labels = c("groupe0", "groupe1"))
dA$F2 <- cut(dA$X7,
             breaks = c(-Inf, 6, 9, Inf),
             labels = c("bas", "moyen", "haut"))

cat("Effectifs par facteur F1 :\n"); print(table(dA$F1))
cat("Effectifs par facteur F2 :\n"); print(table(dA$F2))
cat("Croisement F1 x F2 :\n");       print(table(dA$F1, dA$F2))

# Statistiques descriptives
cat("\nMoyennes de Y par F1 :\n"); print(tapply(dA$Y, dA$F1, mean))
cat("Moyennes de Y par F2 :\n"); print(tapply(dA$Y, dA$F2, mean))

# Visualisation
png(file.path(fig_dir, "anova_boxplots.png"), width = 1000, height = 500)
par(mfrow = c(1, 2))
boxplot(Y ~ F1, data = dA, main = "Y selon F1 (X6)", col = "lightblue")
boxplot(Y ~ F2, data = dA, main = "Y selon F2 (X7 regroupé)", col = "lightgreen")
par(mfrow = c(1, 1))
dev.off()

png(file.path(fig_dir, "anova_interaction.png"), width = 800, height = 600)
interaction.plot(dA$F2, dA$F1, dA$Y,
                 xlab = "F2", ylab = "Y moyenne", trace.label = "F1",
                 col = c("red", "blue"), lwd = 2,
                 main = "Diagramme d'interaction F1 x F2")
dev.off()

# ANOVA à un facteur
cat("\n--- ANOVA à 1 facteur : Y ~ F1 ---\n")
aov1 <- aov(Y ~ F1, data = dA)
print(summary(aov1))

cat("\n--- ANOVA à 1 facteur : Y ~ F2 ---\n")
aov1b <- aov(Y ~ F2, data = dA)
print(summary(aov1b))

# ANOVA à deux facteurs avec interaction
cat("\n--- ANOVA à 2 facteurs avec interaction : Y ~ F1 * F2 ---\n")
aov2 <- aov(Y ~ F1 * F2, data = dA)
print(summary(aov2))

# Test post-hoc de Tukey
cat("\n--- Comparaisons multiples de Tukey ---\n")
print(TukeyHSD(aov2, which = "F2"))

# Vérification des hypothèses de l'ANOVA
# Homoscédasticité (Bartlett)
cat("\nTest de Bartlett (homoscédasticité) sur F1 :\n")
print(bartlett.test(Y ~ F1, data = dA))
cat("\nTest de Bartlett sur F2 :\n")
print(bartlett.test(Y ~ F2, data = dA))

# Normalité des résidus (KS sur résidus studentisés)
rt_aov <- rstudent(lm(Y ~ F1 * F2, data = dA))
ks_aov <- ks.test(rt_aov, "pnorm")
cat("\nTest KS sur résidus studentisés de l'ANOVA (vs N(0,1)) :\n")
print(ks_aov)

png(file.path(fig_dir, "anova_diag.png"), width = 900, height = 700)
par(mfrow = c(2, 2)); plot(aov2); par(mfrow = c(1, 1))
dev.off()

cat("\n############################################################\n")
cat("# Fin du script\n")
cat("############################################################\n")

sink()
cat("Script terminé. Sorties dans :", out_dir, "\n")
cat("Figures dans :", fig_dir, "\n")
