# HRD
HRD for whole genome
# For Container:
Steps:
1) Goto home dir
echo "alias image2df='docker run --rm -v /var/run/docker.sock:/var/run/docker.sock cucker/image2df'" >> ~/.bashrc

2) Make sure docker is installed and check if added to the regular user group:

sudo groupadd docker

sudo usermod -aG docker ubuntu


3)Switch to root
sudo -i

4) Then execute:
image2df thugenomefacility/shallowhrd:1.13

5) From the output of step4 extract all the lines contained below #=====Dockerfile==========, and paste to a new ‘Dockerfile’

The lines appear as below:
# ========== Dockerfile ==========
FROM thugenomefacility/shallowhrd:1.13
ADD file:524e8d93ad65f08a0cb0d144268350186e36f508006b05b8faf2e1289499b59f in /
CMD ["bash"]
LABEL org.opencontainers.image.licenses=GPL-2.0-or-later org.opencontainers.image.source=https://github.com/rocker-org/rocker-versioned2 org.opencontainers.image.vendor=Rocker Project org.opencontainers.image.authors=Carl Boettiger <cboettig@ropensci.org>
ENV R_VERSION=4.1.0
ENV TERM=xterm
ENV LC_ALL=en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV R_HOME=/usr/local/lib/R
ENV CRAN=https://packagemanager.rstudio.com/cran/__linux__/focal/2021-08-09
ENV TZ=Etc/UTC
COPY scripts /rocker_scripts # buildkit
RUN RUN /rocker_scripts/install_R.sh # buildkit
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
     libgsl-dev
RUN apt-get install -y llvm-10
RUN LLVM_CONFIG=/usr/lib/llvm-10/bin/llvm-config pip3 install llvmlite
RUN pip3 install numpy
RUN pip3 install umap-learn
RUN git clone --branch v1.2.1 https://github.com/KlugerLab/FIt-SNE.git
RUN g++ -std=c++11 -O3 FIt-SNE/src/sptree.cpp FIt-SNE/src/tsne.cpp FIt-SNE/src/nbodyfft.cpp  -o bin/fast_tsne -pthread -lfftw3 -lm
RUN R --no-echo --no-restore --no-save -e "install.packages('BiocManager')"
RUN R --no-echo --no-restore --no-save -e "BiocManager::install(c('multtest', 'S4Vectors', 'SummarizedExperiment', 'SingleCellExperiment', 'MAST', 'DESeq2', 'BiocGenerics', 'GenomicRanges', 'IRanges', 'rtracklayer', 'monocle', 'Biobase', 'limma'))"
RUN R --no-echo --no-restore --no-save -e "install.packages(c('VGAM', 'R.utils', 'metap', 'Rfast2', 'ape', 'enrichR', 'mixtools'))"
RUN R --no-echo --no-restore --no-save -e "install.packages('hdf5r')"
RUN R --no-echo --no-restore --no-save -e "install.packages('remotes')"
RUN R --no-echo --no-restore --no-save -e "install.packages('Seurat')"
RUN R --no-echo --no-restore --no-save -e "remotes::install_github('mojaveazure/seurat-disk')"
CMD ["R"]
/bin/bash


6) Modify the above file to get the below file (Make sure rocker_scripts and shallowHRD folders are under your working dir):

###—Modified-DockerFile####
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

7) build docker image

docker build -t hrd:1.13 . > hrd_dockerBuild.log 2>&1 &

8) build singularity sandbox of local docker image. Sandbox are best to test first before creating an image out of it.

singularity build --sandbox hrd_v1.13_sandbox docker-daemon://hrd:1.13

9) build container from sandbox
singularity build hrd_v1.13.sif hrd_v1.13_sandbox

# Execution:
singularity exec --bind /mnt/data/QDNAseq/:/data hrd_v1.13.sif /home/shallowHRD/shallowHRD_hg19_1.13_QDNAseq_chrX_noM.R /data/HG004_35x_sort.bam_ratio.txt /data /data/cytoband_adapted_hg19.csv  > log 2>&1 &

# Inputs:
Input is the bam_ratio output from QDNASeq: HG004_35x_sort.bam_ratio.txt (attached above)
Supporting input: cytoband_adapted_hg19.csv (attached above)

# Outputs(tarred):
output.tar.gz contains:
HG004_35x_sort_II.jpeg
HG004_35x_sort_III.jpeg
HG004_35x_sort_IV.jpeg
HG004_35x_sort_IV.txt
HG004_35x_sort_LGAs.jpeg
HG004_35x_sort_LGAs.txt
HG004_35x_sort_LGAs_intermediary.jpeg
HG004_35x_sort_THR.jpeg
HG004_35x_sort_THR_intermediary.jpeg
HG004_35x_sort_amplification_deletion_table.txt
HG004_35x_sort_amplifications_deletions.jpeg
HG004_35x_sort_beginning_segmentation.jpeg
HG004_35x_sort_final_segmentation.jpeg
HG004_35x_sort_final_segmentation.txt
HG004_35x_sort_final_segmentation_intermediary.jpeg
HG004_35x_sort_final_segmentation_visual.jpeg
HG004_35x_sort_final_segmentation_zoomed.jpeg
HG004_35x_sort_normalised_read_count.jpeg
HG004_35x_sort_number_LGAs.txt
HG004_35x_sort_ratio_median_gathered.txt
HG004_35x_sort_summary_plot.jpeg
Rplots.pdf
log









