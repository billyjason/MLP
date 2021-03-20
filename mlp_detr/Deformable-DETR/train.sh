#!/usr/bin/env bash
#!/bin/sh
#SBATCH -N 1	  # nodes requested
#SBATCH -n 1	  # tasks requested
#SBATCH --partition=Teach-Standard
#SBATCH --gres=gpu:1
#SBATCH --mem=12000  # memory in Mb
#SBATCH --time=0-08:00:00

export CUDA_HOME=/opt/cuda-9.0.176.1/

export CUDNN_HOME=/opt/cuDNN-7.0/

export STUDENT_ID=$(whoami)

export LD_LIBRARY_PATH=${CUDNN_HOME}/lib64:${CUDA_HOME}/lib64:$LD_LIBRARY_PATH

export LIBRARY_PATH=${CUDNN_HOME}/lib64:$LIBRARY_PATH

export CPATH=${CUDNN_HOME}/include:$CPATH

export PATH=${CUDA_HOME}/bin:${PATH}

export PYTHON_PATH=$PATH

mkdir -p /disk/scratch/${STUDENT_ID}


export TMPDIR=/disk/scratch/${STUDENT_ID}/
export TMP=/disk/scratch/${STUDENT_ID}/

mkdir -p ${TMP}/datasets/
export DATASET_DIR=${TMP}/datasets/
# Activate the relevant virtual environment:

source /home/${STUDENT_ID}/miniconda3/bin/activate mlp

python -m torch.distributed.launch --nproc_per_node=2 --nnodes=1  --node_rank 0  --use_env main.py \
--output_dir my_output \
--coco_path ~/dev/data/coco \
--lr 0.0002 \
--lr_backbone 0.00001 \
--num_queries 100 \
--batch_size 1 \
--enc_layers 6 \
--dec_layers 6 \
--no_aux_loss \
--amp
