module FSKEncode(clk_f0, clk_f1, din, dout);

input  clk_f0, clk_f1, din;
output reg dout;
always@(*) begin
  if(din == 0) begin
    dout = clk_f0;
  end
  else begin
    dout = clk_f1;
  end
end

endmodule


module FSKDecode(rst, clk, clk_serial_bits, din, dout);
input rst, clk ,clk_serial_bits, din;
output reg dout;
parameter count_max = 25;
reg [8:0] count;
reg [1:0] count_clear; // count判断并清零

// 生成清零判断脉冲
always@(posedge clk or negedge rst) begin
  if(~rst) begin
    count_clear <= 2'b00;
  end
  case(count_clear)
    2'b00:begin
      if(clk_serial_bits) begin
        count_clear <= 2'b01;
      end
      else begin
        count_clear <= 2'b00;
      end
    end
    2'b01:begin
      count_clear <= 2'b10;
    end
    2'b10:begin
      if(clk_serial_bits) begin
        count_clear <= 2'b10;
      end
      else begin
        count_clear <= 2'b00;
      end
    end
    2'b11:begin
      count_clear <= 2'b00;
    end
  endcase
end

// 根据1bit周期内FSK信号的计数来判断其频率
always @(posedge din or negedge rst or posedge count_clear[0]) begin
  if(~rst) begin
    count <= 0;
    dout <= 1;
  end
  else begin
    
    if(count_clear[0]) begin
      if(count < count_max) begin
        dout <= 1;
      end
      else begin
        dout <= 0;
      end
      count <= 0;
    end
    else begin
      count <= count + 1'b1;
    end
    
  end
end

endmodule
















