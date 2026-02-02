# HGT-is-infrequent-during-infancy
Repository for data availability

## Software used
We understand the complexity of having a pipeline and what it means for the installation. That's why we work with containers. the installation as simple as download a big file using wget (or your favorite command).

### Gutbusters bacteria
wget -O gutbustersB_v1.sif https://datacloud.helsinki.fi/index.php/s/4SX7wmZBttpnWRg/download

### Gutbusters viruses (pro/phages, viruses)
wget -O gutbustersV_v1.sif https://datacloud.helsinki.fi/index.php/s/yAYN7HEHnSTk93n/download

### Usage
Gutbusters viruses
```apptainer run gutbusters_v1.sif \
--in my_contigs.fna \
--outdir my_outdir \
--threads 8
```
Gutbusters bacteria
```apptainer run gutbustersB_v1.sif \
  --in test_data/contigs.fna \
  --bam "$BF" \
  --outdir $OUTDIR \
  --threads 8
```
