# Remove existing BiocManager if present
if ("BiocManager" %in% rownames(installed.packages()))
  remove.packages("BiocManager")

install.packages("BiocManager", repos="https://cran.rstudio.com")
library(BiocManager)

# Make sure Bioconductor version is 3.21
if (BiocManager::version() != "3.21") {
  BiocManager::install(version="3.21", update=TRUE, ask=FALSE)
}

# Install CRAN packages
cran_pkgs <- c(
  "ggplot2", "UpSetR", "ggthemes", "Seurat", "dplyr", 
  "devtools", "BiocManager", "scattermore", "survival", 
  "survminer", "spatstat", "reshape", "plotly"
)

for (pkg in cran_pkgs) {
  if (!pkg %in% rownames(installed.packages())) {
    install.packages(pkg, repos="https://cran.rstudio.com")
  }
}

# Install Bioconductor packages
bioc_pkgs <- c(
  "SingleCellExperiment", "lisaClust", "spicyR",
  "SPOTlight", "limma", "org.Hs.eg.db", "clusterProfiler",
  "scater", "scran", "simpleSeg", "ClassifyR"
)

for (pkg in bioc_pkgs) {
  if (!pkg %in% rownames(installed.packages())) {
    BiocManager::install(pkg, ask=FALSE, update=TRUE)
  }
}

# Install GitHub packages
if (!requireNamespace("devtools", quietly=TRUE))
  install.packages("devtools", repos="https://cran.rstudio.com")
library(devtools)

devtools::install_github("SydneyBioX/scFeatures")
devtools::install_github("SydneyBioX/scClassify")
