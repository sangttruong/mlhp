#!/bin/bash
set -e

# Activate conda environment
source /lfs/local/0/sttruong/miniconda3/etc/profile.d/conda.sh
conda activate mlhp

# Navigate to project
cd /lfs/skampere2/0/sttruong/mlhp

# Pull latest changes
git pull

# Note: Each quarto render clears _book/, so we need to preserve outputs
# between renders by syncing to a temporary location

# Build HTML (this populates _book/ with HTML)
echo "Building HTML..."
quarto render --to html --profile html

# Copy HTML to temp location
cp -r _book /tmp/mlhp_html_$$

# Build PDF (this clears _book/ and adds PDF)
echo "Building PDF..."
quarto render --to pdf --profile pdf

# Copy PDF to temp location
cp _book/Machine-Learning-from-Human-Preferences.pdf /tmp/mlhp_pdf_$$.pdf

# Build slides (this clears _book/ and adds slides)
echo "Building slides..."
quarto render src/slides/

# Now restore everything to _book/
echo "Combining outputs..."
cp -r /tmp/mlhp_html_$$/* _book/
cp /tmp/mlhp_pdf_$$.pdf _book/Machine-Learning-from-Human-Preferences.pdf

# Clean up temp files
rm -rf /tmp/mlhp_html_$$
rm /tmp/mlhp_pdf_$$.pdf

# Deploy book + slides to www
echo "Deploying to www..."
rsync -av --delete _book/ /afs/cs/group/koyejolab/mlhp/www/

echo "Deployed successfully!"
