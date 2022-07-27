#!/bin/bash
set -e
script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}"  )" >/dev/null 2>&1 && pwd )"

# Install python and dependencies
[ -f Miniconda3-latest-Linux-x86_64.sh ] || wget https://mirrors.tuna.tsinghua.edu.cn/anaconda/miniconda/Miniconda3-latest-Linux-x86_64.sh
[ -d miniconda ] || bash ./Miniconda3-latest-Linux-x86_64.sh -b -p $script_dir/miniconda
$script_dir/miniconda/bin/conda create --prefix $script_dir/python-occlum -y  python=3.6 tensorflow=1.10.0 numpy=1.14 pandas=0.23 scipy=1.1

