#!/bin/bash
#SBATCH --nodes 1
#SBATCH --gres=gpu:rtx8000:1
#SBATCH --mem 32G
#SBATCH --time 02:00:00
#SBATCH --array=1-10
#
# This script is a wrapper around the _slurm_compose_release.sh script

module load singularity
module load python/3.10

scenario=${1:?"No scenario given"}
# debugging flags:
# --spoof-model
# --spoof-renderer
# --run_baseline_model
scripts/_slurm_compose_release.sh ncap_slurm_array_$scenario $scenario --scenario-category=$scenario ${@:2} 
#
#EOF
