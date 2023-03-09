rule get_fa:
    output: "fa/genome.fa"
    threads: threads_low
    params:
        fa_url = config['fa']
    shell:
        'aria2c -x8 --out {output}.gz {params.fa_url} && '
        'gunzip {output}.gz'

rule get_gtf:
    output: temp("gtf/genes_raw.gtf")
    threads: threads_low
    params:
        gtf_url = config['gtf']
    shell:
        'aria2c -x8 --out {output}.gz {params.gtf_url} && '
        'gunzip {output}.gz'

rule remove_parY:
    input:
        rules.get_gtf.output
    output:
        filt_gtf = "gtf/genes_parY_filt.gtf",
        par_y_gtf = "gtf/parY.gtf"
    threads: threads_low
    shell:
        'grep "_PAR_Y" {input} > {output.par_y_gtf} && '
        'grep -v "_PAR_Y" {input} > {output.filt_gtf}'

rule get_final_gtf:
    input:
        rules.remove_parY.output.filt_gtf if config['filt_parY'] else rules.get_gtf.output
    output:
        "gtf/genes.gtf"
    threads: threads_low
    shell:
        'mv -v {input} {output}'

rule faidx:
    input: rules.get_fa.output
    output: "fa/genome.fa.fai"
    threads: threads_low
    shell:
        'samtools faidx {input}'

rule fa_dict:
    input: rules.get_fa.output
    output: "fa/genome.fa.dict"
    shell:
        'samtools dict -o {output} {input}'

rule chrom_sizes:
    input: rules.faidx.output
    output: "fa/genome.chrom.sizes"
    threads: threads_low
    shell:
        'cut -f1,2 {input} > {output}'

rule get_transcript_fa:
    input: 
        fa = rules.get_fa.output,
        fai = rules.faidx.output,
        gtf = rules.get_final_gtf.output
    output: "fa/transcripts.fa"
    threads: threads_low
    shell:
        'gffread -w {output} -g {input.fa} {input.gtf}'
