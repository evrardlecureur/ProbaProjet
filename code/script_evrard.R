# Sélection de variables
# Datasets E (data5), F (data6), G (data7) — 5 prédicteurs chacun
# Packages : leaps, car, lmtest ajoutés par l'IA

load("../../data5.RData")  # objet E
load("../../data6.RData")  # objet F
load("../../data7.RData")  # objet G

library(leaps)


# ----- DATA5 (E) -----

## partie étudiant

cor(E)

complet_E <- lm(Y ~ X1 + X2 + X3 + X4 + X5, data = E)
summary(complet_E)

# meilleur sous-modèle de chaque taille
sel_E <- regsubsets(Y ~ X1 + X2 + X3 + X4 + X5, data = E)
summary(sel_E)$which
summary(sel_E)$adjr2

# le R²_a est max pour quelle taille ?
which.max(summary(sel_E)$adjr2)

plot(summary(sel_E)$adjr2, type = "b", xlab = "nb variables", ylab = "R2 ajuste")

# forward et backward
sel_E_f <- regsubsets(Y ~ X1 + X2 + X3 + X4 + X5, data = E, method = "forward")
sel_E_b <- regsubsets(Y ~ X1 + X2 + X3 + X4 + X5, data = E, method = "backward")
summary(sel_E_f)$which
summary(sel_E_b)$which


## partie IA

# backward / forward / both par AIC (step)
step_back_E <- step(complet_E, direction = "backward", trace = 0)
cat("Step backward :", paste(names(coef(step_back_E))[-1], collapse = " + "),
    "| AIC =", round(AIC(step_back_E), 1), "\n")

step_forw_E <- step(lm(Y ~ 1, data = E), direction = "forward",
                    scope = formula(complet_E), trace = 0)
cat("Step forward  :", paste(names(coef(step_forw_E))[-1], collapse = " + "),
    "| AIC =", round(AIC(step_forw_E), 1), "\n")

step_both_E <- step(complet_E, direction = "both", trace = 0)
cat("Step both     :", paste(names(coef(step_both_E))[-1], collapse = " + "),
    "| AIC =", round(AIC(step_both_E), 1), "\n")

# multicolinéarité
library(car)
vif(complet_E)

# homoscédasticité
library(lmtest)
bptest(complet_E)


# ----- DATA6 (F) -----

## partie étudiant

cor(F)

complet_F <- lm(Y ~ X1 + X2 + X3 + X4 + X5, data = F)
summary(complet_F)

sel_F <- regsubsets(Y ~ X1 + X2 + X3 + X4 + X5, data = F)
summary(sel_F)$which
summary(sel_F)$adjr2
which.max(summary(sel_F)$adjr2)

plot(summary(sel_F)$adjr2, type = "b", xlab = "nb variables", ylab = "R2 ajuste")

sel_F_f <- regsubsets(Y ~ X1 + X2 + X3 + X4 + X5, data = F, method = "forward")
sel_F_b <- regsubsets(Y ~ X1 + X2 + X3 + X4 + X5, data = F, method = "backward")
summary(sel_F_f)$which
summary(sel_F_b)$which


## partie IA

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

vif(complet_F)
bptest(complet_F)


# ----- DATA7 (G) -----

## partie étudiant

cor(G)

complet_G <- lm(Y ~ X1 + X2 + X3 + X4 + X5, data = G)
summary(complet_G)

sel_G <- regsubsets(Y ~ X1 + X2 + X3 + X4 + X5, data = G)
summary(sel_G)$which
summary(sel_G)$adjr2
which.max(summary(sel_G)$adjr2)

plot(summary(sel_G)$adjr2, type = "b", xlab = "nb variables", ylab = "R2 ajuste")

sel_G_f <- regsubsets(Y ~ X1 + X2 + X3 + X4 + X5, data = G, method = "forward")
sel_G_b <- regsubsets(Y ~ X1 + X2 + X3 + X4 + X5, data = G, method = "backward")
summary(sel_G_f)$which
summary(sel_G_b)$which


## partie IA

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

vif(complet_G)
bptest(complet_G)
