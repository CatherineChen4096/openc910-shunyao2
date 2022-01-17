// DESCRIPTION: Verilator: Verilog example module
//
// This file ONLY is placed under the Creative Commons Public Domain, for
// any use, without warranty, 2017 by Wilson Snyder.
// SPDX-License-Identifier: CC0-1.0
//======================================================================

// For std::unique_ptr
#include <memory>

// Include common routines
#include <verilated.h>

// Include model header, generated from Verilating "top.v"
#include "Vtop.h"
#if VM_TRACE
    #include <verilated_vcd_c.h>
#endif

#define CLK_PERIOD          2
#define TCLK_PERIOD         40
// Legacy function required only so linking works on Cygwin and MSVC++
double sc_time_stamp() { return 0; }

int main(int argc, char** argv, char** env) {
    // This is a more complicated example, please also see the simpler examples/make_hello_c.

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
