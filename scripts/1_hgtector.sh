#!/bin/bash
#
#SBATCH --job-name=1_hgtector
#SBATCH --output=log/s1_%a.log
#SBATCH --error=err/s1_%a.err
#SBATCH --partition=small
#SBATCH --account=Project_2007362
#SBATCH --time=04:00:00
#SBATCH --array=47
#SBATCH --mem=30G
#SBATCH --cpus-per-task=4

 
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
 
cd ${home_project}/13_horizontal_gene_transfer
mkdir -p 2_hgtector
cd 2_hgtector
rm -rf ${sname_assembly} && mkdir ${sname_assembly}
cd ${sname_assembly}
 
mkdir -p $new/tmp/${sname_assembly}
tmpf=$new/tmp/${sname_assembly}
 
hgtector search -i ${homep}/7_fixed/${sname_assembly}/annot/${sname_assembly}.faa -o hgt_${sname_assembly} -m diamond -p $c -d $SDIR/diamond/db -t $SDIR/taxdump --tmpdir $tmpf
 
