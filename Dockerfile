FROM ubuntu:latest
CMD ["bash"]
ENV R_VERSION=4.1.0
ENV TERM=xterm
ENV LC_ALL=en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV R_HOME=/usr/local/lib/R
ENV CRAN=https://packagemanager.rstudio.com/cran/__linux__/focal/2021-08-09
ENV TZ=Etc/UTC
ADD rocker_scripts /
ADD shallowHRD /home/
COPY rocker_scripts/ /rocker_scripts/
COPY shallowHRD /home/shallowHRD/
RUN /rocker_scripts/install_R.sh
CMD ["R"]
RUN echo "options(repos = 'https://cloud.r-project.org')" > $(R --no-echo --no-save -e "cat(Sys.getenv('R_HOME'))")/etc/Rprofile.site
ENV RETICULATE_MINICONDA_ENABLED=FALSE
RUN apt-get update
RUN apt-get install -y\
     libhdf5-dev\
     libcurl4-openssl-dev\
     libssl-dev\
     libpng-dev\
     libboost-all-dev\
     libxml2-dev\
     openjdk-8-jdk\
     python3-dev\
     python3-pip\
     wget\
     git\
     libfftw3-dev\
     libgsl-dev\
     libgeos-dev\
     pkg-config\
     tk
RUN apt-get install -y clang lldb lld
RUN apt-get install -y cmake
RUN LLVM_CONFIG=/usr/lib/llvm-10/bin/llvm-config pip3 install llvmlite
RUN pip3 install numpy
RUN pip3 install umap-learn
RUN git clone --branch v1.2.1 https://github.com/KlugerLab/FIt-SNE.git
RUN g++ -std=c++11 -O3 FIt-SNE/src/sptree.cpp FIt-SNE/src/tsne.cpp FIt-SNE/src/nbodyfft.cpp  -o bin/fast_tsne -pthread -lfftw3 -lm
RUN R --no-echo --no-restore --no-save -e "install.packages('/home/shallowHRD/zlibbioc_1.42.0.tar.gz',repos = NULL, type='source')"
RUN R --no-echo --no-restore --no-save -e "install.packages('/home/shallowHRD/Rhtslib_1.99.5.tar.gz',repos = NULL, type='source')"
RUN R --no-echo --no-restore --no-save -e "install.packages('BiocManager')"
RUN R --no-echo --no-restore --no-save -e "BiocManager::install('Rsamtools')"
RUN R --no-echo --no-restore --no-save -e "BiocManager::install('GenomicAlignments')"
RUN R --no-echo --no-restore --no-save -e "BiocManager::install('rtracklayer')"
RUN R --no-echo --no-restore --no-save -e "BiocManager::install(c('multtest', 'S4Vectors', 'SummarizedExperiment', 'SingleCellExperiment', 'MAST', 'DESeq2', 'BiocGenerics', 'GenomicRanges', 'IRanges', 'rtracklayer', 'monocle', 'Biobase', 'limma'))"
RUN R --no-echo --no-restore --no-save -e "install.packages(c('VGAM', 'R.utils', 'metap', 'Rfast2', 'ape', 'enrichR', 'mixtools'))"
RUN R --no-echo --no-restore --no-save -e "install.packages('hdf5r')"
RUN R --no-echo --no-restore --no-save -e "install.packages('remotes')"
RUN R --no-echo --no-restore --no-save -e "install.packages(c('Seurat','SeuratObject'))"
RUN R --no-echo --no-restore --no-save -e "remotes::install_github('mojaveazure/seurat-disk')"
RUN R --no-echo --no-restore --no-save -e "BiocManager::install(c('ggpubr','DescTools'))"
RUN R --no-echo --no-restore --no-save -e "install.packages('/home/shallowHRD/mclust_5.4.10.tar.gz',repos = NULL, type='source')"
RUN R --no-echo --no-restore --no-save -e "install.packages('/home/shallowHRD/multicool_0.1-12.tar.gz',repos = NULL, type='source')"
RUN R --no-echo --no-restore --no-save -e "install.packages('/home/shallowHRD/pracma_2.4.2.tar.gz',repos = NULL, type='source')"
RUN R --no-echo --no-restore --no-save -e "install.packages('/home/shallowHRD/misc3d_0.9-1.tar.gz',repos = NULL, type='source')"
RUN R --no-echo --no-restore --no-save -e "install.packages('/home/shallowHRD/plot3D_1.4.tar.gz',repos = NULL, type='source')"
RUN R --no-echo --no-restore --no-save -e "install.packages('/home/shallowHRD/ks_1.13.5.tar.gz',repos = NULL, type='source')"
CMD ["R"]
