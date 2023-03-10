rule kallisto_idx:
    input: 
        fasta = rules.get_transcript_fa.output
    output: 
        index = "idx/kallisto/kallisto.idx"
    log: "logs/kallisto_idx.log"
    threads: threads_mid
    wrapper:
        "v1.23.5/bio/kallisto/index"

rule star_idx:
    input:
        fa = rules.get_fa.output,
        fai = rules.faidx.output,
        gtf = rules.get_final_gtf.output
    output: directory("idx/star/{overhang_length}/")
    log: "logs/idx/star/{overhang_length}.log"
    threads: threads_high
    params:
        sjdbOverhang = lambda wildcards: wildcards.overhang_length
    wrapper:
        "v1.23.5/bio/star/index"

rule salmon_idx:
    input:
        sequences = rules.get_gentrome.output.gentrome_fa,
        decoys = rules.get_decoys_for_salmon.output
    output:
        multiext(
            "idx/salmon/",
            "complete_ref_lens.bin",
            "ctable.bin",
            "ctg_offsets.bin",
            "duplicate_clusters.tsv",
            "info.json",
            "mphf.bin",
            "pos.bin",
            "pre_indexing.log",
            "rank.bin",
            "refAccumLengths.bin",
            "ref_indexing.log",
            "reflengths.bin",
            "refseq.bin",
            "seq.bin",
            "versionInfo.json",
        ),
    log:
        "logs/salmon_index.log",
    threads: threads_high
    wrapper:
        "v1.23.5/bio/salmon/index"

rule bowtie2_idx:
    input: 
        ref = rules.get_fa.output
    output: 
        multiext(
                "idx/bowtie2/index",
                ".1.bt2",
                ".2.bt2",
                ".3.bt2",
                ".4.bt2",
                ".rev.1.bt2",
                ".rev.2.bt2",
            ),
    log:
        "logs/bowtie2_build.log",
    threads: threads_high
    wrapper:
        "v1.23.5/bio/bowtie2/build"

rule bowtie_idx:
    input: rules.get_fa.output
    output: 'idx/bowtie/index.1.ebwt'
    conda: "../envs/bowtie.yaml"
    threads: threads_high
    shell:
        'bowtie-build --threads {threads} {input} idx/bowtie/index'
