module reg_file   (
  clk, address_w ,we ,data_w ,data_r ,address_r
);
//parameters
parameter width =7;
parameter depth =8;

//ports
input clk;
input [width-1 :0] address_w ,address_r;
input we;
input [depth-1 :0] data_w ;
output [depth-1 :0] data_r;

//mem
reg  [depth-1 :0]mem  [width-1 :0];

// synchronous write port
always @(posedge clk) begin
    if (we) begin
        mem[address_w] <= data_w;
    end 
end

// Asynchronous read port 
assign data_r = mem[address_r];

endmodule //reg_file