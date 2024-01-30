# Tiling-NF pipeline

A pipeline for pathology slide analysis: tile and detect tissue

## Requirements

* Unix-like operating system
* Java 11

## Quickstart

1. Install [anaconda](https://docs.anaconda.com/free/anaconda/install/index.html) or [Mamba](https://mamba.readthedocs.io/en/latest/installation/mamba-installation.html)

2. Install nextflow:
    ```
    curl -s https://get.nextflow.io | bash
    ```

3. Launch the pipeline execution using docker
    ```
    ./nextflow run msk-mind/tiling-nf --samples_csv samples.csv
    ```
    `samples.csv` is a csv file which has a `url` (specify with `--slide_url_column`) column that has the path to the slide

4. When the execution completes, `meta.csv` will be in the `results` (specify with `--outdir`) directory


## Azure Batch Support

1. Create an Azure storage account and batch account.

2. Modify the nextflow configuration files as necessary (see <https://www.nextflow.io/docs/edge/azure.html>)

3. Set the necessary secrets using `nextflow secrets set`. At a minimum set `AZURE_BATCH_KEY` and `AZURE_STORAGE_KEY`.

4. Launch nextflow:
    ```
    nextflow -Dcom.amazonaws.sdk.disableCertChecking=true run main.nf -bucket-dir {azure_bucket_dir} -profile standard,cloud
    ```
    where `{azure_bucket_dir}` is an azure path like `az://test/nftest`.

5. When the execution completes, `meta.csv` will be in the `results` directory
