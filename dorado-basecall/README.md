# Running Dorado basecaller with singularity

To build the singularity image, run this command:

`sudo singularity build dorado_pipeline.sif Singularity.def`

This will build a singularity image called `dorado_pipeline.sif` that runs the script `run_pipeline.sh`.

The script `run_dorado_singularity.sh` can then be used to run the image. The command for that is `./run_dorado_singularity.sh MODEL KIT_NAME OUTPUT_NAME INPUT_DIR OUTPUT_DIR`, for example `./run_dorado_singularity.sh fast SQK-RBK114-96 mysample /data/jacobs/dorado-test/pod5 /data/jacobs/dorado-test/output_singularity`.
