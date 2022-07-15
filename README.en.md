# openc910-shunyao

## Description
Welcome to openc910-shunyao! \
This project is forked from github.com/T-head-Semi/openc910, and has been added Verilator/ShunSim flow for fastest simulation. \
It is a good demo for you to evaluate the popular open-source RISC-V project simulate on Verilator(open-source) or ShunSim(developed by SHUNYAOCAD). \
Please contact SHUNYAOCAD for technical details and professional support. \
    >>> Website:    https://www.shunyaocad.com \
    >>> Email:      edahub@shunyaocad.com

## Prepare for the environment

### Linux OS
Ubuntu OS with latest software toolchain is recommended for stable compatibility and best simulation performance. \
Of course, You could still use Redhat/CentOS OS for this evaluation.

### Prerequisites for Verilator:
#### Ubuntu
```
sudo apt-get install git perl python3 make autoconf g++ flex bison ccache
sudo apt-get install libgoogle-perftools-dev numactl perl-doc
```
#### Redhat/CentOS
```
sudo yum install git perl python3 make autoconf g++ flex bison ccache
sudo yum install libgoogle-perftools-dev numactl perl-doc
```

### Prerequisites for OpenC910:
You can download the GNU tool chain compiled by T-HEAD from the url below: \
https://occ.t-head.cn/community/download?id=3948120165480468480
1. download Xuantie-900-gcc-linux-5.10.4-glibc-x86_64-V2.2.1-20211110.tar.gz
2. download Xuantie-900-gcc-elf-newlib-x86_64-V2.2.1-20211110.tar.gz
3. cp the tar files to <path_to_install>/riscv_xuantie_toolchain
4. unzip the tar files 
```
tar -zxvf *tar.gz
```
5. set enviroment variable in setup.sh
```bash
export TOOL_EXTENSION=<path_to_install>/riscv_xuantie_toolchain/bin
```
```csh
setenv TOOL_EXTENSION <path_to_install>/riscv_xuantie_toolchain/bin
```
## Installation

### Install Verilator
1. download verilator-shunyao installation package
```
git clone https://gitee.com/shunyaocad/verilator-shunyao.git
```
2. install verilator
```
autoconf         # Create ./configure script
./configure      # Configure and create Makefile
make -j          # Build Verilator itself
```
### Install ShunSim
If you get approval from SHUNYAOCAD, then you will get shunsim installation package and related installation guide.

## Directory Architecture
```
|--C910_RTL_FACTORY/
  |--gen_rtl/               ## Verilog source code of C910
  |--setup/                 ## Script to set the environment variables
|--smart_run/               ## RTL simulation environment
  |--impl/                  ## SDC file, scripts and file lists for implementation
  |--logical/               ## SoC demo and test bench to run the simulation
    |--tb                   ## Testbench files
      |--sim_main.cpp       ## C++ Top for Verilator/ShunSim Simulation
      |--tb_verilator.v     ## Verilog Top for Verilator/ShunSim Simulation
      |--tb.v               ## Verilog Top for VCS/iverilog/Xcelium Simulation
    |--filelists            ## Filelist files
      |--sim_verilator.fl   ## Filelist for Verilator/ShunSim Simulation
      |--sim.fl             ## Filelist for VCS/iverilog/Xcelium Simulation
  |--setup/                 ## GNU tool chain setting
  |--tests/                 ## Test driver and test cases
  |--work_xxx/              ## Working directory for builds
  |--Makefile               ## Makefile for building and running sim targets
|--doc/                     ## The user and integration manual of C910
|--setup.sh                 ## Setup file for setting project related environment variables
```

## Instructions to Run Simulation

1.  source setup.sh          ### please modify the setup file to point the right tool installation path
2.  cd smart_run
3.  make runcase CASE=coremark WORKDIR=work_trace_thread8 DUMP=1 THREADS=8 SIM=verilator
3.  make runcase CASE=coremark WORKDIR=work_vcs DUMP=1 THREADS=8 SIM=vcs

