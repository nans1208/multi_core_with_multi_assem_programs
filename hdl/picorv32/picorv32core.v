`timescale 1 ns / 1 ps

module picorv32core (input clk);

        // Core0
	wire mem_valid;
	wire mem_instr;
	reg mem_ready;
	wire [31:0] mem_addr;
	wire [31:0] mem_wdata;
	wire [3:0] mem_wstrb;
	reg [31:0] mem_rdata;

	wire mem_la_read;
	wire mem_la_write;
	wire [31:0] mem_la_addr;
	wire [31:0] mem_la_wdata;
	wire [3:0] mem_la_wstrb;

	// Core1
	wire mem_valid1;
	wire mem_instr1;
	reg mem_ready1;
	wire [31:0] mem_addr1;
	wire [31:0] mem_wdata1;
	wire [3:0] mem_wstrb1;
	reg [31:0] mem_rdata1;

	wire mem_la_read1;
	wire mem_la_write1;
	wire [31:0] mem_la_addr1;
	wire [31:0] mem_la_wdata1;
	wire [3:0] mem_la_wstrb1;

	// Core2
	wire mem_valid2;
	wire mem_instr2;
	reg mem_ready2;
	wire [31:0] mem_addr2;
	wire [31:0] mem_wdata2;
	wire [3:0] mem_wstrb2;
	reg [31:0] mem_rdata2;

	wire mem_la_read2;
	wire mem_la_write2;
	wire [31:0] mem_la_addr2;
	wire [31:0] mem_la_wdata2;
	wire [3:0] mem_la_wstrb2;

	reg [5:0] rst_counter;
	wire resetn = &rst_counter;
	always @(posedge clk) begin
		if (rst_counter < 6'hFF) begin
			rst_counter <= rst_counter + 1;
		end
	end

/* verilator lint_off PINMISSING */
	picorv32 picorv32_core (
		.clk         (clk         ),
		.resetn      (resetn      ),
//		.trap        (trap        ),
		.mem_valid   (mem_valid   ),
		.mem_instr   (mem_instr   ),
		.mem_ready   (mem_ready   ),
		.mem_addr    (mem_addr    ),
		.mem_wdata   (mem_wdata   ),
		.mem_wstrb   (mem_wstrb   ),
		.mem_rdata   (mem_rdata   ),
		.mem_la_read (mem_la_read ),
		.mem_la_write(mem_la_write),
		.mem_la_addr (mem_la_addr ),
		.mem_la_wdata(mem_la_wdata),
		.mem_la_wstrb(mem_la_wstrb)
	);

	picorv32 picorv32_core1 (
		.clk         (clk         ),
		.resetn      (resetn      ),
//		.trap        (trap        ),
		.mem_valid   (mem_valid1   ),
		.mem_instr   (mem_instr1   ),
		.mem_ready   (mem_ready1   ),
		.mem_addr    (mem_addr1    ),
		.mem_wdata   (mem_wdata1   ),
		.mem_wstrb   (mem_wstrb1   ),
		.mem_rdata   (mem_rdata1   ),
		.mem_la_read (mem_la_read1 ),
		.mem_la_write(mem_la_write1),
		.mem_la_addr (mem_la_addr1 ),
		.mem_la_wdata(mem_la_wdata1),
		.mem_la_wstrb(mem_la_wstrb1)
	);

	picorv32 picorv32_core2 (
		.clk         (clk         ),
		.resetn      (resetn      ),
//		.trap        (trap        ),
		.mem_valid   (mem_valid2   ),
		.mem_instr   (mem_instr2   ),
		.mem_ready   (mem_ready2   ),
		.mem_addr    (mem_addr2    ),
		.mem_wdata   (mem_wdata2   ),
		.mem_wstrb   (mem_wstrb2   ),
		.mem_rdata   (mem_rdata2   ),
		.mem_la_read (mem_la_read2 ),
		.mem_la_write(mem_la_write2),
		.mem_la_addr (mem_la_addr2 ),
		.mem_la_wdata(mem_la_wdata2),
		.mem_la_wstrb(mem_la_wstrb2)
	);


    memory_modelling memory_modelling_inst(
	                  .clk(clk), 
	                  .mem_la_wstrb(mem_la_wstrb),
			  .mem_la_wdata(mem_la_wdata),
			  .mem_la_addr(mem_la_addr),
			  .mem_la_write(mem_la_write),
			  .mem_la_read(mem_la_read),
			  .mem_ready(mem_ready),
			  .mem_rdata(mem_rdata),
			  .mem_la_wstrb1(mem_la_wstrb1),
			  .mem_la_wdata1(mem_la_wdata1),
			  .mem_la_addr1(mem_la_addr1),
			  .mem_la_write1(mem_la_write1),
			  .mem_la_read1(mem_la_read1),
			  .mem_ready1(mem_ready1),
			  .mem_rdata1(mem_rdata1),
                          .mem_la_wstrb2(mem_la_wstrb2),
			  .mem_la_wdata2(mem_la_wdata2),
			  .mem_la_addr2(mem_la_addr2),
			  .mem_la_write2(mem_la_write2),
			  .mem_la_read2(mem_la_read2),
			  .mem_ready2(mem_ready2),
			  .mem_rdata2(mem_rdata2));
		  
  initial begin
      `ifdef NOP
         $readmemh("./firmware/firmware_nop.hex", memory_modelling_inst.foobar);
         $readmemh("./firmware/firmware_nop.hex", memory_modelling_inst.foobar1);
         $readmemh("./firmware/firmware_nop.hex", memory_modelling_inst.foobar2);
      `elsif ADDI
         $readmemh("./firmware/firmware_addi.hex", memory_modelling_inst.foobar);
         $readmemh("./firmware/firmware_addi.hex", memory_modelling_inst.foobar1);
         $readmemh("./firmware/firmware_addi.hex", memory_modelling_inst.foobar2);
      `elsif STORE_LOAD
         $readmemh("./firmware/firmware_store_load.hex", memory_modelling_inst.foobar);
         $readmemh("./firmware/firmware_store_load.hex", memory_modelling_inst.foobar1);
         $readmemh("./firmware/firmware_store_load.hex", memory_modelling_inst.foobar2);
      `elsif JUMP
         $readmemh("./firmware/firmware_jump.hex", memory_modelling_inst.foobar);
         $readmemh("./firmware/firmware_jump.hex", memory_modelling_inst.foobar1);
         $readmemh("./firmware/firmware_jump.hex", memory_modelling_inst.foobar2);
      `else
         $readmemh("./firmware/firmware_rand.hex", memory_modelling_inst.foobar);
         $readmemh("./firmware/firmware_rand.hex", memory_modelling_inst.foobar1);
         $readmemh("./firmware/firmware_rand.hex", memory_modelling_inst.foobar2);
      `endif
    end


endmodule
