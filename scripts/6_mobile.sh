#!/bin/bash
#   
#SBATCH --job-name=6_mobile
#SBATCH --output=log/s6.log
#SBATCH --error=err/s6.err
#SBATCH --partition=small
#SBATCH --account=Project_2007362
#SBATCH --time=2:00:00
#SBATCH --mem=5G
#SBATCH --cpus-per-task=4
 
c=$(nproc)
 
source global_env.sh
 
export PATH=$new/software/mambaforge/bin:$PATH
eval "$(conda shell.bash hook)"
conda activate isescan
hgtc="supp_files/hgt_candidates.tsv"
 
rm -rf ${home_project}/13_horizontal_gene_transfer/6_mobile
mkdir -p  ${home_project}/13_horizontal_gene_transfer/6_mobile
cp $hgtc ${home_project}/13_horizontal_gene_transfer/6_mobile/.
cd ${home_project}/13_horizontal_gene_transfer/6_mobile
 
hgtc="hgt_candidates.tsv"
ml seqtk
 
for h in $(cut -f1 $hgtc | sort -u)
do
        echo "working in $h"
        awk -F"\t" -v h=$h '{if($1==h)print $2}' $hgtc | sort -u > ids.txt
        cat ids.txt | while read sp
        do
                grep "__${sp}__" $new/sandro/HeP_samples/7_fixed/$h/${h}_pass.fna | sed "s/>//g"
        done > spids.txt
        seqtk subseq $new/sandro/HeP_samples/7_fixed/$h/${h}_pass.fna spids.txt > tmp_sp.fna
        isescan.py --seqfile tmp_sp.fna --output ${h} --nthread $c
        #rm -f ids.txt spids.txt tmp_sp.fna
 
done
echo "Done :D"

