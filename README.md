# 🏝️ Island Memory Card Experiment — do caffeine or cocaine sharpen short‑term memory?

**Reproducible R workflow for Experimental Design Course**
We blocked 150 islanders by age (18‑24 / 25‑44 / 45‑65) and randomised them to one of five treatments—cocaine, regular energy drink, caffeine‑free energy drink, sugar‑free energy drink, or water—before testing short‑term memory with a card‑matching game.
**Headline result:** *none of the stimulants produced a statistically significant change in scores; age was the only meaningful predictor.*

---

## 🔍 What’s inside

| 🔧 Tech stack                                 | ✨ Highlights                                                                                                                                          |
| --------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------- |
| **R** (tidyverse, MASS, performance, ggplot2) | • One‑way ANOVA & randomised complete block (RCB) models  <br>• Box‑Cox transformation to rescue normality  <br>• Publication‑ready plots via ggplot2 |
| **renv**                                      | One‑command environment rebuild → `renv::restore()`                                                                                                   |
| **GitHub Actions**                            | Continuous R‑CMD‑check & Quarto render                                                                                                                |

---

## 🚀 Quick start

```bash
# clone & enter
git clone https://github.com/Yuta-Kondo/island-memory-study.git
cd island-memory-study

# bootstrap R environment (≈1‑2 min)
R -e "install.packages('renv'); renv::restore()"

# knit the full analysis
quarto render analysis.qmd
open analysis.html  # or just click it
```

---

## 📂 Repo layout

```
├── data/             # raw & processed CSVs
├── R/                # modular helper functions
├── analysis.qmd      # end‑to‑end notebook
├── outputs/          # figures & knitted report
└── renv.lock         # package versions
```

---

## 📜 License

Code is released under the MIT License — see [LICENSE](LICENSE) for details.
Dataset (`data/raw/island_data.csv`) is part of a simulated coursework assignment; you may use it freely for learning and demonstration purposes but **not** redistribute it as real‑world data.