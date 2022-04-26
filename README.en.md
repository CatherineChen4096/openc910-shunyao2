# openc910-shunyao

#### Description
Fork from github.com/T-head-Semi/openc910, and add shunsim flow for fastest simulation

#### Installation

1.  Install ShunSim & Verilator
    You can download shunsim and verilator proposed by shunyaocad from the url below:
    Verilator-shunyao: gitee.com/shunyaocad/verilator-shunyao
    ShunSim: gitee.com/shunyaocad/shunsim-install
    Please install the tools refer to the UserGuide
2.  Install Xuantie Tool Chain
    You can download the RISCV tool chain from the url below:
    github.com/T-head-Semi/xuantie-gnu-toolchain

#### Instructions

1.  source setup.sh          ### please modify the setup file to point the right tool installation path
2.  cd smart_run
3.  make runcase CASE=coremark WORKDIR=work_trace_thread8 DUMP=1 THREADS=8 [SIM=verilator]

#### Contribution

1.  Fork the repository
2.  Create new branch
3.  Commit your code
4.  Create Pull Request


#### Gitee Feature

1.  You can use Readme\_XXX.md to support different languages, such as Readme\_en.md, Readme\_zh.md
2.  Gitee blog [blog.gitee.com](https://blog.gitee.com)
3.  Explore open source project [https://gitee.com/explore](https://gitee.com/explore)
4.  The most valuable open source project [GVP](https://gitee.com/gvp)
5.  The manual of Gitee [https://gitee.com/help](https://gitee.com/help)
6.  The most popular members  [https://gitee.com/gitee-stars/](https://gitee.com/gitee-stars/)
