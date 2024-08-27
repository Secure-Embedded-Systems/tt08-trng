module ro (
    input wire RSTn,
    input wire CLK,
    input wire ro_activate,
    output reg [15:0] ro_out
);

reg [15:0] ro_count;
reg en;
wire q;
wire [15:0] ro_output;


assign ro_output = ro_count;
/*
always @(posedge q or posedge RSTn) begin
    if (RSTn)
        ro_out <= 16'h0000;
    else if (ro_count == 16'hffff)
        ro_out <= 16'h0000;
    else
        ro_out <= ro_count + 1'b1;
end
*/

always @(posedge q or posedge RSTn) begin
    if (RSTn)
        ro_out <= 16'h0000;
    else if (ro_activate)
        ro_out <= ro_output;
    else
        ro_out <= 16'h0000;
end


always @(posedge CLK or posedge RSTn) begin
    if (RSTn)
        en <= 1'b0;
    else if (ro_activate)
        en <= 1'b1;
    else
        en <= 1'b0;
end

ro_stage_top dut_ro (
    .en(en),
    .q(q)
);

always @(posedge q or posedge RSTn) begin
    if (RSTn)
        ro_count <= 16'h0000;
    else if (ro_count == 16'hffff)
        ro_count <= 16'h0000;
    else
        ro_count <= ro_count + 1'b1;
end

endmodule
//------------------------------------


module ro_long_stage
  (input wire en,
   output wire q);
   parameter STAGES = 5;
   (*keep = "true" *) wire [0:(STAGES-2)] ni;
   (*keep = "true" *) wire             nandout /* synthesis keep = 1 */;
   (*keep = "true" *) wire [0:(STAGES-2)] no      /* synthesis keep = 1 */;

   customNand nc(nandout ,en, no[(STAGES-2)]);
   (*keep = "true"*) customInv  ic[0:(STAGES-2)] (ni, no);

   assign #2.5 ni[0]            = nandout;
   assign ni[1:(STAGES-2)] = no[0:(STAGES-3)];
   assign q                = no[(STAGES-3)];
endmodule
//--------------------------------

module ro_stage_top(input wire en,
              output wire q);

   (*keep = "true"*) ro_long_stage myro_long(en, q);

endmodule
//------------------------------

module customNand
  (
  output wire q,
   input wire  a,
   input wire  b
   
   );

wire a_delay, b_delay, q_delay;

(* keep = "true" *) sky130_fd_sc_hd__buf_4 delay_a (a_delay,a);
(* keep = "true" *) sky130_fd_sc_hd__buf_4 delay_b (b_delay,b);
(* keep = "true" *) sky130_fd_sc_hd__nand2_1 nand_0 (q_delay ,a_delay, b_delay);
(* keep = "true" *) sky130_fd_sc_hd__buf_4  delay_q (q,q_delay);

endmodule
//---------------------------
module customInv
  (input wire  a,
  output wire q

   );

wire a_delay, q_delay;

(* keep = "true" *) sky130_fd_sc_hd__buf_4  delay_a (a_delay,a);
(* keep = "true" *) sky130_fd_sc_hd__inv_2 inv_0  (q_delay,a_delay);
(* keep = "true" *) sky130_fd_sc_hd__buf_4 delay_q (q_delay, q);

endmodule //inv cell
