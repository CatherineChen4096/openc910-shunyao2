// >>> common include
#include <iostream>
#include <stdio.h>
#include <stdlib.h>
#include <signal.h>
#include <unistd.h>
using namespace std;

// >>> verilator
#include <memory>
#include <verilated.h>
#include <verilated_vcd_c.h>

#include "Vtop_top.h"
#include "sdm_config.h"
#include "Sdm_node_TOP.h"
using HW = Vtop_top;

uint64_t GlobalMainTime = 0;

#define CLK_PERIOD          100000
#define TCLK_PERIOD         40

//Real-time CPS printing
#define RDTSC(val) \
{ \
	unsigned int hi, lo; \
	asm volatile("rdtsc" : "=a"(lo), "=d"(hi)); \
	(val) = ((unsigned long long)lo ) | (((unsigned long long)hi) <<32); \
}

unsigned long long counter_array[200000];
int my_index =0;
unsigned long long start_time=0;
unsigned long long end_time=0;
unsigned long long rt_time=0;
unsigned long long counter_CPS[4];
unsigned long long counter_slv_CPS[4];
unsigned long long counter_mst_CPS[4];
unsigned long long counter_dut_CPS[4];
uint32_t count_print =0;
unsigned long long time_before_eval;
unsigned long long time_after_eval;
uint32_t count_cycle=0;
uint32_t unit_interval =0;

void record_start_time(){
	RDTSC(start_time);
}
void record_end_time(){
	RDTSC(end_time);
}

void record_time(){
	unsigned long long current_time;
	if (my_index > 100000) return;
	RDTSC(current_time);
	counter_array[my_index++]=current_time -start_time;
}
int main(int argc, char** argv, char**env)
{
    const std::unique_ptr<VerilatedContext> contextp{new VerilatedContext};
    const std::unique_ptr<HW> hw {new HW{contextp.get(), "TOP"}};
    Sdm_config * shuncfg_ptr = new Sdm_config (sub_node_TOP_node_name);
    shuncfg_ptr->arg_parse (argc, argv);
    Sdm_node_TOP shunobj (shuncfg_ptr, hw.get(), contextp.get());
    Verilated::mkdir("node_node_TOP_logs");
    contextp->debug(0);
    contextp->randReset(2);
    contextp->commandArgs(argc, argv);

#if VM_TRACE == 1
    VerilatedVcdC* tfp = NULL;
    const char* flag = Verilated::commandArgsPlusMatch("trace");
    if (flag && 0 == strcmp(flag, "+trace")) {
        Info("Enter Trace!");
        contextp->traceEverOn(true);
        tfp = new VerilatedVcdC;
        hw->trace(tfp, 99);
        shunobj.fulleval();
        tfp->open("node_node_TOP_test.vcd");
    };  
    shunobj.fulleval();
#endif

   shunobj.setup();


    bool retmp;
    int loop = 0;

 //record start time
    record_start_time();
    RDTSC(counter_CPS[0]);
    sleep(1);
    RDTSC(counter_CPS[1]);
    unit_interval =counter_CPS[1] - counter_CPS[0];
    cout << "  GalaxSim (R) Simulation-Runtime\n";
    cout << "  Copyright (c) 2020-2022 by XEPIC Technology Co., Ltd.\n";
    cout << "  Version: 22.2.1.94 x86_64_R_E \"Sep  8\" \"2022 02:10:14\"" << endl;
    //cout << "Unit Time: " << dec << unit_interval << " CPU tick[0]: " << counter_CPS[0] << " CPU tick[1]: " << counter_CPS[1] << endl;

    while (!contextp->gotFinish()) {
//    while (contextp->time()<12000000) {
        //Info ("loop %d", loop);
        if((contextp->time() % 50000000) == 0) {
            count_print =1;
            if(contextp->time() >= 50000000 && contextp->time() <= 3300000000){
                //cout << "Time: " << dec << contextp->time()/1000 << " ns, clk=" << short(top->clk)  << endl;
            }
            if (count_cycle % 2 == 0){
            	RDTSC(counter_CPS[0]);
            	counter_CPS[2] = contextp->time();
            }
            else{
            	RDTSC(counter_CPS[1]);
            	counter_CPS[3] = contextp->time();
                //VL_PRINTF("Time: %" VL_PRI64 "d clk=%x\n", contextp->time(), top->clk);
            	//cout << "SIM Time: " << dec << (counter_CPS[3] -counter_CPS[2]) << "CPU tick[0]: " << counter_CPS[0] <<" CPU tick[1]: " << counter_CPS[1] << " CPU time: " << ((counter_CPS[1] -counter_CPS[0])/unit_interval) << endl;
            	if (((counter_CPS[1] -counter_CPS[0])/unit_interval) !=0){
            		//cout << "===RT-CPS:" << dec << ((counter_CPS[3] -counter_CPS[2])/CLK_PERIOD)/((counter_CPS[1]- counter_CPS[0])/unit_interval) << endl;
            	}
            }
            count_cycle++;
            //cout << "[" << dec << contextp->time() << "] clk=" << short(hw->hbf_clk_0) << ", rst=" << short(hw->pll_sys0_rst_n) << endl;
        }
        else
        {
            count_print =0;
        }
        shunobj.update();
        shunobj.eval();
        shunobj.sync();
#if VM_TRACE == 1
        if (flag && 0 == strcmp(flag, "+trace")) {
            tfp->dump(contextp->time());
        }
#endif

        loop++;
    }
    record_end_time();
    //cout << "START_TIME:" << dec << start_time/unit_interval << " END_TIME:" << dec << end_time/unit_interval << endl;
    cout << "Simulation CPU time:" << dec << end_time/unit_interval - start_time/unit_interval << " seconds" << endl;
    cout << "AVerage-CPS:" <<dec << (contextp->time()/CLK_PERIOD)/((end_time -start_time)/unit_interval) << endl;
    
#if VM_TRACE == 1
    if (flag && 0 == strcmp(flag, "+trace")) {
        tfp->close();
    }
#endif
    hw->final();

    return 0;

#if VM_COVERAGE
    Verilated::mkdir("node_node_TOP_logs");
    contextp->coverageep()->write("node_node_TOP_logs/coverage.dat");
#endif

}

