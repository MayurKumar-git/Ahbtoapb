module bridgetop(input hclk, hresetn, hwrite, hreadyin, input [1:0] htrans, input [31:0] hwdata, haddr,prdata, output penable,pwrite, hreadyout, output [31:0] paddr, pwdata, hrdata, output [2:0] pselx, output [1:0] hres);
 wire [31:0] haddr1,haddr2,hwdata1, hwdata2;
 wire [2:0] temp_selx;
 wire valid, hwrite_reg, hwrite_reg1;
ahbslave k1( hclk, hresetn,hwrite, hreadyin,haddr, hwdata,prdata,htrans,hrdata,  hres,  hwrite_reg,hwrite_reg1,valid, hwdata1,hwdata2,haddr1,haddr2, temp_selx );
apbcontrol k2(valid, hwrite,hwrite_reg,hresetn,hclk,haddr,hwdata,haddr1,haddr2,temp_selx,pwdata,paddr, pselx, penable, pwrite, hreadyout);
endmodule
