### general path files
home_project=$new/sandro/HeP_samples # main path as starting to point to build further paths
sampletable="/users/valensan/phage_approach/supp_files/supp_table1.tsv" #tsv file with the samples
onlyhep="supp_files/hep.txt"
hepsafile="supp_files/hep_sa.txt"

#### software parameters
fscore=0.9 # confidence score for software
lfilt=2000 # minimum contig length for viruses (or in general)


## db
humgutdb=$new/software/unphage_humgutdb/k2/hg
humgutdb_m2=$new/software/unphage_humgutdb/m2/hg.mmi
UHGVDB=$new/software/UHGV_mqplus/blast/uhgv
HUMGUTTSV=$new/software/HumGutDB/HumGut.tsv
CHOCO2=$new/software/ChocoPhlan2

### enviroments & software paths
SOFT_HOME=$new/software
checkv_phageboost_env="prophages" # conda activate $checkv_phageboost_env
MPP_ENV="metaphapred" # conda activate $MPP_ENV
mpp_home=/scratch/project_2007362/software/MetaPhaPred
PHABOX_ENV="phabox2"
PDIR="$new/software/PhaBOX"
VIRUSTAXO_ENV=virustaxo
IPHOP_ENV=iphop
VRHYME_ENV=vRhyme
DVP_ENV=dvp
VS2_ENV=vs2
PROP_ENV=propagate
WAAFLE_ENV=waffle_env
HGTPHYLO_ENV=hgtphylo_env
