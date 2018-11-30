module GenCLK(rst, clk, clk_f0, clk_f1, clk_serial_bits, clk_sample);
input rst, clk;
output reg clk_f0, clk_f1, clk_serial_bits, clk_sample;

parameter count_f0_max = 40000;
//parameter count_f0_max = 2;
parameter count_f1_max = 4;
parameter count_serial_bits_max = 24;
parameter count_sample_max = 399;

reg [18:0] count_f0;
reg [2:0] count_f1;
reg [4:0] count_serial_bits;
reg [8:0] count_sample;

// clk_f0
always@(posedge clk or negedge rst)
begin
  if (~rst) begin
    clk_f0 <= 0;
    count_f0 <= 0;
  end
  else begin
    if(count_f0 == count_f0_max) begin
      count_f0 <= 0;
      clk_f0 <= ~clk_f0;
    end
    else begin
      count_f0 <= count_f0 + 1'b1;
    end
  end
end

// clk_f1
always@(posedge clk_f0 or negedge rst)
begin
  if (~rst) begin
    clk_f1 <= 0;
    count_f1 <= 0;
  end
  else begin
    if(count_f1 == count_f1_max) begin
      count_f1 <= 0;
      clk_f1 <= ~clk_f1;
    end
    else begin
      count_f1 <= count_f1 + 1'b1;
    end
  end
end


// clk_serial_bits
always@(posedge clk_f0 or negedge rst)
begin
  if (~rst) begin
    clk_serial_bits <= 0;
    count_serial_bits <= 0;
  end
  else begin
    if(count_serial_bits == count_serial_bits_max) begin
      count_serial_bits <= 0;
      clk_serial_bits <= ~clk_serial_bits;
    end
    else begin
      count_serial_bits <= count_serial_bits + 1'b1;
    end
  end
end

// clk_sample
always@(posedge clk_f0 or negedge rst)
begin
  if (~rst) begin
    clk_sample <= 0;
    count_sample <= 0;
  end
  else begin
    if(count_sample == count_sample_max) begin
      count_sample <= 0;
      clk_sample <= ~clk_sample;
    end
    else begin
      count_sample <= count_sample + 1'b1;
    end
  end
end

endmodule