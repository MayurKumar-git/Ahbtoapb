module ahbslave(input hclk, hresetn, hwrite, hready_in, input [31:0] haddr, hwdata,prdata, input [1:0] htrans, output [31:0] hrdata, output [1:0] hresp, output reg hwrite_reg,hwrite_reg1,valid, output reg [31:0] hwdata1,hwdata2,haddr1,haddr2, output reg [2:0] tempselx);
	// coding the pipelining structre.
	//AHB slaves need pipelining to induce delay.
	always@(posedge hclk)
	begin
		if(!hresetn)
		begin
			hwdata1<=0;
			hwdata2<=0;
			haddr1<=0;
			haddr2<=0;
			hwrite_reg<=0;
			hwrite_reg1<=0;
		end
		else 
		begin
			hwdata1<=hwdata;
			hwdata2<=hwdata1;
			haddr1<=haddr;
			haddr2<=haddr1;
			hwrite_reg<=hwrite;
			hwrite_reg1<=hwrite_reg;
		end
	end
	always@(*)
	begin
		if(hresetn==1 && hready_in==1 && (haddr>=32'h8000_0000 && haddr<32'h8C00_0000) && (htrans==2'b10 || htrans == 2'b11)) valid=1;
		else valid=0;
	end
	always@(*)
	begin
		if(haddr>=32'h8000_0000 && haddr<32'h8400_0000) tempselx =3'b001;
		else if(haddr>=32'h8400_0000 && haddr<32'h8800_0000) tempselx=3'b010;
		else if(haddr>=32'h8800_0000 && haddr<32'h8C00_0000) tempselx=3'b100;
		else tempselx=3'b000;
	end
	assign hresp=0;
	assign hrdata= prdata;
endmodule 