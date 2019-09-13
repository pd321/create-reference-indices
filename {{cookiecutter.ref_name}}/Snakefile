include: 'src/common.smk'
include: 'src/basic.smk'
include: 'src/aligner_indices.smk'


rule all:
    input:
        "fa/genome.chrom.sizes", 
        "fa/genome.fa.dict",
        "idx/kallisto/kallisto.idx", 
        expand("idx/star/{overhang_length}/SA", overhang_length=star_overhang_lengths)
