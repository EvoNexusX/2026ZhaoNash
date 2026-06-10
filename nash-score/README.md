# Nash Score

Nash Score is a performance metric for **Multi-Party Multi-Objective Optimization (MPMOO)**. It combines per-decision-maker convergence quality with concession-based penalties and aggregates individual utilities via a product formulation.

**Higher scores are better.** The returned score is the raw product of decision-maker utilities and is **not** rescaled or normalized afterward.

## Metric Definition

Consider a problem with $M$ decision makers. Decision maker $m$ has objective sub-vector $\mathbf{f}^{(m)}(\mathbf{x})$ and Pareto front $PF_m$.

| Symbol | Meaning |
|--------|---------|
| $f_i^{\max}$ | Maximum value of objective $i$ in the feasible range (estimated from PF and the candidate set) |
| $\text{offset}(\mathbf{x}, \mathbf{y})$ | $\max_i \lvert f_i(\mathbf{x}) - f_i(\mathbf{y}) \rvert / f_i^{\max}$ |
| $\text{offset}(\mathbf{x}, PF_m)$ | $\min_{\mathbf{y} \in PF_m} \text{offset}(\mathbf{x}, \mathbf{y})$ |
| $\text{max\_offset}_m$ | Maximum offset from other DMs' PFs to $PF_m$ |
| $\varepsilon_m(\mathbf{v})$ | Concession: $\text{offset}(\mathbf{v}, PF_m) / \text{max\_offset}_m$ |
| $\varphi(\varepsilon)$ | Penalty: $\max(0,\, \varepsilon - \varepsilon_m^{\text{threshold}})$ |
| $\mu_m^{\text{ref}}$ | Maximum Euclidean distance from any point on other DMs' PFs to $PF_m$ (defaults to 1 when zero) |
| $\mu_m$ | Convergence measure based on IGD or GD |
| $\lambda_m$ | User-defined penalty weight for decision maker $m$ |

For each decision maker $m$:

1. **Point penalty:** $\ell_m^{\text{pen}}(\mathbf{v}) = \mu_m^{\text{ref}} \cdot \varphi(\varepsilon_m(\mathbf{v}))$
2. **Population penalty:** $L_m^{\text{pen}}(P) = \mathrm{mean}_{\mathbf{v} \in P}(\ell_m^{\text{pen}}(\mathbf{v}))$
3. **Total loss:** $L_m(P) = \mu_m(P) + \lambda_m \cdot L_m^{\text{pen}}(P)$
4. **Utility:** $\text{utility}_m = \exp(-L_m(P))$

**Nash Score:**

$$\text{Nash Score} = \prod_{m=1}^{M} \text{utility}_m$$

The output is this product directly. No additional normalization is applied to the final score.

## Files

| File | Description |
|------|-------------|
| `nash_score.m` | Main entry point: compute Nash Score from a candidate set and PF |
| `compute_offset_to_pf.m` | Helper: normalized Chebyshev offset from points to a PF |

## Requirements

- MATLAB R2016b or later
- Statistics and Machine Learning Toolbox (`pdist2`)

## Quick Start

```matlab
addpath('path/to/nash-score');

% PopObj: [n_pop x M] objective matrix of the candidate set
% PF:     [n_pf  x M] union Pareto front
% dm_num: number of decision makers
% epsilon: [1 x dm_num] concession thresholds
% lambda:  user-defined penalty weight (scalar or [1 x dm_num] vector)

dm_num = 2;
epsilon = [0, 0];
lambda = 10;

score = nash_score(PopObj, PF, dm_num, epsilon, lambda);

[score, details] = nash_score(PopObj, PF, dm_num, epsilon, lambda, ...
    'Metric', 'GD');

fprintf('Nash Score = %.6f\n', score);
disp(details.utility);
disp(details.L_m);
```

### Input Layout

- Columns of `PopObj` and `PF` are ordered by decision maker. With `dm_num` decision makers and $k$ objectives each, the total number of columns is $M = \text{dm\_num} \times k$.
- Decision maker $m$ uses columns `(m-1)*k+1 : m*k`.
- `epsilon_values` must have length `dm_num`.
- `lambda` must be a non-negative scalar (shared by all decision makers) or a `[1 x dm_num]` vector.

### Optional Parameters

| Parameter | Default | Description |
|-----------|---------|-------------|
| `'Metric'` | `'IGD'` | Convergence measure: `'IGD'` or `'GD'` |
| `'ObjPerDM'` | inferred | Number of objectives per decision maker |
| `'PFSampleSize'` | `2000` | PF subsampling limit for IGD/GD and offset computation |
| `'OffsetPFSample'` | `5000` | PF subsampling limit inside `compute_offset_to_pf` |

## Design Notes

- **Normalized offset:** Objectives are scaled by $f_i^{\max}$ so different scales are comparable when measuring concession.
- **Concession penalty:** Solutions that exceed a decision maker's concession threshold are penalized.
- **Product aggregation:** Multiplying utilities encourages balanced satisfaction across decision makers—a poor result for any single decision maker strongly reduces the overall score.

## Citation

If you use Nash Score in your research, please cite the associated paper (TBD).

## License

MIT License (modify as needed)
