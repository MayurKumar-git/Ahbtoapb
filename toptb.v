module toptb();

reg hclk,hresetn;
wire hwrite, hreadyin, hreadyout, pwrite,penable, pwrite_out,penable_out;
wire [31:0] hrdata,haddr,hwdata,prdata,paddr,pwdata,pwdata_out,paddr_out;
wire [2:0] pselx, pselx_out;
wire [1:0] htrans,hresp;
ahbmaster A1 (hclk, hresetn, hreadyout,  hrdata,haddr,hwdata,  hwrite, hreadyin, htrans);
apbinterface A2( pwrite,penable, paddr,pwdata, pselx, pwrite_out,penable_out, paddr_out,pwdata_out,  pselx_out,  prdata);
bridgetop A3( hclk, hresetn, hwrite, hreadyin,  htrans,  hwdata, haddr,prdata,  penable,pwrite, hreadyout,paddr, pwdata, hrdata, pselx, hresp);

initial begin
hclk=1'b0;
forever #10 hclk=~hclk;
end

task reset();
begin
	@(negedge hclk)
		hresetn=0;
	@(negedge hclk)
		hresetn=1;
end
endtask

initial begin
reset(); //resetting before simulation
//A1.single_write(); //Single Write
//A1.single_read();
//A1.burst_write_wrap();
A1.burst_read_wrap();
#5000 $finish;
end
endmodule
