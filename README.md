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

Paper Link:

https://ieeexplore.ieee.org/document/11719690

---

# Metric Definition

For DM $m$, A normalized deviation $D_m(x)$ from its individual Pareto-optimal set and a reference deviation

$$\Delta_m=\max_{j\ne m}\max_{x\in PS_j}D_m(x),\qquad \gamma_m(x)=D_m(x)/\Delta_m.$$

Given a concession threshold $\hat\gamma_m\in[0,1]$, 

$$\phi_m(x)=\max(0,\gamma_m(x)-\hat\gamma_m),\qquad L_m^{\mathrm{pen}}(P)=\sum_{x\in P}\phi_m(x).$$

The penalized utility and score are

$$u_m(P)=C-\left(L_m(P)+\lambda_m L_m^{\mathrm{pen}}(P)\right),\qquad \Psi^{\mathrm{NP}}(P)=\prod_{m=1}^{M}u_m(P).$$

Here $L_m$ is a party-wise base loss (IGD in the main experiments), $\lambda_m>0$ controls concession enforcement, and the common constant $C$ must exceed every penalized loss. The implementation also permits zero weights for ablations.

## Distance convention and reference data

The main article defines normalized distance abstractly, without a numerical formula for its norm or objective scales. This implementation retains the repository's normalized Chebyshev convention as an explicit implementation choice:

$$D_m(x)=\min_{y\in PF_m}\max_k\frac{|f_{m,k}(x)-y_k|}{s_{m,k}},\qquad s_{m,k}>0.$$

Distances are computed in objective space to the supplied sampled individual front. This approximates deviation from the PS; it is not a decision-space distance calculation. Supply fixed positive objective scales, established from problem information or a fixed reference collection. Scales are never estimated from each candidate set. IGD and the optional GD use Euclidean distances in the supplied objective units, independently of these concession scales. GD here means the arithmetic mean of nearest Euclidean distances.

**Cross-evaluation is essential:** to compute $\Delta_m$, evaluate other parties' Pareto-optimal decision vectors through **DM m's objective function**. The coordinates of DM j's own front cannot substitute for $F_m(PS_j)$. This remains true when parties have the same number of objectives or identical-looking fronts.

For joint-objective columns ordered as `[F_1, F_2, ..., F_M]`, supply:

| Input | Meaning |
|---|---|
| `PopObj` | Finite, nonempty candidate objective matrix; one solution per row |
| `PF` | Cell `{m}` contains samples of DM m's individual front; different row counts and objective counts are supported |
| `dm_num` | Positive integer number of DMs |
| `gamma_threshold` | One concession threshold in `[0,1]` per DM |
| `lambda` | Nonnegative scalar or one weight per DM |
| `'C'` | Required fixed common positive utility constant |
| `'ObjectiveScale'` | Required positive vector over all objective columns |
| `'ReferenceSets'` | Cell `{j}` is the **full joint objective matrix** `F(PS_j)` |
| `'Delta'` | Alternative to `ReferenceSets`: precomputed nonnegative reference deviation per DM |
| `'ObjPerDM'` | Optional objective counts, scalar or vector; inferred from cell fronts, or equal matrix blocks |
| `'Metric'` | `'IGD'` (default), or `'GD'` |

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
├── tests/
│   ├── test_nash_score.m
|
└── README.md

---

**Implementation update:** Corrections to penalty accumulation, cross-party reference deviations and unequal objective counts may change the reproduced $\Psi^{\mathrm{NP}}$ scores, summary statistics, algorithm rankings and associated statistical comparisons for the paper's MPMOP and MPDMP experiments; the extent of any differences from the published results requires rescoring the original saved solution sets with the experimental settings.
