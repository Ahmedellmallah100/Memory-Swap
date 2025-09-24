module Swap_Fsm (
    swap ,sel ,w,clk ,rstn
);

parameter s0=2'b00;
parameter s1=2'b01;
parameter s2=2'b10;
parameter s3=2'b11;


input clk ,rstn;
input  swap ; 
output w ;
output [1:0] sel;


reg [1:0] cs ,ns;

//
always @(posedge clk or negedge rstn) begin
    if (!rstn) begin
        cs <= s0;
    end else begin
        cs <= ns ;
    end
end


always @( *) begin
    case (cs)
        s0: if (!swap) begin
            ns =s0;
        end else begin
            ns = s1;
        end
        s1: ns =s2;
        s2: ns =s3;
        s3: ns =s0;

        default : ns= s0;
            
    endcase
end

assign sel = cs;
assign w = (|cs);



endmodule //Swap_Fsm