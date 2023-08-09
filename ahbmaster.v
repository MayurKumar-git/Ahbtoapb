module ahbmaster(input hclk, hresetn, hreadyout, input [31:0] hrdata, output reg [31:0] haddr,hwdata, output reg hwrite, hreadyin, output reg [1:0] htrans);
reg [2:0] hburst,hsize;
integer i;

task single_write();
 begin
   @(posedge hclk)
	#1;
	begin
	  hwrite=1;
          htrans=2'd2;
          hsize=0;
          hburst=0;
          hreadyin=1;
          haddr=32'h8000_0000;
	end
    @(posedge hclk)
        #1;
        begin
	  hwdata=32'h24;
	  htrans=2'd0;
        end
 end
endtask

task single_read();
 begin
    @(posedge hclk)
	#1;
	begin
	  hwrite=0;
          htrans=2'd2;
          hsize=0;
          hburst=0;
          hreadyin=1;
          haddr=32'h8000_0000;
	end
   @(posedge hclk)
        #1;
        begin
	  htrans=2'd0;
        end
 end
endtask

task burst_write_incr();
  begin
   @(posedge hclk)
	#1;
	begin
	  hwrite=1;
          htrans=2'd2;
          hsize=0;
          hburst=0;
          hreadyin=1;
          haddr=32'h8000_0000;
	end
    @(posedge hclk)
        #1;
        begin
	  hwdata={$random}%256;
	  haddr=haddr+1;
	  htrans=2'd3;
        end
    @(posedge hclk);
     for(i=0;i<2; i=i+1)
	begin
            @(posedge hclk)
	    #1;
	    begin
	       hwdata={$random}%256;
	       haddr=haddr+1;
	       htrans=2'd3;
            end
	   @(posedge hclk);
        end
     @(posedge hclk)
       begin
         hwdata={$random}%256;
         htrans=2'd0;
       end
 end
endtask

task burst_write_wrap();
  begin
   @(posedge hclk)
	#1;
	begin
	  hwrite=1;
          htrans=2'd2;
          hsize=0;
          hburst=0;
          hreadyin=1;
          haddr=32'h8000_0000;
	end
    @(posedge hclk)
        #1;
        begin
	  haddr={haddr[31:2], haddr[1:0]+1'b1};
	  hwdata={$random}%256;
	  htrans=2'd3;
        end
    @(posedge hclk);
     for(i=0;i<2; i=i+1)
	begin
            @(posedge hclk)
	    #1;
	    begin
	       haddr={haddr[31:2], haddr[1:0]+1'b1};
	       hwdata={$random}%256;
	       htrans=2'd3;
            end
            @(posedge hclk);
        end
     @(posedge hclk)
       begin
         hwdata={$random}%256;
         htrans=2'd0;
       end
 end
endtask

task burst_read_incr();
  begin
  @(posedge hclk)
  #1;
  begin 
	hwrite=0;
	htrans=2'd2;
	hsize=0;
	hburst=0;
	hreadyin=1;
	haddr=32'h8000_0000;
  end

	for(i=0;i<3;i=i+1)
	begin
	@(posedge hclk)
	#1;
	begin
	haddr=haddr+1;
	htrans=2'd3;
	end
	@(posedge hclk);
	end
	@(posedge hclk)
	#1;
	begin
	htrans=2'd0;
	end
	end
endtask

task burst_read_wrap();
  begin
     @(posedge hclk)
  #1;
  begin 
	hwrite=0;
	htrans=2'd2;
	hsize=0;
	hburst=0;
	hreadyin=1;
	haddr=32'h8000_0000;
  end

	for(i=0;i<3;i=i+1)
	begin
	@(posedge hclk)
	#1;
	begin
	haddr={haddr[31:2], haddr[1:0]+1'b1};
	htrans=2'd3;
	end
	@(posedge hclk);
	end
	@(posedge hclk)
	#1;
	begin
	htrans=2'd0;
	end
   
  end
endtask 
endmodule
