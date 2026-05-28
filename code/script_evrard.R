# Sélection de variables
# Datasets E (data5), F (data6), G (data7) — 5 prédicteurs chacun
# Packages : car, lmtest ajoutés par l'IA

# chargement des données
load("../../data5.RData")  # objet E
load("../../data6.RData")  # objet F
load("../../data7.RData")  # objet G


# ============================================================
# OUTILS PARTAGÉS
# ============================================================

# fonction de sélection exhaustive (tous les 2^p sous-modèles)
selection_exhaustive <- function(data, vars) {
  n <- nrow(data)
  p <- length(vars)
  res <- NULL
  for (i in 1:(2^p - 1)) {
    bits <- as.logical(intToBits(i)[1:p])
    sel <- vars[bits]
    mod <- lm(as.formula(paste("Y ~", paste(sel, collapse = " + "))), data = data)
    s <- summary(mod)
    k <- length(sel) + 1
    res <- rbind(res, data.frame(
      modele = paste(sel, collapse = "+"),
      R2 = s$r.squared,
      R2_a = 1 - (1 - s$r.squared) * (n - 1) / (n - k),
      AIC = AIC(mod),
      BIC = BIC(mod),
      p = k - 1
    ))
  }
  res[order(-res$R2_a), ]
}

# fonction de sélection forward
selection_forward <- function(data, vars) {
  n <- nrow(data)
  restantes <- vars
  choix <- c()
  cat("Étape 0 : modèle vide\n")
  for (et in 1:length(vars)) {
    best_r2a <- -Inf
    best_v <- NA
    for (v in restantes) {
      cands <- c(choix, v)
      mod <- lm(as.formula(paste("Y ~", paste(cands, collapse = " + "))), data = data)
      r2a <- 1 - (1 - summary(mod)$r.squared) * (n - 1) / (n - length(cands) - 1)
      if (r2a > best_r2a) {
        best_r2a <- r2a
        best_v <- v
      }
    }
    choix <- c(choix, best_v)
    restantes <- restantes[restantes != best_v]
    cat("Étape", et, ": +", best_v, "| R²_a =", round(best_r2a, 6), "\n")
  }
  choix
}

# fonction de sélection backward
selection_backward <- function(data, vars) {
  n <- nrow(data)
  restantes <- vars
  mod <- lm(as.formula(paste("Y ~", paste(vars, collapse = " + "))), data = data)
  for (et in 1:(length(vars) - 1)) {
    coefs <- summary(mod)$coefficients[-1, ]
    pv <- coefs[, "Pr(>|t|)"]
    mauvaise <- names(which.max(pv))
    cat("Étape", et, ": retire", mauvaise,
        "| p =", round(max(pv), 4),
        "| R²_a =", round(summary(mod)$adj.r.squared, 6), "\n")
    restantes <- restantes[restantes != mauvaise]
    mod <- lm(as.formula(paste("Y ~", paste(restantes, collapse = " + "))), data = data)
  }
  restantes
}


# ============================================================
# DATA5 (objet E) — X1 écrase tout
# ============================================================

## partie étudiant

cat("\n========================================\n")
cat("  DATA5 (E) — n = 500, p = 5\n")
cat("========================================\n\n")

# matrice de corrélation
cat("Corrélation avec Y :\n")
print(round(cor(E)[, "Y"], 4))

# modèle complet
complet_E <- lm(Y ~ X1 + X2 + X3 + X4 + X5, data = E)
cat("\nModèle complet :\n")
print(summary(complet_E)$coefficients)

# --- sélection exhaustive ---
cat("\n--- Sélection exhaustive (2^5 = 32 modèles) ---\n")
res_E <- selection_exhaustive(E, c("X1", "X2", "X3", "X4", "X5"))

cat("\nMeilleur modèle par taille :\n")
for (sz in 1:5) {
  sub <- res_E[res_E$p == sz, ]
  b <- sub[which.max(sub$R2_a), ]
  cat("  p =", sz, "|", b$modele,
      "| R²_a =", round(b$R2_a, 6),
      "| AIC =", round(b$AIC, 1), "\n")
}

# --- sélection forward ---
cat("\n--- Sélection forward ---\n")
fwd_E <- selection_forward(E, c("X1", "X2", "X3", "X4", "X5"))
cat("Modèle final forward :", paste(fwd_E, collapse = " + "), "\n")

# --- sélection backward ---
cat("\n--- Sélection backward ---\n")
bwd_E <- selection_backward(E, c("X1", "X2", "X3", "X4", "X5"))
cat("Modèle final backward :", paste(bwd_E, collapse = " + "), "\n")

# --- comparaison ---
cat("\n--- Comparaison ---\n")
cat("Exhaustive :", res_E$modele[1], "\n")
cat("Forward    :", paste(fwd_E, collapse = " + "), "\n")
cat("Backward   :", paste(bwd_E, collapse = " + "), "\n")


## partie IA

cat("\n---步 backward/forward/both par AIC (step) ---\n")

# backward
step_back_E <- step(complet_E, direction = "backward", trace = 0)
cat("Step backward :", paste(names(coef(step_back_E))[-1], collapse = " + "),
    "| AIC =", round(AIC(step_back_E), 1), "\n")

# forward
step_forw_E <- step(lm(Y ~ 1, data = E), direction = "forward",
                     scope = formula(complet_E), trace = 0)
cat("Step forward  :", paste(names(coef(step_forw_E))[-1], collapse = " + "),
    "| AIC =", round(AIC(step_forw_E), 1), "\n")

# both
step_both_E <- step(complet_E, direction = "both", trace = 0)
cat("Step both     :", paste(names(coef(step_both_E))[-1], collapse = " + "),
    "| AIC =", round(AIC(step_both_E), 1), "\n")

# multicolinéarité
if (requireNamespace("car", quietly = TRUE)) {
  library(car)
  cat("\nVIF (modèle complet) :\n")
  print(round(vif(complet_E), 2))
} else {
  cat("\nPackage 'car' non installé — VIF ignoré\n")
}

# homoscédasticité
if (requireNamespace("lmtest", quietly = TRUE)) {
  library(lmtest)
  cat("\nTest de Breusch-Pagan :\n")
  print(bptest(complet_E))
} else {
  cat("\nPackage 'lmtest' non installé — Breusch-Pagan ignoré\n")
}

# diagnostic du modèle final (backward : X1 seul)
mod_final_E <- lm(Y ~ X1, data = E)
cat("\nDiagnostics du modèle final (X1 seul) :\n")
ks.test(rstudent(mod_final_E), "pt", df = nrow(E) - 2)


# ============================================================
# DATA6 (objet F) — X3 dominante
# ============================================================

## partie étudiant

cat("\n\n========================================\n")
cat("  DATA6 (F) — n = 500, p = 5\n")
cat("========================================\n\n")

cat("Corrélation avec Y :\n")
print(round(cor(F)[, "Y"], 4))

complet_F <- lm(Y ~ X1 + X2 + X3 + X4 + X5, data = F)
cat("\nModèle complet :\n")
print(summary(complet_F)$coefficients)

# sélection exhaustive
cat("\n--- Sélection exhaustive ---\n")
res_F <- selection_exhaustive(F, c("X1", "X2", "X3", "X4", "X5"))
cat("\nMeilleur modèle par taille :\n")
for (sz in 1:5) {
  sub <- res_F[res_F$p == sz, ]
  b <- sub[which.max(sub$R2_a), ]
  cat("  p =", sz, "|", b$modele,
      "| R²_a =", round(b$R2_a, 6),
      "| AIC =", round(b$AIC, 1), "\n")
}

# forward
cat("\n--- Sélection forward ---\n")
fwd_F <- selection_forward(F, c("X1", "X2", "X3", "X4", "X5"))
cat("Modèle final forward :", paste(fwd_F, collapse = " + "), "\n")

# backward
cat("\n--- Sélection backward ---\n")
bwd_F <- selection_backward(F, c("X1", "X2", "X3", "X4", "X5"))
cat("Modèle final backward :", paste(bwd_F, collapse = " + "), "\n")

# comparaison
cat("\n--- Comparaison ---\n")
cat("Exhaustive :", res_F$modele[1], "\n")
cat("Forward    :", paste(fwd_F, collapse = " + "), "\n")
cat("Backward   :", paste(bwd_F, collapse = " + "), "\n")


## partie IA

cat("\n---步 AIC (step) ---\n")
step_back_F <- step(complet_F, direction = "backward", trace = 0)
cat("Step backward :", paste(names(coef(step_back_F))[-1], collapse = " + "),
    "| AIC =", round(AIC(step_back_F), 1), "\n")

step_forw_F <- step(lm(Y ~ 1, data = F), direction = "forward",
                     scope = formula(complet_F), trace = 0)
cat("Step forward  :", paste(names(coef(step_forw_F))[-1], collapse = " + "),
    "| AIC =", round(AIC(step_forw_F), 1), "\n")

step_both_F <- step(complet_F, direction = "both", trace = 0)
cat("Step both     :", paste(names(coef(step_both_F))[-1], collapse = " + "),
    "| AIC =", round(AIC(step_both_F), 1), "\n")

if (requireNamespace("car", quietly = TRUE)) {
  library(car)
  cat("\nVIF :\n")
  print(round(vif(complet_F), 2))
}
if (requireNamespace("lmtest", quietly = TRUE)) {
  library(lmtest)
  cat("\nBreusch-Pagan :\n")
  print(bptest(complet_F))
}

mod_final_F <- lm(Y ~ X3, data = F)
cat("\nKS (X3 seul) :\n")
ks.test(rstudent(mod_final_F), "pt", df = nrow(F) - 2)


# ============================================================
# DATA7 (objet G) — X5 dominante
# ============================================================

## partie étudiant

cat("\n\n========================================\n")
cat("  DATA7 (G) — n = 5000, p = 5\n")
cat("========================================\n\n")

cat("Corrélation avec Y :\n")
print(round(cor(G)[, "Y"], 4))

complet_G <- lm(Y ~ X1 + X2 + X3 + X4 + X5, data = G)
cat("\nModèle complet :\n")
print(summary(complet_G)$coefficients)

# sélection exhaustive
cat("\n--- Sélection exhaustive ---\n")
res_G <- selection_exhaustive(G, c("X1", "X2", "X3", "X4", "X5"))
cat("\nMeilleur modèle par taille :\n")
for (sz in 1:5) {
  sub <- res_G[res_G$p == sz, ]
  b <- sub[which.max(sub$R2_a), ]
  cat("  p =", sz, "|", b$modele,
      "| R²_a =", round(b$R2_a, 6),
      "| AIC =", round(b$AIC, 1), "\n")
}

# forward
cat("\n--- Sélection forward ---\n")
fwd_G <- selection_forward(G, c("X1", "X2", "X3", "X4", "X5"))
cat("Modèle final forward :", paste(fwd_G, collapse = " + "), "\n")

# backward
cat("\n--- Sélection backward ---\n")
bwd_G <- selection_backward(G, c("X1", "X2", "X3", "X4", "X5"))
cat("Modèle final backward :", paste(bwd_G, collapse = " + "), "\n")

# comparaison
cat("\n--- Comparaison ---\n")
cat("Exhaustive :", res_G$modele[1], "\n")
cat("Forward    :", paste(fwd_G, collapse = " + "), "\n")
cat("Backward   :", paste(bwd_G, collapse = " + "), "\n")


## partie IA

cat("\n---步 AIC (step) ---\n")
step_back_G <- step(complet_G, direction = "backward", trace = 0)
cat("Step backward :", paste(names(coef(step_back_G))[-1], collapse = " + "),
    "| AIC =", round(AIC(step_back_G), 1), "\n")

step_forw_G <- step(lm(Y ~ 1, data = G), direction = "forward",
                     scope = formula(complet_G), trace = 0)
cat("Step forward  :", paste(names(coef(step_forw_G))[-1], collapse = " + "),
    "| AIC =", round(AIC(step_forw_G), 1), "\n")

step_both_G <- step(complet_G, direction = "both", trace = 0)
cat("Step both     :", paste(names(coef(step_both_G))[-1], collapse = " + "),
    "| AIC =", round(AIC(step_both_G), 1), "\n")

if (requireNamespace("car", quietly = TRUE)) {
  library(car)
  cat("\nVIF :\n")
  print(round(vif(complet_G), 2))
}
if (requireNamespace("lmtest", quietly = TRUE)) {
  library(lmtest)
  cat("\nBreusch-Pagan :\n")
  print(bptest(complet_G))
}

mod_final_G <- lm(Y ~ X5, data = G)
cat("\nKS (X5 seul) :\n")
ks.test(rstudent(mod_final_G), "pt", df = nrow(G) - 2)


# ============================================================
# FIGURES
# ============================================================

# --- Figure 1 : R²_a par taille pour les 3 datasets ---

png("../figures/sel_r2a_taille.png", width = 1000, height = 500)
par(mfrow = c(1, 3))

for (nom in c("E", "F", "G")) {
  data <- get(nom)
  vars <- c("X1", "X2", "X3", "X4", "X5")
  res <- selection_exhaustive(data, vars)
  
  r2a_par_taille <- tapply(res$R2_a, res$p, max)
  
  plot(as.numeric(names(r2a_par_taille)), r2a_par_taille,
       type = "b", pch = 16, col = "steelblue",
       xlab = "p (nb variables)", ylab = "R²_a",
       main = paste("Dataset", nom),
       ylim = c(min(r2a_par_taille) - 0.01, max(r2a_par_taille) + 0.005))
}
par(mfrow = c(1, 1))
dev.off()

# --- Figure 2 : AIC/BIC par taille ---

png("../figures/sel_aic_taille.png", width = 1000, height = 500)
par(mfrow = c(1, 3))

for (nom in c("E", "F", "G")) {
  data <- get(nom)
  vars <- c("X1", "X2", "X3", "X4", "X5")
  res <- selection_exhaustive(data, vars)
  
  aic_par_taille <- tapply(res$AIC, res$p, min)
  bic_par_taille <- tapply(res$BIC, res$p, min)
  
  plot(as.numeric(names(aic_par_taille)), aic_par_taille,
       type = "b", pch = 16, col = "blue",
       xlab = "p (nb variables)", ylab = "Critère",
       main = paste("Dataset", nom),
       ylim = range(c(aic_par_taille, bic_par_taille)))
  lines(as.numeric(names(bic_par_taille)), bic_par_taille,
        type = "b", pch = 17, col = "red")
  legend("topright", c("AIC", "BIC"), col = c("blue", "red"),
         pch = c(16, 17), lty = 1, cex = 0.8)
}
par(mfrow = c(1, 1))
dev.off()

# --- Figure 3 : diagnostiques finaux ---

# data5 : modèle X1 seul
png("../figures/sel_diag_E.png", width = 800, height = 600)
par(mfrow = c(2, 2))
plot(lm(Y ~ X1, data = E))
par(mfrow = c(1, 1))
dev.off()

# data6 : modèle X3 seul
png("../figures/sel_diag_F.png", width = 800, height = 600)
par(mfrow = c(2, 2))
plot(lm(Y ~ X3, data = F))
par(mfrow = c(1, 1))
dev.off()

# data7 : modèle X5 seul
png("../figures/sel_diag_G.png", width = 800, height = 600)
par(mfrow = c(2, 2))
plot(lm(Y ~ X5, data = G))
par(mfrow = c(1, 1))
dev.off()


cat("\n========================================\n")
cat("  FIN DU SCRIPT\n")
cat("========================================\n")
