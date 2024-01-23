params.dremio.port = 32010
params.dremio.scheme = 'grpc+tcp'

process GET_SLIDES {
    executor 'local'
    conda 'conda-forge::pyarrow'

    secret 'DREMIO_PASSWORD'
    secret 'DREMIO_USERNAME'

    output:
    path "samples.csv"

    script:
    template 'get_slides.py'

}

