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

// Include model header, generated from Verilating "tb.v"
#include "Vtb.h"
#if VM_TRACE
    #include <verilated_vcd_c.h>
#endif

#define CLK_PERIOD          10
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
    // Multiple modules (made later below with Vtb) may share the same
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

    // Verilator must compute traced signals
#if VM_TRACE == 1
    VerilatedVcdC* tfp = NULL;
    const char* flag = Verilated::commandArgsPlusMatch("trace");
    if (flag && 0==strcmp(flag, "+trace"))  {
		contextp->traceEverOn(true);	// Verilator must compute traced signals
		tfp = new VerilatedVcdC;
    	tb->trace(tfp, 99);	// Trace 99 levels of hierarchy
    	tfp->open("openc910.vcd");	// Open the dump file
	}
#endif 

    // Pass arguments so Verilated code can see them, e.g. $value$plusargs
    // This needs to be called before you create any model
    contextp->commandArgs(argc, argv);

    // Construct the Verilated model, from Vtb.h generated from Verilating "tb.v".
    // Using unique_ptr is similar to "Vtb* tb = new Vtb" then deleting at end.
    // "TOP" will be the hierarchical name of the module.
    const std::unique_ptr<Vtb> tb{new Vtb{contextp.get(), "TOP"}};

    // Set Vtb's input signals
    tb->clk = 0;
    tb->jclk = 0;
    tb->rst_b = 1;
    tb->jrst_b = 1;

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
        tb->clk = !tb->clk;

        if (contextp->time() % (TCLK_PERIOD/2) == 0) { tb->jclk = !tb->jclk;  }
        // Toggle control signals on an edge that doesn't correspond
        // to where the controls are sampled; in this example we do
        // this only on a negedge of clk, because we know
        // reset is not sampled there.
        if (!tb->clk) {
            if (contextp->time() == 100) { tb->rst_b = 0;  }
            if (contextp->time() == 200) { tb->rst_b = 0;  }
            if (contextp->time() == 400) { tb->jrst_b = 0;  }
            if (contextp->time() == 800) { tb->jrst_b = 0;  }
        }
        tb->eval();
    #if VM_TRACE
        if (tfp) tfp->dump(contextp->time());
    #endif
        // Evaluate model
        // (If you have multiple models being simulated in the same
        // timestep then instead of eval(), call eval_step() on each, then
        // eval_end_step() on each. See the manual.)

        // Read outputs
        //VL_PRINTF("[%" VL_PRI64 "d] clk=%x data=%x\n", contextp->time(), tb->clk, tb->d);
    }

    // Final model cleanup
    tb->final();
    #if VM_TRACE
        if (tfp) { tfp->close(); tfp = NULL; }
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
