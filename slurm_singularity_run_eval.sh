#################################################################
# Edit the following paths to match your setup
export BASE_DIR=$SCRATCH/'neuro_ncap_workspace'
export NUSCENES_PATH=$SCRATCH/'nuscenes'
# Model related stuff
export MODEL_NAME='UniAD' # current options are 'UniAD', 'VAD'
export MODEL_ARGS='--disable_col_optim'

export MODEL_FOLDER=$BASE_DIR/$MODEL_NAME

# select between UniAD and VAD

# UniAD example
export MODEL_CHECKPOINT_PATH='checkpoints/uniad_base_e2e.pth'
export MODEL_CFG_PATH='projects/configs/stage2_e2e/inference_e2e.py'
export MODEL_CONTAINER=$MODEL_FOLDER/'uniad.sif'

# VAD example (broken)
# export MODEL_CHECKPOINT_PATH='checkpoints/VAD_base.pth'
# export MODEL_CFG_PATH='projects/configs/VAD/VAD_inference.py'
# export MODEL_CONTAINER=$MODEL_FOLDER/'vad.sif'

# Rendering related stuff
export RENDERING_FOLDER=$BASE_DIR/'neurad-studio'
export RENDERING_CHECKPOITNS_PATH='checkpoints'
export RENDERING_CONTAINER=$RENDERING_FOLDER/'neurad-studio.sif'
# NCAP related stuff
export NCAP_FOLDER=$BASE_DIR/'neuro-ncap'
export NCAP_CONTAINER=$NCAP_FOLDER/'neuro-ncap.sif'

# Evaluation default values, set to lower for debugging
export RUNS=50  # they do 100 runs in the paper

#################################################################

# SLURM related stuff
export TIME_NOW=$(date +"%Y-%m-%d_%H-%M-%S")
export SLURM_OUTPUT_FOLDER=$BASE_DIR/slurm_logs/$TIME_NOW/%A_%a.out

# if folder does not exist, create it
if [ ! -d $BASE_DIR/slurm_logs/$TIME_NOW ]; then
    mkdir -p $BASE_DIR/slurm_logs/$TIME_NOW
fi


# assert we are standing in the right folder, which is NCAP folder
#if [ $PWD != $NCAP_FOLDER ]; then
#    echo "Please run this script from the NCAP folder"
#    exit 1
#fi

# assert all the other folders are present
if [ ! -d $MODEL_FOLDER ]; then
    echo "Model folder not found"
    exit 1
fi
if [ ! -d $RENDERING_FOLDER ]; then
    echo "Rendering folder not found"
    exit 1
fi

# assert all singularity files exist
if [ ! -f $MODEL_CONTAINER ]; then
    echo "Model container file not found"
    exit 1
fi
if [ ! -f $RENDERING_CONTAINER ]; then
    echo "Rendering container file not found"
    exit 1
fi
if [ ! -f $NCAP_CONTAINER ]; then
    echo "NCAP container file not found"
    exit 1
fi

# launch a job for each scenario type
for SCENARIO in "stationary" "frontal" "side"; do
  sbatch $SLURM_ARGS -o $SLURM_OUTPUT_FOLDER scripts/slurm_compose_scenario_release.sh $SCENARIO --runs $RUNS
done
