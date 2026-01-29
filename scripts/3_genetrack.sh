#!/bin/bash
#
#SBATCH --job-name=3_trackhgt
#SBATCH --output=log/s3_%a.log
#SBATCH --error=err/s3_%a.err
#SBATCH --partition=small
#SBATCH --account=Project_2007362
#SBATCH --time=02:15:00
#SBATCH --array=47
#SBATCH --mem=250G
#SBATCH --cpus-per-task=3
 
c=$(nproc)
 
source global_env.sh
 
n=$SLURM_ARRAY_TASK_ID
sname=`sed -n "${n} p" $hepsafile`
 
prev=$(pwd)
cd ${homep}/13_horizontal_gene_transfer/3_passgenes
rm -rf ${sname} && mkdir ${sname}
awk -F"\t" -v hep=${sname} '{if($3!="CDS")next;split($9,a,";");gsub("ID=","",a[1]);print $1"\t"$4"\t"$5"\t"a[1]"\t111\t"hep}' ${homep}/7_fixed/${sname}/annot/${sname}.gff > ${sname}_genecoords.bed
cd $prev
set -ex
ls ${homep}/2_fixed/${sname}_bams/*bam |
        xargs -P 3 -n 1 -I {} bash ./getgenecovs.sh {} ${homep}/13_horizontal_gene_transfer/3_passgenes/${sname}_genecoords.bed ${homep}/13_horizontal_gene_transfer/3_passgenes/${sname}
 
wait
 
echo "Done :D"

