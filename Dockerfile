FROM rocker/rstudio:4.6

RUN apt-get update && apt-get install -y --no-install-recommends \
  libcurl4-openssl-dev \
  libssl-dev \
  libxml2-dev \
  libglpk40 \
  libbz2-dev \
  && rm -rf /var/lib/apt/lists/*
  
RUN install2.r --error --skipinstalled --ncpus -1 \
  SeuratObject \
  Matrix \
  readr \
  dplyr \
  sctransform \
  usethis \
  stringr \
  networkD3 \
  BiocManager \
  pak \
  && rm -rf /tmp/downloaded_packages
  
RUN R -e 'pkgs <- c("DropletUtils", "biomaRt", "SingleR", "celldex", "scater", "scrapper"); \
  BiocManager::install(pkgs, ask = FALSE, update = FALSE); \
  for (pkg in pkgs) loadNamespace(pkg)'
  
RUN R -e 'pak::pkg_install(c("pcahan1/singleCellNet", "immunogenomics/presto"))' \
  && rm -rf /tmp/downloaded_packages
  
RUN Rscript -e 'pak::pkg_install("Seurat@5.6.0")' \
  && Rscript -e 'library(Seurat); stopifnot(packageVersion("Seurat") == "5.6.0")'