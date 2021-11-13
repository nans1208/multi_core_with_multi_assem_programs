module memory_modelling (input logic clk, 
	                input logic [3:0] mem_la_wstrb, 
			input logic [31:0] mem_la_wdata, 
			input logic [31:0] mem_la_addr, 
			input logic mem_la_read,
			input logic mem_la_write,
			output logic mem_ready, 
			output logic [31:0] mem_rdata,
		        input logic [3:0] mem_la_wstrb1, 
			input logic [31:0] mem_la_wdata1, 
			input logic [31:0] mem_la_addr1, 
			input logic mem_la_read1,
			input logic mem_la_write1,
			output logic mem_ready1, 
			output logic [31:0] mem_rdata1,
		        input logic [3:0] mem_la_wstrb2, 
			input logic [31:0] mem_la_wdata2, 
			input logic mem_la_read2,
			input logic [31:0] mem_la_addr2,
		        input logic mem_la_write2,	
			output logic mem_ready2, 
			output logic [31:0] mem_rdata2);
	
  logic [31:0] foobar  [logic [31:0]];
  logic [31:0] foobar1 [logic [31:0]];
  logic [31:0] foobar2 [logic [31:0]];

  logic [31:0] mem_inst;
  logic [2:0] flag;

  always @(posedge clk) begin

	  // On every clock cycle checking for reading
	  mem_ready <= 1;
	  mem_ready1 <= 1;
	  mem_ready2 <= 1;
	  if ((flag & 3'h1) == 3'h1 && mem_la_read) begin
	    mem_rdata = mem_read (mem_la_addr, flag);
          end
	  if ((flag & 3'h2) == 3'h2 && mem_la_read1) begin
	    mem_rdata1 = mem_read (mem_la_addr1, flag);
          end
	  if ((flag & 3'h4) == 3'h4 && mem_la_read2) begin
	    mem_rdata2 = mem_read (mem_la_addr2, flag);
          end

	  // On evry clock cycle checking for writing
	  if((flag & 3'h1) == 3'h1 && (mem_la_write == 1)) begin
            mem_write (mem_la_addr, mem_la_wstrb, mem_la_wdata, flag);
	  end
	  if((flag & 3'h2) == 3'h2 && (mem_la_write1 == 1)) begin
            mem_write (mem_la_addr1, mem_la_wstrb1, mem_la_wdata1, flag);
	  end
	  if((flag & 3'h4) == 3'h4 && (mem_la_write1 == 1)) begin
            mem_write (mem_la_addr2, mem_la_wstrb2, mem_la_wdata2, flag);
	  end
  end


  // Read function
  function logic [31:0] mem_read(input logic [31:0] m_addr, input logic [2:0] flag);
    logic [31:0] mem_rdata;

    if ((flag & 3'h1) == 3'h1) begin
      mem_rdata = foobar[m_addr >> 2];
    end
    else if ((flag & 3'h2) == 3'h2) begin
      mem_rdata = foobar1[m_addr >> 2];
    end
    else if ((flag & 3'h4) == 3'h4) begin
      mem_rdata = foobar2[m_addr >> 2];
    end
    return mem_rdata;
  endfunction

  // Write task
  task mem_write(input logic [31:0] mem_addr, input logic [3:0] write_strobe, input logic [31:0] wdata, input logic [2:0] flag);
     logic [31:0] m_addr;

     if ((flag & 3'h1) == 3'h1) begin
       m_addr = mem_addr >> 2;
       if (write_strobe[0]) foobar[m_addr][ 7: 0] = wdata[ 7: 0];
       if (write_strobe[1]) foobar[m_addr][15: 8] = wdata[15: 8];
       if (write_strobe[2]) foobar[m_addr][23:16] = wdata[23:16];
       if (write_strobe[3]) foobar[m_addr][31:24] = wdata[31:24];
     end
     else if ((flag & 3'h2) == 3'h2) begin
       m_addr = mem_addr >> 2;
       if (write_strobe[0]) foobar1[m_addr][ 7: 0] = wdata[ 7: 0];
       if (write_strobe[1]) foobar1[m_addr][15: 8] = wdata[15: 8];
       if (write_strobe[2]) foobar1[m_addr][23:16] = wdata[23:16];
       if (write_strobe[3]) foobar1[m_addr][31:24] = wdata[31:24];
     end
     else if ((flag & 3'h4) == 3'h4) begin
       m_addr = mem_addr >> 2;
       if (write_strobe[0]) foobar2[m_addr][ 7: 0] = wdata[ 7: 0];
       if (write_strobe[1]) foobar2[m_addr][15: 8] = wdata[15: 8];
       if (write_strobe[2]) foobar2[m_addr][23:16] = wdata[23:16];
       if (write_strobe[3]) foobar2[m_addr][31:24] = wdata[31:24];
     end
  endtask

endmodule
