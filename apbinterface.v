module apbinterface(input pwrite,penable, input [31:0] paddr,pwdata, input [2:0] pselx,output pwrite_out,penable_out, output [31:0] paddr_out,pwdata_out, output [2:0] pselx_out, output reg [31:0] prdata);

	assign pselx_out=pselx;
	assign pwrite_out=pwrite;
	assign penable_out=penable;
	assign paddr_out=paddr;
	assign pwdata_out=pwdata;
	
	always@(*)
	   begin
             if(pwrite==0 && penable==1) prdata={$random}%256;
	     else prdata=0;
	   end


endmodule
