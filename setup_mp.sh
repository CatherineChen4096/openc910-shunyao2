##########################################################################
# File Name: setup.sh
# Author: Kai Yang
# mail: kai.yang@shunyaocad.com
# Created Time: Fri 29 Oct 2021 02:51:15 PM CST
#########################################################################
#!/bin/sh
#PATH=/usr/bin:/usr/sbin
#export PATH

export PROJECT_PATH=`pwd`
export SIM_PATH=$PROJECT_PATH/smart_run
export CODE_BASE_PATH=$PROJECT_PATH/C910_RTL_FACTORY
export TOOL_EXTENSION=/software/riscv_xuantie/bin
#source /home/yangkai/1_SA/shunsim-install/ShunSim-202202/setup.sh

#shunsim_mp setting
export SHUNSIM_ROOT=/home/yangkai/1_SA/shunsim_MP
export VERILATOR_ROOT=/home/yangkai/1_SA/shunsim_MP/verilator-shunyao
export SHUNYAO_LICENSE=/software/shunyao/license/shunsim_latest.lic
export PATH=${SHUNSIM_ROOT}/bin:${VERILATOR_ROOT}/bin:$PATH
