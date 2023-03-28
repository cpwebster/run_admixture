# run_admixture
The following scripts perform linkage prunning, run Admixture with ancestry coefficients of 1-15, and collect cross validation statistics. Additionally, R scripts are included to plot cross validation statistics with corresponding ancestry coefficients, and plot Admixture statistics with a specified ancestry coefficient.

Intended workflow: (run all in the same directory)
1) admixture_k1_through_k15.bash
2) parse_CVs.bash
3) plot_cross_validation.R
4) plot_admixture.R

#admixture_k1_through_k15.bash:

With a given VCF, this script calls Plink 1.9 beta to perform linkage pruning (window size = 50, step size = 10, r^2 threshold = 0.1) and filters all loci where >99.9% of genotypes are missing. Additionally, it generates a text file with sample names in the order they appear in the Plink 1.9 beta output files, which can later be used to plot the admixture statistics. Finally, admixture statistics for ancestry coefficients 1-15 care calculated. 

This can be run on either a compressed or uncompressed VCF, and is intended to be executed with an sbatch script and an HPC.

USAGE: bash admixture_k1_through_k15.bash -v <input_vcf_file> -o <output_file_prefix> -s <sample_names_output_file_prefix>

#parse_CVs.bash

This script will parse admixture cross validation statistics from admixture output files with each ancestry coefficient. Then, it will append to an output file that is ready to be plotted with 'plot_cross_validation.R'.

USAGE: bash parse_CVs.bash -o <output_file_prefix>

#plot_cross_validation.R

An R script that plots cross validation statistics with ancestry coefficients on a line graph. This script is intended to be used with Rstudio to tailor arguments as needed. This plot can be used to infer which ancestry coefficient is best representative of the data.

#plot_admixture.R

An R script that sorts and plots the admixture statistics for a specified ancestry coefficient. This script is written for K=5, but code can be altered for your specified K value (execute with Rstudio to tailor executions). Requirements include the text file with sample names and the specified .Q file that were generated with 'admixture_k1_through_k15.bash'.



