module ring_osc(input wire  rst_n,
          input wire  clk,
          input wire  ro_activate,
          output reg [7:0]  ro_out);
   reg [7:0]         ro_count;
   reg                en;
   wire               ro_output;
   (*keep = "true" *) wire q;
   (*keep = "true" *) wire q0;
   (*keep = "true" *) wire q1;
   (*keep = "true" *) wire q2;
   (*keep = "true" *) wire q3;
   (*keep = "true" *) wire q4;
   (*keep = "true" *) wire q5;
   //assign ro_output = ro_count[0];
   assign ro_out = en ? ro_count : 8'b0;
   always @(posedge clk or posedge rst_n) begin
    if (rst_n)
        en <= 1'b0;
    else if (ro_activate)
        en <= 1'b1;
    else
        en <= 1'b0;
    end
    always @(posedge q or posedge rst_n) begin
     if (rst_n)
          ro_count <= 8'h0000;
     else if (ro_count == 7'hff)
          ro_count <= 8'h0000;
     else
          ro_count <= ro_count + 1'b1;
   end
    always @(posedge q or posedge rst_n) begin
    if (rst_n)
        ro_out <= 1'b0;
    else if (ro_activate)
        ro_out <= ro_output;
    else
        ro_out <= 1'b0;
    end
   (* keep = "true" *) wire cq4;
   assign cq4 = (en & q4);
   (* keep = 1 *) cinv cinv1(.a(cq4),.q(q0));
   (* keep = 1 *) cinv cinv2(.a(q0), .q(q1));
   (* keep = 1 *) cinv cinv3(.a(q1), .q(q2));
   (* keep = 1 *) cinv cinv4(.a(q2), .q(q3));
   (* keep = 1 *) cinv cinv5(.a(q3), .q(q4));
   assign q  = q0;
endmodule
