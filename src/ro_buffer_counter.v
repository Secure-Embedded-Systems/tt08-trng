module ro_buffer_counter(
    input wire CLK,
    input wire RSTn,
    input wire en,
    output wire [15:0] buffer_out
);

    wire ro_out1, ro_out2;
    wire xor_out;
    wire [15:0] counter;
    reg [15:0] buffer;

    // Instantiate the first ring oscillator
    ring_osc RO1 (
        .CLK(CLK),
        .en(en),
        .out(ro_out1)
    );

    // Instantiate the second ring oscillator
    ring_osc RO2 (
        .CLK(CLK),
        .en(en),
        .out(ro_out2)
    );

    // XOR the outputs of the two ring oscillators using a SkyWater XOR gate
    sky130_fd_sc_hd__xor2_1 xor_gate (
        .A(ro_out1),
        .B(ro_out2),
        .X(xor_out)
    );
    // Simplified counter to keep track of buffer
    always @(posedge CLK or negedge RSTn) begin
        if (!RSTn)
            counter <= 16'b0;  // Reset counter
        else if (en)
            counter <= counter + 1'b1;  // Increment counter on each clock cycle when enabled
    end

    // Buffer to store XOR output using D flip-flops
    always @(posedge CLK or negedge RSTn) begin
        if (!RSTn)
            buffer <= 16'b0;  // Reset buffer
        else if (en)
            buffer <= {buffer[14:0], xor_out};  // Shift buffer left and store new XOR output in LSB
    end

    // Output the buffer content
    assign buffer_out = buffer;

endmodule
