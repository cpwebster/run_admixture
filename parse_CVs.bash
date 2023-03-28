# This script reads output files (.out) from running Admixture, collects cross 
# validation statistics, and appends them to a separate tab delimited text 
# document with ancestry coefficients and a header. This output file is intended 
#to be used with the script 'plot_cross_validation.R'.

# [-------------]
#     USAGE:
# [-------------]

# bash parse_CVs.bash -o <output_file_prefix>

# ------------
# Arguments
# ------------

while getopts ":o:" opt; do
  case ${opt} in

# Output file prefix argument
    o ) output_file_name="$OPTARG"
      ;;

    \? ) echo "Invalid option: -$OPTARG" 1>&2
      ;;
    : ) echo "Option -$OPTARG requires an argument." 1>&2
      ;;

  esac
done

# --------------
# Begin script
# --------------

# Create new output file
touch ${output_file}.txt

# Create a header for output file
echo -e 'CV\tK' > ${output_file_name}.txt

# For loop to run through every admixture output file (.out)
for f in *.out
do cat $f | grep 'CV error' | sed -e 's|^CV error (K=||' -e 's|): |\t|' >> ${output_file_name}.txt
done



