(* keep_hierarchy = "yes" *)
module cinv(input a,
            output q);

`ifdef GL_TEST
   // Replace #30 delay with a long chain of inverters
   wire inv1, inv2, inv3, inv4, inv5, inv6, inv7, inv8, inv9, inv10, inv11, inv12;

   // Cascading inverters to create a delay equivalent to `#30`
   assign inv1 = ~a;
   assign inv2 = ~inv1;
   assign inv3 = ~inv2;
   assign inv4 = ~inv3;
   assign inv5 = ~inv4;
   assign inv6 = ~inv5;
   assign inv7 = ~inv6;
   assign inv8 = ~inv7;
   assign inv9 = ~inv8;
   assign inv10 = ~inv9;
   assign inv11 = ~inv10;
   assign inv12 = ~inv11;
   
   assign q = inv12;  // Final delayed output
`else
   assign q = ~a;
`endif

endmodule
