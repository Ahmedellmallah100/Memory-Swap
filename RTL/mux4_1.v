module mux4_1 (
    sel ,f,w0,w1,w2,w3
);
parameter n=2;

input [n-1 :0] w0,w1,w2,w3;
input [1:0] sel; 
output reg [n-1 :0] f;


always @( *) begin
    case (sel)
        2'b00 : f=w0;
        2'b01 : f=w1;
        2'b10 : f=w2;
        2'b11 : f=w3;

        default :f=2'b0;
    endcase
end

endmodule //mux4_1