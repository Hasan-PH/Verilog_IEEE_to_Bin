module frac_bin
(
    input clk,
    input start,
    // input [7:0] data,
    input [7:0] mantissa,
    input [7:0] exponent,
    output [7:0] decimal_portion,
    output [7:0] fraction_portion
 );


// reg start;
reg [2:0] ns;
reg [2:0] next_state;
reg [7:0] decimal_reg;
reg [7:0] fraction_reg;
reg [7:0] decimal_output;
reg [7:0] fraction_output;
// reg [7:0] data_reg;
reg [7:0] sub_result;

reg [7:0] count;

always @(start) begin
    if(start)begin
        ns = 3'b000;
    end
end

always @(ns) begin
    next_state = ns;
end

always @(posedge clk) begin
    case (next_state)
        3'b000:begin
            decimal_reg = 8'b0000_0001;
            fraction_reg = mantissa;
            count = 0;
            if (exponent > 127) begin
                sub_result = exponent - 127;
                ns = 3'b001;
            end
            else if (exponent < 127) begin
                sub_result = 127 - exponent;
                ns = 3'b011;
            end
            else begin
                ns = 3'b101;
            end
        end

        3'b001:begin
            decimal_reg = decimal_reg << 1;
            decimal_reg = decimal_reg + fraction_reg[7];
            ns = 3'b010;
        end

        3'b010:begin
            // $display("fraction: %b, count:%d,",fraction_reg, count);
            fraction_reg = fraction_reg << 1;
            count = count + 1;
            $display("time: %t, decimal: %b, fraction: %b, count:%d,",$time, decimal_reg, fraction_reg, count);
            if (count < sub_result)begin
                ns = 3'b001;
            end
            else
                ns = 3'b101;
        end

        3'b011:begin
            fraction_reg = fraction_reg >> 1;
            fraction_reg[7] = decimal_reg[0];
            ns = 3'b100;
        end

        3'b100:begin
            decimal_reg = decimal_reg >> 1;
            count = count + 1;
            $display("time: %t, decimal: %b, fraction: %b, count:%d,",$time, decimal_reg, fraction_reg, count);
            if (count < sub_result)begin
                ns = 3'b011;
            end
            else
                ns = 3'b101;
        end

        3'b101:begin
            decimal_output = decimal_reg;
            fraction_output = fraction_reg;
        end
        
        default:begin
          
        end 
    endcase
    
end

assign decimal_portion = decimal_output;
assign fraction_portion = fraction_output;


endmodule