# Machine Learning from Human Preferences
### Sang Truong, Andreas Haupt, and Sanmi Koyejo

This book is available online at: [mlhp.stanford.edu](https://mlhp.stanford.edu/)

## Prerequisites

Before building the book, ensure you have the following installed:

- **Quarto** >= 1.5.56 (CI uses this version)
- **Python** >= 3.8
- **R** >= 4.3.1

## Installation

### 1. Install Quarto

- **macOS (Homebrew):** `brew install quarto`
- **macOS/Windows:** Download from https://quarto.org/docs/get-started/

### 2. Install Python

- **macOS:** `brew install python`
- **Windows:** Download from https://www.python.org/downloads/

### 3. Install R

- **macOS:** `brew install r`
- **Windows:** Download from https://cran.r-project.org/

### 4. Clone the repository

```bash
git clone https://github.com/sangttruong/mlhp
cd mlhp
```

### 5. Install Python dependencies

```bash
pip install -r requirements.txt
```

### 6. Install R dependencies (one-time setup)

```bash
R -e "renv::restore()"
```

Or interactively:
```bash
R
> renv::restore()
> q()
```

### 7. Install Quarto extensions (one-time setup)

The book uses two Quarto extensions for interactive Python code and pseudocode rendering:

```bash
cd mlhp
quarto add coatless/quarto-pyodide --no-prompt
quarto add leovan/quarto-pseudocode --no-prompt
```

This will create an `_extensions/` directory with the required extensions.

## Building the Book

### Preview (development)

To preview the book locally with live reload:

```bash
quarto preview
```

Then open http://localhost:4200/ in your browser.

### Build HTML

```bash
quarto render --to html --profile html
```

### Build PDF

```bash
quarto render --to pdf --profile pdf
```

### Build both HTML and PDF

```bash
quarto render --to pdf --profile pdf
quarto render --to html --profile html --no-clean
```

### Build Slides

The book includes lecture slides in `src/slides/`. To build them:

```bash
quarto render src/slides/
```

Slides are output to `_book/slides/` and organized by topic (e.g., `1.introduction`, `2.1.choice_models`, etc.).

The built website will be stored in the `_book/` folder.

## Publishing

After completing edits and building:

```bash
git add .
git commit -m "your commit message"
git push origin main
```

The GitHub Actions workflow will automatically build and publish to GitHub Pages.

## Server Deployment (Stanford)

To build and deploy on the Stanford server without compiling locally:

### One-time setup

1. Create a conda environment with Quarto:

```bash
conda create -n mlhp python=3.11 quarto=1.5.56 -c conda-forge
conda activate mlhp
pip install -r requirements.txt
```

2. Clone the repository to the server:

```bash
cd /lfs/skampere2/0/sttruong
git clone https://github.com/sangttruong/mlhp
```

### Deploying updates

Run the deploy script:

```bash
./deploy.sh
```

This will:
1. Pull the latest changes from git
2. Build HTML book
3. Build PDF book
4. Build lecture slides
5. Sync everything to `/afs/cs/group/koyejolab/mlhp/www/`

**Note:** The deploy script handles the fact that each `quarto render` clears the `_book/` directory by using temporary storage to preserve outputs between builds.

Alternatively, run the steps manually:

```bash
source /lfs/local/0/sttruong/miniconda3/etc/profile.d/conda.sh
conda activate mlhp
cd /lfs/skampere2/0/sttruong/mlhp
git pull

# Build HTML
quarto render --to html --profile html

# Build PDF (in separate _book directory to avoid conflicts)
quarto render --to pdf --profile pdf

# Build slides
quarto render src/slides/

# Sync all to www
rsync -av --delete _book/ /afs/cs/group/koyejolab/mlhp/www/
```

**Note:** If running manually and you need both HTML and PDF, you may need to render them separately and sync after each step, as each render clears `_book/`.

## Troubleshooting

- **Quarto version issues:** Ensure you have Quarto >= 1.5.56. Check with `quarto --version`.
- **Missing filter errors (pyodide, pseudocode):** Install the required Quarto extensions:
  ```bash
  quarto add coatless/quarto-pyodide --no-prompt
  quarto add leovan/quarto-pseudocode --no-prompt
  ```
- **R package issues:** Run `renv::restore()` in R to reinstall dependencies.
- **Python package issues:** Run `pip install -r requirements.txt` to reinstall dependencies.
- **LaTeX/PDF issues:** The CI uses TinyTeX. Install with `quarto install tinytex`.

## Reproducibility

This book is designed to be reproducible. Key version recommendations:

- **Python:** 3.11 (used in CI)
- **R:** 4.3.1 (locked in renv.lock)
- **Quarto:** 1.5.56

### Clearing caches

If you upgrade dependencies or encounter stale results, clear the caches:

```bash
rm -rf _freeze/ src/.jupyter_cache/ _book/
quarto render --to html --profile html
```

## License

This book is licensed [CC-BY-NC 4.0](https://creativecommons.org/licenses/by-nc/4.0/).
