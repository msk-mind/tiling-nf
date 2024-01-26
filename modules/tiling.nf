params.outdir = 'results'

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
    meta.tiles_url = new File("$params.outdir/$meta.slide_id/${meta.slide_id}.parquet").toURI()
    """
    create_tile_manifest -o . \
        --tile-size ${params.tile_size} \
        --otsu-threshold ${params.otsu_threshold} \
        --purple-threshold ${params.purple_threshold} \
        --batch-size ${params.batch_size} \
        --num-cores ${task.cpus} \
        $slide
    """
}


workflow TILING {
    take:
        ch_slides

    main:
        ch_slides | TILE 

    emit:
        TILE.out
}
        
