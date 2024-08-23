module ring_osc(
    input wire en,
    output wire out
);

    localparam num_inv = 3;
    genvar i;

    wire [num_inv:0] inter_wire;

    // Generate the inverters for the ring oscillator
    generate
        for (i = 0; i < num_inv; i = i+1) begin : inv_loop
            sky130_fd_sc_hd__inv_2 inv (
                .A(inter_wire[i]),      // Input to the inverter
                .X(inter_wire[i+1]),   // Output from the inverter
                .VPWR(VPWR),            // Connect power (logic high)
                .VGND(VGND),            // Connect ground (logic low)
                .VPB(VPWR),             // Bulk connection (typically tied to power)
                .VNB(VGND)
            );
        end
    endgenerate

    // NAND gate at the start of the ring oscillator
    sky130_fd_sc_hd__nand2_1 nand_gate (
        .A(en),
        .B(inter_wire[num_inv]),
        .X(inter_wire[0]),
        .VPWR(VPWR),            // Connect power (logic high)
                .VGND(VGND),            // Connect ground (logic low)
                .VPB(VPWR),             // Bulk connection (typically tied to power)
                .VNB(VGND)
    );

    // Output is taken from the last inverter stage
    assign out = inter_wire[num_inv];


endmodule

