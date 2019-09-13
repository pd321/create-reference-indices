rule kallisto_idx:
    input: rules.get_transcript_fa.output
    output: "idx/kallisto/kallisto.idx"
    threads: threads_mid
    shell:
        'kallisto index '
        '--index {output} '
        '{input}'

rule star_idx:
    input:
        fa = rules.get_fa.output,
        fai = rules.faidx.output,
        gtf = rules.get_final_gtf.output
    output: "idx/star/{overhang_length}/SA"
    log: "logs/idx/star/{overhang_length}.log"
    threads: threads_high
    shell:
        'STAR '
        '--runThreadN {threads} '
        '--runMode genomeGenerate '
        '--genomeDir idx/star/{wildcards.overhang_length} '
        '--genomeFastaFiles {input.fa} '
        '--sjdbGTFfile {input.gtf} '
        '--sjdbOverhang {wildcards.overhang_length} && '
        'mv Log.out {log}'
