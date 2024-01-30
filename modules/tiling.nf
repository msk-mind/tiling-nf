import groovy.json.JsonOutput

params.outdir = 'results'
params.meta_outfile = 'meta.csv'

params.tile_magnification = 20
params.tile_size = 512
params.otsu_threshold = 0.15
params.purple_threshold = 0.05
params.batch_size = 2000


process TILE {
    label "parallelTask"
    publishDir "$params.outdir/${meta.slide_id}/"
    conda "/gpfs/mskmind_ess/limr/repos/tiling/.venv/tiling"

    input:
    tuple val(meta), path(slide)

    output:
    tuple val(meta), path("${meta.slide_id}.parquet")

    script:
    meta.tiles_url = new File("$params.outdir/$meta.slide_id/${meta.slide_id}.parquet").toURI().toURL().toExternalForm()
    meta.tile_size = params.tile_size
    meta.tile_magnification = params.tile_magnification
    meta.tile_otsu_threshold = params.otsu_threshold
    meta.tile_purple_threshold = params.purple_threshold
    """
    create_tile_manifest -o . \
        --tile-size ${params.tile_size} \
        --otsu-threshold ${params.otsu_threshold} \
        --purple-threshold ${params.purple_threshold} \
        --tile-magnification ${params.tile_magnification} \
        --batch-size ${params.batch_size} \
        --num-cores ${task.cpus} \
        $slide
    """
}

process TILE_META {
    label "localTask"

    input:
    tuple val(meta), path(tiles)

    output:
    path("meta.json")

    exec:
    def json = JsonOutput.toJson(meta)
    new File("$task.workDir/meta.json").withWriter {
        it << JsonOutput.prettyPrint(json)
    }

}

process WRITE_META {
    label "localTask"
    publishDir "$params.outdir/"

    input:
    path 'meta?.json'

    output:
    path "${params.meta_outfile}"

    script:
    """
    #!/usr/bin/env python

    import glob
    import json
    import csv

    metas = []
    for f in glob.glob('meta*.json'):
        with open(f, 'r') as of:
            metas.append(json.load(of))

    keys = metas[0].keys()
    with open('${params.meta_outfile}', 'w', newline='') as csvfile:
        csvwriter = csv.writer(csvfile)
        csvwriter.writerow(keys)
        for m in metas:
            csvwriter.writerow([m[key] for key in keys])
    """
}


workflow TILING {
    take:
        ch_slides

    main:
        ch_slides | TILE | TILE_META | collect | WRITE_META

    emit:
        TILE.out
}
