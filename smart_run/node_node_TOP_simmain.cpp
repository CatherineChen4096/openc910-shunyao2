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
#include "Sdm_node_TOP.h"
using HW = Vtop_top;

uint64_t GlobalMainTime = 0;

#define CLK_PERIOD          10000
#define TCLK_PERIOD         4

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
    Sdm_node_TOP shunobj (hw.get(), contextp.get());
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
    cout << "Unit Time: " << dec << unit_interval << " CPU tick[0]: " << counter_CPS[0] << " CPU tick[1]: " << counter_CPS[1] << endl;

    //while (!contextp->gotFinish()) {
    while (contextp->time()<400000000) {
        //Info ("loop %d", loop);
        if((contextp->time() % 50000000) == 0) {
            count_print =1;
            if (count_cycle % 2 == 0){
            	RDTSC(counter_CPS[0]);
            	counter_CPS[2] = contextp->time();
            }
            else{
            	RDTSC(counter_CPS[1]);
            	counter_CPS[3] = contextp->time();
                //VL_PRINTF("Time: %" VL_PRI64 "d clk=%x\n", contextp->time(), top->clk);
            	cout << "SIM Time: " << dec << (counter_CPS[3] -counter_CPS[2]) << "CPU tick[0]: " << counter_CPS[0] <<" CPU tick[1]: " << counter_CPS[1] << " CPU time: " << ((counter_CPS[1] -counter_CPS[0])/unit_interval) << endl;
            	if (((counter_CPS[1] -counter_CPS[0])/unit_interval) !=0){
            		cout << "===RT-CPS:" << dec << ((counter_CPS[3] -counter_CPS[2])/2)/((counter_CPS[1]- counter_CPS[0])/unit_interval) << endl;
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
    cout << "START_TIME:" << dec << start_time/unit_interval << " END_TIME:" << dec << end_time/unit_interval << endl;
    cout << "CPU_TIME:" << dec << end_time/unit_interval - start_time/unit_interval << " seconds" << endl;
    cout << "===>AVerage-CPS:" <<dec << (contextp->time()/10000)/((end_time -start_time)/unit_interval) << endl;
    
    hw->final();

    return 0;
#if VM_TRACE == 1
    if (flag && 0 == strcmp(flag, "+trace")) {
        tfp->close();
    }
#endif

#if VM_COVERAGE
    Verilated::mkdir("node_node_TOP_logs");
    contextp->coverageep()->write("node_node_TOP_logs/coverage.dat");
#endif

}

