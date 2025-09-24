module Top (
   clk ,rstn , swap ,address_a ,address_b ,address_r ,address_w ,we ,data_w ,data_r
);

parameter width =7;
parameter depth =8;

input clk ,rstn;
input swap ;
input [width-1 :0] address_a ,address_b;
input [width-1 :0] address_r ,address_w;
input [depth-1 :0] data_w ;
input we;
output  [depth-1 :0] data_r;


wire [1:0]sel; 
wire w;
wire [width-1 :0] address_w_mux ,address_r_mux;

//fsm
Swap_Fsm fsm (.swap(swap) ,.sel(sel) ,.w(w) ,.clk(clk) ,.rstn(rstn));

//mux 4*1 address na
mux4_1 #(.n(width))  mux0 (.sel(sel) ,.f(address_r_mux) ,.w0(address_r) ,.w1(address_a) ,.w2(address_b) ,.w3(1'b0));


//mux 4*1 address b
mux4_1 #(.n(width)) mux1 (.sel(sel) ,.f(address_w_mux) ,.w0(address_w) ,.w1(1'b0) ,.w2(address_a) ,.w3(address_b));





// reg_file 
reg_file #(.width(width) ,.depth(depth)) reg1 (.clk(clk) ,.address_w(address_w_mux) ,.we(w?1'b1:we) ,.data_w(w?data_r:data_w) ,.data_r(data_r) ,.address_r(address_r_mux));
endmodule //Top