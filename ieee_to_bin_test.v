`include "ieee_to_bin.v"

module frac_bin_tb();
reg clock , start;
reg [7:0] mantissa = 8'b1001_1000;
reg [7:0] exponent = 128;
// reg [7:0] exponent = 8'b0111_1100;
wire [7:0] decimal_portion;
wire [7:0] fraction_portion;

initial begin
  clock = 0;
  start = 1;
  #100 $finish;
end

initial begin
		 $monitor("Binary Format : decimal: %b, fraction: %b,", decimal_portion, fraction_portion);
end

always
#1 clock = ~clock;


frac_bin U_frac_bin(
  clock, // Clock
  start,
  mantissa,
  exponent,
  decimal_portion,
  fraction_portion
);



endmodule
