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
            sky130_fd_sc_hd__inv_2 inv(inter_wire[i],inter_wire[i+1]
            );
        end
    endgenerate

    // NAND gate at the start of the ring oscillator
    nand  nand_gate(en,
        inter_wire[num_inv],inter_wire[0]
    );

    // Output is taken from the last inverter stage
    assign out = inter_wire[num_inv];


endmodule

