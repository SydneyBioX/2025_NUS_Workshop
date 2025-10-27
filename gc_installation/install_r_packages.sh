#!/bin/bash


sudo chmod -R 777 /usr/local/lib/R/site-library

#!/bin/bash
set -euo pipefail

# =========================
# Global R packages install
# =========================

# ---- 0) Preflight
if ! command -v sudo >/dev/null 2>&1; then
  echo "This script requires sudo. Please run it on a VM where you have sudo privileges."
  exit 1
fi

# ---- 1) System dependencies (Ubuntu/Debian)
echo "[*] Installing system dependencies..."
sudo apt-get update -y
sudo apt-get install -y \
  r-base r-base-dev \
  libcurl4-openssl-dev libssl-dev libxml2-dev \
  libfontconfig1-dev libharfbuzz-dev libfribidi-dev \
  libfreetype6-dev libpng-dev libtiff5-dev libjpeg-dev \
  libgit2-dev libglpk-dev libudunits2-dev libgdal-dev libgeos-dev libproj-dev \
  build-essential wget git

# ---- 2) Ensure global R site library is writable during install
SITE_LIB="/usr/local/lib/R/site-library"
echo "[*] Preparing global R library at ${SITE_LIB}..."
sudo mkdir -p "${SITE_LIB}"
sudo chmod -R 777 "${SITE_LIB}"

# ---- 3) Write the R installation script
R_INSTALL="/opt/install_global_R_packages.R"
echo "[*] Writing R installer to ${R_INSTALL}..."
sudo mkdir -p /opt
sudo tee "${R_INSTALL}" >/dev/null <<'RSCRIPT'
# =========================================================
# Global R package installation
# =========================================================

# Set global library path
.libPaths("/usr/local/lib/R/site-library")

options(repos = c(CRAN = "https://cran.rstudio.com"))

# Reinstall BiocManager cleanly
if ("BiocManager" %in% rownames(installed.packages())) {
  try(remove.packages("BiocManager"), silent = TRUE)
}
install.packages("BiocManager", lib="/usr/local/lib/R/site-library")
library(BiocManager)

# Ensure specific Bioconductor version
if (BiocManager::version() != "3.16") {
  BiocManager::install(version = "3.16", update = TRUE, ask = FALSE)
}

# CRAN packages
cran_pkgs <- c(
  "ggplot2", "UpSetR", "ggthemes", "Seurat", "dplyr",
  "devtools", "BiocManager", "scattermore", "survival",
  "survminer", "spatstat", "reshape", "plotly"
)

for (pkg in cran_pkgs) {
  if (!pkg %in% rownames(installed.packages(lib.loc="/usr/local/lib/R/site-library"))) {
    install.packages(pkg, lib="/usr/local/lib/R/site-library")
  }
}

# Bioconductor packages
bioc_pkgs <- c(
  "SingleCellExperiment", "lisaClust", "spicyR",
  "SPOTlight", "limma", "org.Hs.eg.db", "clusterProfiler",
  "scater", "scran", "simpleSeg", "ClassifyR"
)

for (pkg in bioc_pkgs) {
  if (!pkg %in% rownames(installed.packages(lib.loc="/usr/local/lib/R/site-library"))) {
    BiocManager::install(pkg, lib="/usr/local/lib/R/site-library", ask = FALSE, update = TRUE)
  }
}

# GitHub packages
if (!requireNamespace("devtools", quietly = TRUE))
  install.packages("devtools", lib="/usr/local/lib/R/site-library")
library(devtools)

devtools::install_github("SydneyBioX/scFeatures", lib="/usr/local/lib/R/site-library")
devtools::install_github("SydneyBioX/scClassify", lib="/usr/local/lib/R/site-library")
devtools::install_github("DarioS/ClassifyR", lib="/usr/local/lib/R/site-library")
RSCRIPT

# ---- 4) Run the R installer globally
echo "[*] Installing R packages globally (this may take a while)..."
sudo Rscript "${R_INSTALL}"

# ---- 5) Re-lock permissions (readable to all, writable by root)
echo "[*] Relocking ${SITE_LIB} permissions..."
sudo chmod -R 755 "${SITE_LIB}"

echo "[✓] Global R packages installation complete."
echo "[i] Test as a trainee user with:"
echo "    sudo -iu user1 R -q -e 'library(Seurat); library(scater); sessionInfo()'"
