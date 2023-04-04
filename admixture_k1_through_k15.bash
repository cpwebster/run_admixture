# The following script calls Plink 1.9 beta to perform linkage pruning on an input VCF file
# (compressed or uncompressed), then it removes chromosome names and any loci where >99.9% 
# of genotypes are missing. The resulting documents (.bed, .bim, .fam, .log, .nosex) are 
# then utilized with Admixture 1.3 to calculate statistics for ancestry coefficients of 1-15.

# [-------------]
#     USAGE:
# [-------------]

# bash admixture_k1_through_k15.bash -v <input_vcf_file> -o <output_file_prefix> -s <sample_names_output_file_prefix> 

# ------------
# Arguments
# ------------

while getopts ":v:o:s:" opt; do
  case ${opt} in

# Input VCF file
    v ) input_vcf_file="$OPTARG"
      ;;
# Output file prefix                                                                
    o ) output_prefix="$OPTARG"                                                
      ;; 
# Sample name output file prefix                                                     
    s ) sample_names_prefix="$OPTARG"                                                
      ;; 

    \? ) echo "Invalid option: -$OPTARG" 1>&2
      ;;
    : ) echo "Option -$OPTARG requires an argument." 1>&2
      ;;

  esac
done

# Load needed modules

module purge
module load plink/1.9.0
module load admixture/1.3.0

# ------------------
# Linkage prunning
# ------------------

# Identify linkage sites to be pruned (keeping indels)

plink --vcf ${input_vcf_file} --allow-extra-chr 0 --double-id --threads 8 --indep-pairwise 50 10 0.1 --out sites_to_be_prunned

# Generate Admixture input files with pruned linkage data

plink --vcf ${input_vcf_file} --extract sites_to_be_prunned.prune.in --make-bed --out for_admixture_prunned --allow-extra-chr --double-id

echo "[ ***Linkage prunning conducted*** ]"

# -------------------------
# Remove chromosome names
# -------------------------

# Admixture does not accept chromosome names that are not human chromosomes,
# exchange the first column by 0.

awk '{$1="0";print $0}' for_admixture_prunned.bim > for_admixture_prunned.bim.tmp
mv for_admixture_prunned.bim.tmp for_admixture_prunned.bim

echo "[ ***Removed chromosome names*** ]"

# --------------------------
# Remove missing genotypes
# --------------------------

# Filter and remove all loci where >99.9% genotypes are missing

plink --bfile for_admixture_prunned --geno 0.999 --make-bed --out ${output_prefix}

echo "[ ***Removed all loci where >99.9% genotypes are missing*** ]"

# Remove unneeded files, keep environment clean

rm for_admixture_prunned*
rm sites_to_be_prunned*

# -----------------------------------
# Collect sample names for plotting
# -----------------------------------

cut -f 1 ${output_prefix}.nosex > ${sample_names_prefix}.txt

echo "[ ***Sample names collected*** ]"

# ---------------------------
# Admixture analysis K=1-15
# ---------------------------

echo "[ ***Begin Admixture analysis*** ]"

# For loop to conduct admixture analysis with ancestry coefficients of 1-15

for i in {1..15}
do
admixture --cv ${output_prefix}.bed $i > ${output_prefix}_${i}.out
done

echo "[ ***All ancestry coefficients finished!*** ]"


