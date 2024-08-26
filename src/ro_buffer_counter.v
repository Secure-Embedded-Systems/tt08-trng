module ro_buffer_counter(
    input wire CLK,
    input wire RSTn,
    input wire en,
    output wire [15:0] buffer_out
);

    wire ro_out1, ro_out2;
    reg [15:0] buffer1, buffer2;
    reg [3:0] counter;  // 4-bit counter to count up to 16 cycles
    wire [15:0] xor_buffer;

    // Instantiate the first ring oscillator
    ring_osc RO1 (
        .en(en),
        .out(ro_out1)
    );

    // Instantiate the second ring oscillator
    ring_osc RO2 (
        .en(en),
        .out(ro_out2)
    );

    // Counter and buffer reset logic
    always @(posedge CLK or negedge RSTn) begin
        if (!RSTn) begin
            counter <= 4'b0;         // Reset counter
            buffer1 <= 16'b0;        // Reset buffer1
            buffer2 <= 16'b0;        // Reset buffer2
        end else if (en) begin
            if (counter < 4'd15) begin
                counter <= counter + 1'b1;  // Increment counter
                buffer1 <= {buffer1[14:0], ro_out1};  // Shift left and store new ro_out1 bit
                buffer2 <= {buffer2[14:0], ro_out2};  // Shift left and store new ro_out2 bit
            end else begin
                counter <= 4'b0;         // Reset counter after 16 cycles
                buffer1 <= 16'b0;        // Reset buffer1 for the next cycle
                buffer2 <= 16'b0;        // Reset buffer2 for the next cycle
            end
        end
    end

    // XOR the buffers using the SkyWater130 XOR gate
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : xor_gen
            sky130_fd_sc_hd__xor2_1 xor_gate (xor_buffer[i],buffer1[i],buffer2[i]
            );
        end
    endgenerate

    // Output the XOR buffer content
    assign buffer_out = xor_buffer;
    
endmodule
