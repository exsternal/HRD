# HRD
HRD for whole genome
# For Container:
Steps:
1) Pull docker image from https://hub.docker.com/r/cucker/image2df

2) Goto home dir
     echo "alias image2df='docker run --rm -v /var/run/docker.sock:/var/run/docker.sock cucker/image2df'" >> ~/.bashrc

3) Make sure docker is installed and check if added to the regular user group:

     sudo groupadd docker

     sudo usermod -aG docker ubuntu


4)   Switch to root
     sudo -i

5)   Execute image2df:
     
     image2df thugenomefacility/shallowhrd:1.13
     
     Note:The above command would yield a dockerfile content on stdout. Place it under a new Dockerfile_prior (attached above)


6)   Dockerfile_prior edited to Dockerfile.

7)   Place rocker_scripts and shallowHRD folders are under your working dir. Note: Their tar.gzs are attached above. Do tar -zxvf them for use:

8)   build docker image (this will validate dockerfile)

     docker build -t hrd:1.13 . > hrd_dockerBuild.log 2>&1 &

9)   build singularity sandbox of local docker image. Sandbox are best to test first before creating an image out of it.

     singularity build --sandbox hrd_v1.13_sandbox docker-daemon://hrd:1.13

10)  build container from sandbox
     singularity build hrd_v1.13.sif hrd_v1.13_sandbox

# Execution:
singularity exec --bind /mnt/data/QDNAseq/:/data hrd_v1.13.sif /home/shallowHRD/shallowHRD_hg19_1.13_QDNAseq_chrX_noM.R           /data/HG004_35x_sort.bam_ratio.txt /data /data/cytoband_adapted_hg19.csv  > log 2>&1 &

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









