/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_roy1707018_roy1707018 (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

 // Instantiate the ro_buffer_counter module
  wire [15:0] buffer_out;
  wire ro_out;

  ro_buffer_counter ro_buffer_counter_inst (
      .RSTn(rst_n),
      .CLK(clk),
      . ro_activate_1 (ui_in[0]),
              . ro_activate_2 (ui_in[1]),
  
      .xor_buffer(buffer_out)
  );

  // Example: Output assignments (update based on your design needs)
  assign uo_out  = buffer_out[7:0];  // Example: take lower 8 bits of buffer_out
  assign uio_out = 0;
  assign uio_oe  = 0;

  // List all unused inputs to prevent warnings
  wire _unused = &{ena, uio_in, clk, rst_n, ro_out, ui_in[7:2], buffer_out[15:8], 1'b0};

endmodule

