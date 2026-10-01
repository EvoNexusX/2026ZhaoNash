# Fairness-Aware Performance Evaluation for Multi-Party Multi-Objective Optimization

<p align="center">
  <strong>Nash-Product Evaluation for Multi-Party Multi-Objective Optimization</strong>
</p>

---

## 📖 Overview

**Nash-product evaluation** is a performance metric framework for **Multi-Party Multi-Objective Optimization (MPMOP)**. It combines per-decision-maker convergence quality with concession-based penalties and aggregates individual utilities to achieve fairness-aware evaluation.

Higher scores are better. The returned score is the raw product of decision-maker utilities and is not rescaled or normalized afterward.

This repository provides the MATLAB implementation of the proposed evaluation framework, together with the benchmark problems used in the experimental studies.

---

## 📄 Paper

This code links to the paper:

**Fairness-Aware Performance Evaluation for Multi-Party Multi-Objective Optimization**

**Authors:** Zifan Zhao, Peilan Xu, Wenjian Luo

**Published in:** *IEEE Transactions on Evolutionary Computation*

**Status:** Accepted for publication

This is the official repository for the paper:

https://arxiv.org/abs/2601.22497

---

# Metric Definition

Consider a problem with $M$ decision makers. Decision maker $m$ has objective sub-vector $\mathbf{f}^{(m)}(\mathbf{x})$ and Pareto front $PF_m$.

| Symbol | Meaning |
| :--- | :--- |
| $f_i^{\max}$ | Maximum value of objective $i$ in the feasible range (estimated from PF and the candidate set) |
| $\operatorname{offset}(\mathbf{x}, \mathbf{y})$ | $\displaystyle \max_i \frac{|f_i(\mathbf{x})-f_i(\mathbf{y})|}{f_i^{\max}}$ |
| $\operatorname{offset}(\mathbf{x}, PF_m)$ | $\displaystyle \min_{\mathbf{y}\in PF_m} \operatorname{offset}(\mathbf{x}, \mathbf{y})$ |
| $\operatorname{max\_offset}_m$ | Maximum offset from other DMs' PFs to $PF_m$ |
| $\varepsilon_m(\mathbf{v})$ | Concession: $\displaystyle \frac{\operatorname{offset}(\mathbf{v},PF_m)}{\operatorname{max\_offset}_m}$ |
| $\varphi(\varepsilon)$ | Penalty: $\max(0,\varepsilon-\varepsilon_m^{\text{threshold}})$ |
| $\mu_m^{\text{ref}}$ | Maximum Euclidean distance from any point on other DMs' PFs to $PF_m$ (defaults to 1 when zero) |
| $\mu_m$ | Convergence measure based on IGD or GD |
| $\lambda_m$ | User-defined penalty weight for decision maker $m$ |

For each decision maker $m$, the evaluation consists of the following steps.

### 1. Point Penalty

The penalty associated with a solution $\mathbf{v}$ is defined as

$$
\ell_m^{\text{pen}}(\mathbf{v})
=
\mu_m^{\text{ref}}
\cdot
\varphi\left(\varepsilon_m(\mathbf{v})\right).
$$

### 2. Population Penalty

For a candidate solution set $P$, the population-level penalty is

$$
L_m^{\text{pen}}(P)
=
\sum_{\mathbf{v}\in P}
\ell_m^{\text{pen}}(\mathbf{v}).
$$

### 3. Total Loss

The total loss of decision maker $m$ is

$$
L_m(P)
=
\mu_m(P)
+
\lambda_m
\cdot
L_m^{\text{pen}}(P).
$$

### 4. Utility

The utility of decision maker $m$ is defined as

$$
u_m
=
C-L_m(P),
$$

where $C$ is a constant.

## Nash Score

The final Nash-product score is

$$
\boxed{
\Psi_{\mathrm{NP}}
=
\prod_{m=1}^{M}u_m
}.
$$

A higher $\Psi_{\mathrm{NP}}$ indicates better overall performance.

---

# 📁 Files

The repository is organized as follows:

```text
2026ZhaoNash/
│
├── MPMOP/
│   └── MPMOP benchmark problems
│
├── MPDMP/
│   └── MPDMP benchmark problems
│
├── nash-score/
│   ├── nash_score.m
│   └── compute_offset_to_pf.m
│
└── README.md

