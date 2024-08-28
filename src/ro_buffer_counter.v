module ro_buffer_counter (
    input wire rst_n,
    input wire clk,
    input wire ro_activate_1,
    input wire ro_activate_2,
    output reg [15:0] xor_out
);

   // Wires to connect the outputs of the two ring oscillators
   wire [15:0]        ro1_out;
   wire [15:0]        ro2_out;
   wire [15:0]        xor_buffer;

   // Instantiate the first ring oscillator
   ring_osc ro1 (.rst_n(rst_n),
           .ro_activate(ro_activate_1),
           .ro_out(ro1_out)
           );

   // Instantiate the second ring oscillator
   ring_osc ro2 (.rst_n(rst_n),
           .ro_activate(ro_activate_2),
           .ro_out(ro2_out)
           );

   assign xor_buffer = ro1_out ^ ro2_out;

   // Store the XOR result in the register on the clock edge
   always @(posedge clk or posedge rst_n) begin
      if (rst_n)
        xor_out <= 16'h0000;
      else
        xor_out <= xor_buffer;
   end

endmodule
