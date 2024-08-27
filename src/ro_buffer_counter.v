module dual_ro_xor (
    input wire RSTn,
    input wire CLK,
    input wire ro_activate_1,
    input wire ro_activate_2,
    output reg [15:0] xor_out
);

    // Wires to connect the outputs of the two ring oscillators
    wire [15:0] ro1_out;
    wire [15:0] ro2_out;
    wire [15:0] xor_buffer;

    // Instantiate the first ring oscillator
    ro ro1 (
        .RSTn(RSTn),
        .CLK(CLK),
        .ro_activate(ro_activate_1),
        .ro_out(ro1_out)
    );

    // Instantiate the second ring oscillator
    ro ro2 (
        .RSTn(RSTn),
        .CLK(CLK),
        .ro_activate(ro_activate_2),
        .ro_out(ro2_out)
    );

    // XOR the outputs of the two ring oscillators using the sky130_fd_sc_hd__xor2_1 gate
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : gen_xor
            sky130_fd_sc_hd__xor2_1 xor_gate (
                xor_buffer[i],     // XOR result for each bit
                ro1_out[i],        // Bit from first ring oscillator
                ro2_out[i]         // Bit from second ring oscillator
            );
        end
    endgenerate

    // Store the XOR result in the register on the clock edge
    always @(posedge CLK or posedge RSTn) begin
        if (RSTn)
            xor_out <= 16'h0000;
        else
            xor_out <= xor_buffer;
    end

endmodule
