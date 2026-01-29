#!/bin/bash
#
#SBATCH --job-name=2_hgtAnalyze
#SBATCH --output=log/s2_a_%a.log
#SBATCH --error=err/s2_a_%a.err
#SBATCH --partition=small
#SBATCH --account=Project_2007362
#SBATCH --time=02:00:00
#SBATCH --array=47
#SBATCH --mem=30G
#SBATCH --cpus-per-task=1

 
n=$SLURM_ARRAY_TASK_ID
c=$(nproc)
 
source global_env.sh
 
sname_assembly=`sed -n "${n} p" $hepsafile`
mags=${home_project}/7_fixed/${sname_assembly}/${sname_assembly}_pass.fna
SDIR=${SOFT_HOME}/HGTectorDB
 
export PATH=$new/software/mambaforge/bin:$PATH
eval "$(conda shell.bash hook)"
conda activate hgtector
##############################################################################################
 
cd ${home_project}/13_horizontal_gene_transfer/2_hgtector/${sname_assembly}
 
#annot bacts
set -ex
 
#predict hgt
rm -rf out_*
hgtector analyze -i hgt_${sname_assembly} -o out_${sname_assembly} -t $SDIR/taxdump  --maxhits 100 --evalue 1e-50 --identity 80 --coverage 80
mv out_${sname_assembly}/scores.tsv ${sname_assembly}_hgtector2.tsv
rm -rf out_*


