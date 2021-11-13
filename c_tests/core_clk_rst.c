#include <verilated.h>
#include "Vpicorv32core.h"
#include "verilated_vcd_c.h"

vluint64_t main_time = 0;

double sc_time_stamp() {
	return main_time;
}

int main (int argc, char** argv, char** env) {

	uint32_t read_data;
	uint32_t write_data;
	uint32_t addr;

	VerilatedContext* contextp = new VerilatedContext;
	contextp->commandArgs(argc, argv);
	Vpicorv32core* top = new Vpicorv32core{contextp};

	Verilated::traceEverOn(true);
	VerilatedVcdC* tfp = new VerilatedVcdC;

	top->trace(tfp, 100000);
	tfp->open("./sim.vcd");

	top->clk = 0;
        top->picorv32core__DOT__memory_modelling_inst__DOT__flag = 0x7;
	top->eval();

        // Reading from the memory
	for (int i = 0; i < 1500; i++) {
          contextp->timeInc(1);
	  if ((main_time % 10) == 1) {
                  top->clk = 1;
		  top->eval();
	  }
	  else if ((main_time % 10) == 6) {
		  top-> clk = 0;
		  top->eval();
	  }
	  tfp->dump(main_time);
	  main_time++;
	}
	tfp->close();
	top->final();
      	delete top;
	delete tfp;
	delete contextp;
	return 0;
}
