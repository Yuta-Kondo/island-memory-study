# 🧠 Island Memory Card Experiment

*Does treatment X improve memory‑card scores?*  
Course: **STA305 – Experimental Design** (Winter 2025)

| 🔧 Tech stack | ✨ Highlights |
|---------------|--------------|
| R (tidyverse, performance, MASS) | • One‑way ANOVA and RCB designs <br>• Box‑Cox transformation for non‑normality <br>• Publication‑quality plots with ggplot2 |
| Quarto        | Reproducible HTML/PDF report (`analysis.qmd`) |
| renv          | One‑command environment rebuild (`renv::restore()`) |

## Quick start

```bash
git clone https://github.com/YOUR‑HANDLE/island‑memory‑study.git
cd island‑memory‑study
R -e "install.packages('renv'); renv::restore()"
quarto render analysis.qmd
open analysis.html
```

> **Result in one line:** Treatment B raised mean memory‑card scores by **6.3 pts** (95 % CI 4.1 – 8.5) relative to control after age blocking.

![Boxplot of scores by treatment](outputs/figures/score_boxplot.png)
