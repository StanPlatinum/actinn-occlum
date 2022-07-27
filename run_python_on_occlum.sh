#!/bin/bash
set -e

BLUE='\033[1;34m'
NC='\033[0m'

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}"  )" >/dev/null 2>&1 && pwd )"
python_dir="$script_dir/occlum_instance/image/opt/python-occlum"

[ -d occlum_instance ] || occlum new occlum_instance

cd occlum_instance && rm -rf image
copy_bom -f /root/demos/ACTINN/python-glibc.yaml --root $script_dir/image --include-dir /opt/occlum/etc/template

if [ ! -d $python_dir ];then
    echo "Error: cannot stat '$python_dir' directory"
    exit 1
fi

new_json="$(jq '.resource_limits.user_space_size = "10400MB" |
        .resource_limits.kernel_space_heap_size = "4024MB" |
        .resource_limits.max_num_of_threads = 512 |
	.process.default_mmap_size = "10000MB" |
	.env.default += ["PYTHONHOME=/opt/python-occlum"]' Occlum.json)" && \
echo "${new_json}" > Occlum.json
occlum build

# Run the python demo
occlum run /bin/python3 actinn_predict.py -trs /test_data/train_set.h5 -trl /test_data/train_label.txt.gz -ts /test_data/test_set.h5 -lr 0.0001 -ne 50 -ms 128 -pc True -op False
