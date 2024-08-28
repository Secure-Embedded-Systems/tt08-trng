(* keep_hierarchy = "yes" *)
module cinv(input a,
            output q);

`ifdef SIMULATION
   assign q = #1 ~a;
`else
   assign q = ~a;
`endif

endmodule
