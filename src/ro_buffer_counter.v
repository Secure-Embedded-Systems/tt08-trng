module ro_buffer_counter (
    input wire rst_n,
    input wire clk,
    input wire ro_activate_1,
    input wire ro_activate_2,
    input wire [2:0] out_sel,
    output reg [7:0] out
);

   // Wires to connect the outputs of the two ring oscillators
   wire      ro1_out;
   wire         ro2_out;
   reg          ro_1_reg;
   reg          ro_2_reg;
   wire       xor_out;
   reg[63:0]    shift_register;

   // Instantiate the first ring oscillator
   ring_osc ro1 (.rst_n(rst_n),
	   .clk(clk),
           .ro_activate(ro_activate_1),
           .ro_out(ro1_out)
           );

   // Instantiate the second ring oscillator
   ring_osc ro2 (.rst_n(rst_n),
	   .clk(clk),
           .ro_activate(ro_activate_2),
           .ro_out(ro2_out)
           );

   
   // Store the ro1 out result in a register (DFF) on the clock edge
   always @(posedge clk or posedge rst_n) begin
      if (rst_n)
        ro_1_reg <= 1'b0;
      else
        ro_1_reg <= ro1_out;
   end

   // Store the ro2 out result in a register (DFF) on the clock edge
   always @(posedge clk or posedge rst_n) begin
      if (rst_n)
        ro_2_reg <= 1'b0;
      else
        ro_2_reg <= ro2_out;
   end

   assign xor_out = ro_1_reg ^ ro_2_reg;

   // Shift in the XOR result on the clock edge
   always @(posedge clk or posedge rst_n) begin
      if (rst_n)
         shift_register <= 64'b0;
      else
         shift_register <= {shift_register[62:0], xor_out};
   end

   // Store the XOR result in the register on the clock edge
   always @(posedge clk or posedge rst_n) begin
      if (rst_n)
          out <= 8'h00;
      else begin
          if (out_sel == 3'b111)
              out <= shift_register[63:56];
          else if (out_sel == 3'b110)
              out <= shift_register[55:48];
          else if (out_sel == 3'b101)
              out <= shift_register[47:40];
          else if (out_sel == 3'b100)
              out <= shift_register[39:32];
          else if (out_sel == 3'b011)
              out <= shift_register[31:24];
          else if (out_sel == 3'b010)
              out <= shift_register[23:16];
          else if (out_sel == 3'b001)
              out <= shift_register[15:8];
          else if (out_sel == 3'b000)
              out <= shift_register[7:0];
          else
              out <= 8'h00;
      end
   end

endmodule
