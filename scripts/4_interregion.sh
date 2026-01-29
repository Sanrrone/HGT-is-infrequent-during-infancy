#!/bin/bash
#   
#SBATCH --job-name=4_interregion
#SBATCH --output=log/s4_%a.log
#SBATCH --error=err/s4_%a.err
#SBATCH --partition=small
#SBATCH --account=Project_2007362
#SBATCH --time=02:15:00
#SBATCH --array=47
#SBATCH --mem=250G
#SBATCH --cpus-per-task=2
 
c=$(nproc)
n=$SLURM_ARRAY_TASK_ID
 
source global_env.sh
 
sname=`sed -n "${n} p" $hepsafile`
 
prev=$(pwd)
cd ${home_project}/13_horizontal_gene_transfer
rm -rf 4_interregion/${sname}
mkdir -p  4_interregion/${sname}
#bed format
#k141_22086     389     493     1128111_Veillonella_atypica__l_00001    0       -
#HeP-1003_6_months      k141_24659      1       727
#grep -w ${sname} supp_files/all_intergenic_regions.tsv | awk -F'\t' '{if($4-$3 > 1)print $2"\t"$3"\t"$4"\t"$2"__ir_"NR"\t0\t-"}' > ${home_project}/13_horizontal_gene_transfer/4_interregion/${sname}/${sname}_interregion.bed
#50bp as minimum interegion length
 
cd 4_interregion/${sname}
awk -F"\t" '
{
    chr   = $1
    start = $2
    end   = $3
    gene  = $4
 
    # New contig
    if (NR == 1 || chr != prev_chr) {
        # Start-of-contig fake region: 1 .. (first_gene_start-1)
        if (start > 1) {
            inter_start = 1
            inter_end   = start - 1
            len = inter_end - inter_start + 1
            if (len >= 50) {
                printf "%s\t%d\t%d\tSTART__%s\t0\t-\n",
                       chr, inter_start, inter_end, gene
            }
        }
    } else {
        # Internal intergenic region between previous gene and this gene
        inter_start = prev_end + 1
        inter_end   = start - 1
        len = inter_end - inter_start + 1
        if (len >= 50) {
            printf "%s\t%d\t%d\t%s__%s\t0\t-\n",
                   chr, inter_start, inter_end, prev_gene, gene
        }
    }
 
    prev_chr  = chr
    prev_end  = end
    prev_gene = gene
}
' ${home_project}/13_horizontal_gene_transfer/3_passgenes/${sname}_genecoords.bed > ${sname}_intergenic.bed
 
cd $prev
ls ${home_project}/2_fixed/${sname}_bams/*bam |
        xargs -P 3 -n 1 -I {} bash ./getgenecovs.sh {} ${sname}_intergenic.bed ${home_project}/13_horizontal_gene_transfer/4_interregion/${sname}
 
wait
 
echo "Done :D"
