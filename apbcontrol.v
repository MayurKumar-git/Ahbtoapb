module apbcontrol(input valid, hwrite,hwritereg,hresetn,hclk,input [31:0] haddr,hwdata,haddr1, haddr2, input [2:0] temp_selx,  output reg [31:0] pwdata, paddr, output reg [2:0]pselx, output reg penable, pwrite, hreadyout);
parameter st_idle=3'b000,st_wwait=3'b001,st_read=3'b010,st_write=3'b011,st_writep=3'b100,st_renable=3'b101,st_wenable=3'b110,st_wenablep=3'b111;
reg [2:0] state, nextstate;
reg penable_temp,pwrite_temp, hreadyout_temp;
reg [31:0] paddr_temp, pwdata_temp;
reg [2:0] pselx_temp;
//reg [31:0] haddr1, haddr2;
//next state assignment
always@(posedge hclk)
begin
	if(!hresetn) state<=st_idle;
	else state<=nextstate;
end

//next state logic

always@(*)
begin
  case(state)
	st_idle: 
		begin
		   if(valid==1 && hwrite==1) nextstate= st_wwait;
		   else if(valid==1 && hwrite==0) nextstate=st_read;
		   else nextstate=st_idle;
		end
	st_wwait: 
		begin
		  if(valid==1) nextstate=st_writep;
		  else nextstate=st_write;
		end
	st_read: nextstate=st_renable;
	st_write: 
		begin
		   if(valid==1) nextstate=st_wenablep;
		   else nextstate=st_wenable;
		end
	st_writep: nextstate=st_wenablep;
	st_renable: 
		begin
		  if(valid==1 && hwrite==0) nextstate=st_read;
		  else if(valid==1 && hwrite==1) nextstate=st_wwait;
		  else nextstate=st_idle;
		end
	st_wenable:
		begin
		  if(valid==1 && hwrite==0) nextstate=st_read;
		  else if(valid==1 && hwrite==1) nextstate=st_wwait;
		  else nextstate=st_idle;
		end
	st_wenablep:
		begin
		  if(valid==0 && hwritereg==1) nextstate=st_write;
		  else if(valid==1 && hwritereg==1) nextstate=st_writep;
		  else nextstate=st_read;
		end
	default: nextstate=st_idle;
   endcase
end

//Temporary output logic
always@(*)
begin
  case(state)
	st_idle: begin
	   if(valid==1 && hwrite==0) begin
		paddr_temp=haddr;
		pwrite_temp=hwrite;
		pselx_temp=temp_selx;
		penable_temp=0;
		hreadyout_temp=0;
	   end
	   else if(valid==1 && hwrite==1) begin
		pselx_temp=0;
		penable_temp=0;
		hreadyout_temp=1;
		pwrite_temp=hwrite;
	   end
	  else  begin
		pselx_temp=0;
		penable_temp=0;
		hreadyout_temp=1;
	   end
	end
	st_wwait:
	   begin
		pselx_temp=0;
		penable_temp=0;
		hreadyout_temp=1;
		paddr_temp=haddr1;
		pwdata_temp=hwdata;
	   end
	st_read:
	  begin
		penable_temp=1;
		hreadyout_temp=1;
	   end
	
	st_write: 
	   begin
		penable_temp=1;
		hreadyout_temp=1;
	   end
	st_writep: 
	   begin
		penable_temp=1;
		hreadyout_temp=1;
	   end
	st_renable: begin
	   if(valid==1 && hwrite==0) begin
		paddr_temp=haddr;
		pwrite_temp=hwrite;
		pselx_temp=temp_selx;
		penable_temp=0;
		hreadyout_temp=0;
	   end
	   else if(valid==1 && hwrite==1) begin
		pselx_temp=0;
		penable_temp=0;
		hreadyout_temp=1;
	        pwrite_temp=hwrite;
	   end
	   else  begin
		pselx_temp=0;
		penable_temp=0;
		hreadyout_temp=1;
	   end
	end
	st_wenablep: 
	   begin
		pselx_temp=0;
		penable_temp=0;
		hreadyout_temp=1;
		paddr_temp=haddr2;
		pwdata_temp=hwdata;
	   end
	st_wenable: begin
	  if(valid==1 && hwrite==0) begin
		paddr_temp=haddr;
		pwrite_temp=hwrite;
		pselx_temp=temp_selx;
		penable_temp=0;
		hreadyout_temp=0;
	   end
	   else if(valid==1 && hwrite==1) begin
		pselx_temp=0;
		penable_temp=0;
		hreadyout_temp=1;
		pwrite_temp=hwrite;
	   end
	   else  begin
		pselx_temp=0;
		penable_temp=0;
		hreadyout_temp=1;
	   end
	end
	default: begin
	   if(valid==1 && hwrite==0) begin
		paddr_temp=haddr;
		pwrite_temp=0;
		pselx_temp=temp_selx;
		penable_temp=0;
		hreadyout_temp=0;
	   end
	   else if(valid==1 && hwrite==1) begin
		pselx_temp=0;
		penable_temp=0;
		hreadyout_temp=1;
	   end
	  else  begin
		pselx_temp=0;
		penable_temp=0;
		hreadyout_temp=1;
	   end
	end
  endcase	   	
end

always@(posedge hclk)
begin
	if(!hresetn) begin
 	        paddr=0;
		pwrite=0;
		pselx=0;
		penable=0;
		hreadyout=1;
		pwdata=0;
	end
	else begin
		paddr=paddr_temp;
		pwrite=pwrite_temp;
		pselx=pselx_temp;
		penable=penable_temp;
		hreadyout=hreadyout_temp;
		pwdata=pwdata_temp;
	end
end







endmodule

