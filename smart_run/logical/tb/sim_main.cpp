// DESCRIPTION: Verilator: Verilog example module
//
// This file ONLY is placed under the Creative Commons Public Domain, for
// any use, without warranty, 2017 by Wilson Snyder.
// SPDX-License-Identifier: CC0-1.0
//======================================================================

// For std::unique_ptr
#include <memory>
#include <iostream>
using namespace std;
// Include common routines
#include <verilated.h>

// Include model header, generated from Verilating "top.v"
#include "Vtop.h"
#if VM_TRACE
    #include <verilated_vcd_c.h>
#endif

#define CLK_PERIOD          10000
#define TCLK_PERIOD         40
// Legacy function required only so linking works on Cygwin and MSVC++
double sc_time_stamp() { return 0; }

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
int main(int argc, char** argv, char** env) {
    //record start time
    record_start_time();
    RDTSC(counter_CPS[0]);
    sleep(1);
    RDTSC(counter_CPS[1]);
    unit_interval =counter_CPS[1] - counter_CPS[0];
    cout << "Unit Time: " << dec << unit_interval << " CPU tick[0]: " << counter_CPS[0] << " CPU tick[1]: " << counter_CPS[1] << endl;
    // Prevent unused variable warnings
    if (false && argc && argv && env) {}

    // Create logs/ directory in case we have traces to put under it
    Verilated::mkdir("logs");

    // Construct a VerilatedContext to hold simulation time, etc.
    // Multiple modules (made later below with Vtop) may share the same
    // context to share time, or modules may have different contexts if
    // they should be independent from each other.

    // Using unique_ptr is similar to
    // "VerilatedContext* contextp = new VerilatedContext" then deleting at end.
    const std::unique_ptr<VerilatedContext> contextp{new VerilatedContext};

    // Set debug level, 0 is off, 9 is highest presently used
    // May be overridden by commandArgs argument parsing
	//contextp->debug(9);

    // Randomization reset policy
    // May be overridden by commandArgs argument parsing
    contextp->randReset(2);

    // Pass arguments so Verilated code can see them, e.g. $value$plusargs
    // This needs to be called before you create any model
    contextp->commandArgs(argc, argv);

    // Construct the Verilated model, from Vtop.h generated from Verilating "top.v".
    // Using unique_ptr is similar to "Vtop* top = new Vtop" then deleting at end.
    // "TOP" will be the hierarchical name of the module.
    const std::unique_ptr<Vtop> top{new Vtop{contextp.get(), "TOP"}};

    // Verilator must compute traced signals
#if VM_TRACE == 1
    VerilatedVcdC* tfp = NULL;
    const char* flag = Verilated::commandArgsPlusMatch("trace");
    if (flag && 0==strcmp(flag, "+trace"))  {
		contextp->traceEverOn(true);	// Verilator must compute traced signals
		tfp = new VerilatedVcdC;
    	top->trace(tfp, 99);	// Trace 99 levels of hierarchy
    	tfp->open("openc910.vcd");	// Open the dump file
	}
#endif 
    // Set Vtop's input signals
    top->clk = 0;

    // Simulate until $finish
    while (!contextp->gotFinish()) {
        // Historical note, before Verilator 4.200 Verilated::gotFinish()
        // was used above in place of contextp->gotFinish().
        // Most of the contextp-> calls can use Verilated:: calls instead;
        // the Verilated:: versions simply assume there's a single context
        // being used (per thread).  It's faster and clearer to use the
        // newer contextp-> versions.

        contextp->timeInc(CLK_PERIOD/2);  // 1 timeprecision period passes...
        // Historical note, before Verilator 4.200 a sc_time_stamp()
        // function was required instead of using timeInc.  Once timeInc()
        // is called (with non-zero), the Verilated libraries assume the
        // new API, and sc_time_stamp() will no longer work.

        // Toggle a fast (time/2 period) clock
        top->clk = !top->clk;

        if((contextp->time() % 50000000) == 0) {
            count_print =1;
            cout << "Time: " << dec << contextp->time()/1000 << " ns, clk=" << short(top->clk) << endl;
            //VL_PRINTF("time:\t %lu\n", contextp -> time());
            if (count_cycle % 2 == 0){
            	RDTSC(counter_CPS[0]);
            	counter_CPS[2] = contextp->time();
            }
            else{
            	RDTSC(counter_CPS[1]);
            	counter_CPS[3] = contextp->time();
                //VL_PRINTF("Time: %" VL_PRI64 "d clk=%x\n", contextp->time(), top->clk);
            	//cout << "SIM Time: " << dec << (counter_CPS[3] -counter_CPS[2]) << "CPU tick[0]: " << counter_CPS[0] <<" CPU tick[1]: " << counter_CPS[1] << " CPU time: " << ((counter_CPS[1] -counter_CPS[0])/unit_interval) << endl;
            	//if (((counter_CPS[1] -counter_CPS[0])/unit_interval) !=0){
            	//	cout << "===RT-CPS:" << dec << ((counter_CPS[3] -counter_CPS[2])/2)/((counter_CPS[1]- counter_CPS[0])/unit_interval) << endl;
            	//}
            }
            count_cycle++;
            //cout << "[" << dec << contextp->time() << "] clk=" << short(hw->hbf_clk_0) << ", rst=" << short(hw->pll_sys0_rst_n) << endl;
        }
        else
        {
            count_print =0;
        }
        //if (contextp->time() % (TCLK_PERIOD/2) == 0) { top->jclk = !top->jclk;  }
        // Toggle control signals on an edge that doesn't correspond
        // to where the controls are sampled; in this example we do
        // this only on a negedge of clk, because we know
        // reset is not sampled there.
        //if (!top->clk) {
        //    if (contextp->time() == 100) { top->rst_b = 0;  }
        //    if (contextp->time() == 200) { top->rst_b = 0;  }
        //    if (contextp->time() == 400) { top->jrst_b = 0;  }
        //    if (contextp->time() == 800) { top->jrst_b = 0;  }
        //}
        top->eval();
    #if VM_TRACE
        if (flag && 0==strcmp(flag, "+trace")) tfp->dump(contextp->time());
    #endif
        // Evaluate model
        // (If you have multiple models being simulated in the same
        // timestep then instead of eval(), call eval_step() on each, then
        // eval_end_step() on each. See the manual.)

        // Read outputs
        //VL_PRINTF("[%" VL_PRI64 "d] clk=%x data=%x\n", contextp->time(), top->clk, top->d);
    }
    record_end_time();
    //cout << "START_TIME:" << dec << start_time/unit_interval << " END_TIME:" << dec << end_time/unit_interval << endl;
    cout << "CPU_TIME:" << dec << end_time/unit_interval - start_time/unit_interval << " seconds" << endl;
    //   
    cout << "===>AVerage-CPS:" <<dec << (contextp->time()/10000)/((end_time -start_time)/unit_interval) << endl;
    
    // Final model cleanup
    top->final();
    #if VM_TRACE
        if (flag && 0==strcmp(flag, "+trace")) { tfp->close(); tfp = NULL; }
    #endif
    // Coverage analysis (calling write only after the test is known to pass)
#if VM_COVERAGE
    Verilated::mkdir("logs");
    contextp->coveragep()->write("logs/coverage.dat");
#endif

    // Return good completion status
    // Don't use exit() or destructor won't get called
    return 0;
}
