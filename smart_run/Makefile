#/*Copyright 2019-2021 T-Head Semiconductor Co., Ltd.
#
#Licensed under the Apache License, Version 2.0 (the "License");
#you may not use this file except in compliance with the License.
#You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
#Unless required by applicable law or agreed to in writing, software
#distributed under the License is distributed on an "AS IS" BASIS,
#WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#See the License for the specific language governing permissions and
#limitations under the License.
#*/

include ./setup/smart_cfg.mk
include ./setup/env_check.mk

################################################################################
# Simulation related
################################################################################
SIM = shunsim
DUMP ?= 0
TIMELOG = time.log 
TIMECMD = time -a -o $(TIMELOG)
THREADS ?= 4
WORKDIR ?= work
VERILATOR_FLAGS ?= 
SIM_FLAGS ?= 

# Generate C++ in executable form
#VERILATOR_FLAGS += -cc --exe
## Generate makefile dependencies (not shown as complicates the Makefile)
##VERILATOR_FLAGS += -MMD
## Optimize
#VERILATOR_FLAGS += -Os -x-assign 0
## lint-only
#VERILATOR_FLAGS += -lint-only
## Warn abount lint issues; may not want this on less solid designs
#VERILATOR_FLAGS += -Wno-fatal
## Make waveforms
#VERILATOR_FLAGS += --trace
## Check SystemVerilog assertions
#VERILATOR_FLAGS += --assert
## Generate coverage analysis
#VERILATOR_FLAGS += --coverage
# Run Verilator in debug mode
#VERILATOR_FLAGS += --debug
# Add this trace to get a backtrace in gdb
#VERILATOR_FLAGS += --gdbbt

ifeq ($(DUMP), 1)
SIM_DUMP :=
VERILATOR_FLAGS += --trace --trace-threads 1
SIM_FLAGS += +trace
else
ifeq (${SIM}, iverilog)
SIM_DUMP = -DNO_DUMP
else
SIM_DUMP := +define+NO_DUMP
endif
endif

ifeq ($(PGO_learn), 1)
VERILATOR_FLAGS += -CFLAGS "-fprofile-generate" -LDFLAGS "-fprofile-generate"
endif
ifeq ($(PROF_CFUNC), 1)
VERILATOR_FLAGS += --prof-cfuncs
THREADS = 1
endif

ifeq ($(SIM), vcs)
TIMESCALE := -timescale=1ns/100fs
SIMULATOR_OPT := -sverilog -full64 -kdb -lca -debug_access +nospecify +notimingchecks +lint=TFIPC-L
SIMULATOR_DEF := +define+no_warning +define+TSMC_NO_WARNING
SIMULATOR_LOG := -l comp.vcs.log
    ifeq ($(UPF), on)
    SIMULATOR_POWER_OPT := -upf ../impl/upf/example_cpu_power_spec.upf +define+UPF_INCLUDED
    SIMV_POWER_OPT      := +fsdb+power +fsdb+all 
    else
    SIMULATOR_POWER_OPT := 
    SIMV_POWER_OPT      := 
    endif
else 
    ifeq ($(SIM), nc) 
        TIMESCALE := -timescale 1ns/100fs
        SIMULATOR_OPT := +v2k -sysv +sv +access+wrc +notimingcheck -default_ext verilog -elaborate +tcl+../setup/nc.tcl
        SIMULATOR_DEF := +define+no_warning +define+TSMC_NO_WARNING +define+VMC +define+NC_SIM 
        SIMULATOR_LOG := -l comp.nc.log
    else ifeq ($(SIM), iverilog)
        TIMESCALE := 
        SIMULATOR_OPT := -o xuantie_core.vvp -Diverilog=1 -g2012 
        SIMULATOR_DEF := -DIVERILOG_SIM
        SIMULATOR_LOG := 
    else ifeq ($(SIM), verilator)
        TIMESCALE := --timescale 1ns/100fs
        SIMULATOR_OPT := -Os -x-assign 0 --threads $(THREADS) -Wno-fatal $(VERILATOR_FLAGS)
        SIMULATOR_DEF := -cc --exe --top-module top ../vrlt_cfg.vlt
        SIMULATOR_LOG := 
    else ifeq ($(SIM), shunsim)
        TIMESCALE := --timescale 1ns/100fs
        SIMULATOR_OPT := --config $(SIM_PATH)/shunsim.yaml
        SIMULATOR_LOG := --log shunsim_comp.log
    endif
endif

ifeq ($(SIM), iverilog)
    SIM_FILELIST := $(SIM_FILELIST) -f ${CODE_BASE_PATH}/gen_rtl/filelists/C910_asic_rtl.fl -c ../logical/filelists/smart.fl -c ../logical/filelists/tb.fl
else ifeq ($(SIM), verilator)
    SIM_FILELIST := $(SIM_FILELIST) -f ../logical/filelists/sim_verilator.fl ../logical/tb/sim_main.cpp
else ifeq ($(SIM), shunsim)
    SIM_FILELIST := 
else
    SIM_FILELIST := $(SIM_FILELIST) -f ../logical/filelists/sim.fl
endif

compile:
	@echo "  [THead-smart] Compiling smart now ... "
	@echo "  [THead-smart] SIM = $(SIM)"
ifeq ($(SIM), vcs)
	@make -s cleansim
	@cd ./$(WORKDIR) && vcs $(SIMULATOR_OPT) $(TIMESCALE) $(SIMULATOR_DEF) $(SIM_FILELIST) $(SIM_DUMP) $(SIMULATOR_LOG) $(SIMULATOR_POWER_OPT) 
else ifeq ($(SIM), nc) 
	@cd ./$(WORKDIR) && irun $(SIMULATOR_OPT) $(TIMESCALE) $(SIMULATOR_DEF) $(SIM_FILELIST) $(SIM_DUMP) $(SIMULATOR_LOG)
else ifeq ($(SIM), iverilog)
	@cd ./$(WORKDIR) && iverilog $(TIMESCALE) $(SIMULATOR_OPT) $(SIMULATOR_DEF) $(SIM_FILELIST) $(SIM_DUMP) $(SIMULATOR_LOG)
else ifeq ($(SIM), verilator)
	@echo "[verilator] Generating C++ files..." >> ./$(WORKDIR)/$(TIMELOG)
	@date -R | tee -a ./$(WORKDIR)/$(TIMELOG)
	@echo "verilator $(TIMESCALE) $(SIMULATOR_OPT) $(SIMULATOR_DEF) $(SIMULATOR_LOG) $(SIM_FILELIST)" >> ./$(WORKDIR)/$(TIMELOG)
	@cd ./$(WORKDIR) && $(TIMECMD) verilator $(TIMESCALE) $(SIMULATOR_OPT) $(SIMULATOR_DEF) $(SIMULATOR_LOG) $(SIM_FILELIST) 2>&1 | tee -a vrlt_com.log
	@date -R | tee -a ./$(WORKDIR)/$(TIMELOG)
else ifeq ($(SIM), shunsim)
	@echo "[shunsim] Generating C++ files..." >> ./$(WORKDIR)/$(TIMELOG)
	@date -R | tee -a ./$(WORKDIR)/$(TIMELOG)
	@echo "shunsim $(TIMESCALE) $(SIMULATOR_OPT) $(SIMULATOR_DEF) $(SIMULATOR_LOG) $(SIM_FILELIST)" >> ./$(WORKDIR)/$(TIMELOG)
	@cd ./$(WORKDIR) && $(TIMECMD) shunsim $(TIMESCALE) $(SIMULATOR_OPT) $(SIMULATOR_DEF) $(SIMULATOR_LOG) $(SIM_FILELIST)
	@date -R | tee -a ./$(WORKDIR)/$(TIMELOG)
else	
	@echo "  [THead-smart] Please specify SIM = vcs to use VCS, or SIM = nc ,or SIM = verilator to use verilator ..."
endif 

buildVerilator:
	@cp ./logical/tb/Makefile_obj ./$(WORKDIR)/Makefile_obj
	@echo "[g++] Compiling C++ files..." >> ./$(WORKDIR)/$(TIMELOG)
	@date -R | tee -a ./$(WORKDIR)/$(TIMELOG)	
	@cd ./$(WORKDIR) && $(TIMECMD) make -j -C obj_dir -f ../Makefile_obj
	@date -R | tee -a ./$(WORKDIR)/$(TIMELOG)	
cleansim:
	@cd ./$(WORKDIR) && rm -rf simv* csrc ucli.key *.vcs.log novas_dump.log *.fsdb
cleanVerilator:
	if [ ! -d ./$(WORKDIR) ] ; then \
		mkdir $(WORKDIR) ; \
	else \
		if [ -d ./$(WORKDIR)/obj_dir ] ; then \
			cd ./$(WORKDIR) && rm -rf obj_dir/ && rm -f $(TIMELOG) && touch $(TIMELOG) ; \
		fi \
	fi

################################################################################
# Cases related
################################################################################
showcase:
	@echo "  Case lists:" \ 
	@for case in $(CASE_LIST) ; do \
          echo "    $$case"; \
        done

buildcase: tool-chain-chk
ifeq ($(CASE),)
	$(error Please specify CASE=xxx on the command line, like: \
        $(newline)   > make buildcase CASE=xxx... \
        $(newline)   The list of valid cases can be obtained by executing: \
        $(newline)   > make showcase ...)
endif
ifeq ($(findstring $(CASE), $(CASE_LIST)), $(CASE))
	@make -s cleancase
	@make -s $(CASE)_build
else
	$(error Argument CASE=xxx is not valid: \
        $(newline)   The list of valid cases can be obtained by executing: \
        $(newline)   > make showcase ...)
endif


cleancase:
	@cd ./$(WORKDIR) && rm -rf *.s *.S *.c *.o *.pat *.h *.lcf *.hex *.obj *.vh *.v *.report *.elf Makefile *.case.log

################################################################################
# Combined flows
################################################################################
# Execute one case
runVerilator:
	@cd ./$(WORKDIR) && time obj_dir/Vtop
Vtop = ./$(WORKDIR)/obj_dir/Vtop
runcase:
		@make cleanVerilator 
ifeq ($(CASE),)
	$(error Please specify CASE=xxx on the command line, like: \
        $(newline)   > make buildcase CASE=xxx... \
        $(newline)   The list of valid cases can be obtained by executing: \
        $(newline)   > make showcase ...)
endif
ifeq ($(findstring $(CASE), $(CASE_LIST)), $(CASE))
ifeq ($(SIM), vcs)
	if [ ! -e ./$(WORKDIR)/simv ] ; then make -s compile ; fi
else ifeq ($(SIM), verilator)
	if [ ! -e ./$(WORKDIR)/obj_dir/Vtop ] ; then make -s compile ; fi
else ifeq ($(SIM), shunsim)
	if [ ! -e ./$(WORKDIR)/obj_dir/Vtop ] ; then make -s compile ; fi
endif
	@make -s buildcase CASE=$(CASE)
ifeq ($(SIM), vcs)
	cd ./$(WORKDIR) && ./simv -l run.vcs.log $(SIMV_POWER_OPT)
else ifeq ($(SIM), nc)	
	cd ./$(WORKDIR) && irun -R -l run.irun.log
else ifeq ($(SIM), verilator)
	make buildVerilator
	@echo "[Vtop] Simulation..." >> ./$(WORKDIR)/$(TIMELOG)
	@date -R | tee -a ./$(WORKDIR)/$(TIMELOG)	
	cd ./$(WORKDIR) && $(TIMECMD) obj_dir/Vtop $(SIM_FLAGS) 2>&1 | tee sim.log
	@date -R | tee -a ./$(WORKDIR)/$(TIMELOG)	
else ifeq ($(SIM), shunsim)
	if [ ! -e ./$(WORKDIR)/obj_dir/Vtop ] ; then make buildVerilator ; fi
	@echo "[Vtop] Simulation..." >> ./$(WORKDIR)/$(TIMELOG)
	@date -R | tee -a ./$(WORKDIR)/$(TIMELOG)	
	cd ./$(WORKDIR) && $(TIMECMD) obj_dir/Vtop $(SIM_FLAGS) 2>&1 | tee sim.log
	@date -R | tee -a ./$(WORKDIR)/$(TIMELOG)
else
	cd ./$(WORKDIR) && vvp xuantie_core.vvp 
endif
else
	$(error Argument CASE=xxx is not valid: \
        $(newline)   The list of valid cases can be obtained by executing: \
        $(newline)   > make showcase ...)
endif

wave:
	cd ./$(WORKDIR) && vcd2fsdb openc910.vcd && verdi -f $(SIM_PATH)/logical/filelists/verdi.f -ssf openc910.vcd.fsdb -top TOP
	rm -rf ./$(WORKDIR)/openc910.vcd

# Execute all cases
regress:
	rm -rf ./tests/regress/regress_result/*
	@(for case in $(CASE_LIST) ; do \
	 make -s cleancase; \
	 make -s runcase CASE=$$case; \
	 cp ./$(WORKDIR)/run_case.report ./tests/regress/regress_result/$$case.report; \
	 done)
	cd ./tests/regress && perl report_gen.pl
	cat ./tests/regress/regress_report

################################################################################
# Misc
################################################################################
.DEFAULT_GOAL := help

memlist:
	@make -s compile
	${VERDI_HOME}/share/VIA/Apps/Bin/findInstDefWild.pl -dbdir ./$(WORKDIR)/simv.daidir -pattern "ct_spsram*" -scope "tb.x_soc.x_cpu_sub_system_axi.x_rv_integration_platform.x_cpu_top" -dump_def_name -outlog ./$(WORKDIR)/memlist.verdi.log
	perl impl/memlist/memlist.pl 

clean:
	@cd ./$(WORKDIR) && rm -rf * 
	@make -s cleanVerilator

help:
	@echo "  ########## Smart Help Info ##########"
	@echo "  This Makefile is the entrance of T-Head Smart simulation environment"
	@echo "  Usage: make [target] [arguments]";
	@echo "  Available targets:";
	@echo "    compile                         : compile the RTL and Smart tbench (using vcs or ius)";
	@echo "    showcase                        : list all valid cases under current configuration";
	@echo "    buildcase CASE=[casename]       : clean and compile the .c/.s case [casename]";
	@echo "    [casename]_build                : compile the .c/.s case [casename]";
	@echo "    runcase CASE=[casename]         : run the case [casename]";
	@echo "    regress                         : run all cases and summarize the regress result";
	@echo "    memlist                         : generate sram list with the help of VCS/Verdi";
	@echo "    cleansim                        : clean files generated by simulator in ./$(WORKDIR) ";
	@echo "    cleancase                       : clean files generated by GNU in ./$(WORKDIR) ";
	@echo "    clean                           : clean ./$(WORKDIR) ";
	@echo "  Optional arguments:";
	@echo "    SIM=                            : options: vcs / nc"; 
	@echo "    CASE=                           : options: the list print by 'make showcase'"; 
	@echo "    DUMP=                           : options: on / off";
	@echo "  Examples:";
	@echo "    make runcase CASE=dhry          : run case 'dhry' (by iverilog withtout dump) "; 
	@echo "    make runcase CASE=dhry SIM=nc   : run case 'dhry' (by nc withtout dump) "; 
	@echo "    make runcase CASE=dhry DUMP=on  : run case 'dhry' with dump "; 


