module GenSignal(rst, clk_serial_bits, enable, word, signal);
input rst, clk_serial_bits, enable;
input [11:0] word;
output reg signal;
reg [3:0] serial_count;

always@(posedge clk_serial_bits or negedge rst) begin
  if(~rst) begin
    signal <= 1;
    serial_count <= 0;
  end
  else begin
    if(enable) begin
      case (serial_count)
      4'd0:begin
        signal <= 1'b0;
        serial_count <= 4'd1;
      end 
      4'd1:begin
        signal <= word[0];
        serial_count <= 4'd2;
      end 
      4'd2:begin
        signal <= word[1];
        serial_count <= 4'd3;
      end 
      4'd3:begin
        signal <= word[2];
        serial_count <= 4'd4;
      end 
      4'd4:begin
        signal <= word[3];
        serial_count <= 4'd5;
      end 
      4'd5:begin
        signal <= word[4];
        serial_count <= 4'd6;
      end 
      4'd6:begin
        signal <= word[5];
        serial_count <= 4'd7;
      end 
      4'd7:begin
        signal <= word[6];
        serial_count <= 4'd8;
      end 
      4'd8:begin
        signal <= word[7];
        serial_count <= 4'd9;
      end 
      4'd9:begin
        signal <= word[8];
        serial_count <= 4'd10;
      end 
      4'd10:begin
        signal <= word[9];
        serial_count <= 4'd11;
      end 
      4'd11:begin
        signal <= word[10];
        serial_count <= 4'd12;
      end
      4'd12:begin
        signal <= word[11];
        serial_count <= 4'd13;
      end
      4'd13:begin
        signal <= 1'b1;
        serial_count <= 4'd14;
      end
      4'd14:begin
        signal <= 1'b1;
        serial_count <= 4'd15;
      end
      4'd15:begin
        signal <= 1'b1;
        serial_count <= 4'd0;
      end
    endcase
    end
    else begin
      signal <= 1'b1;
      serial_count <= 0;
    end
    
  end
end

endmodule


module DecodeSignal(rst, clk_serial_bits, signal, rev_word, enable);
input rst, clk_serial_bits, signal;
output reg [11:0] rev_word;
reg [11:0] word;
output reg enable; // 是否接收到了数据，1表示正在接受数据，0表示数据接受完毕或者没有数据

reg [3:0] count;

always @(posedge clk_serial_bits or negedge rst) begin
  if(~rst) begin
    enable <= 0;
    count <= 0;
    word <= 0;
    rev_word <= 0;
  end
  else begin
    if(~signal && ~enable) begin
      enable <= 1;
      count <= 0;
      word <= 0;
      rev_word <= 0;
    end
    else begin
      if(enable) begin
        case(count) 
          4'd0:begin
            word[0] <= signal;
            count <= 4'd1;
            rev_word <= 0;
            enable <= 1;
          end
          4'd1:begin
            word[1] <= signal;
            count <= 4'd2;
            rev_word <= 0;
            enable <= 1;
          end
          4'd2:begin
            word[2] <= signal;
            count <= 4'd3;
            rev_word <= 0;
            enable <= 1;
          end
          4'd3:begin
            word[3] <= signal;
            count <= 4'd4;
            rev_word <= 0;
            enable <= 1;
          end
          4'd4:begin
            word[4] <= signal;
            count <= 4'd5;
            rev_word <= 0;
            enable <= 1;
          end
          4'd5:begin
            word[5] <= signal;
            count <= 4'd6;
            rev_word <= 0;
            enable <= 1;
          end
          4'd6:begin
            word[6] <= signal;
            count <= 4'd7;
            rev_word <= 0;
            enable <= 1;
          end
          4'd7:begin
            word[7] <= signal;
            count <= 4'd8;
            rev_word <= 0;
            enable <= 1;
          end
          4'd8:begin
            word[8] <= signal;
            count <= 4'd9;
            rev_word <= 0;
            enable <= 1;
          end
          4'd9:begin
            word[9] <= signal;
            count <= 4'd10;
            rev_word <= 0;
            enable <= 1;
          end
          4'd10:begin
            word[10] <= signal;
            count <= 4'd11;
            rev_word <= 0;
            enable <= 1;
          end
          4'd11:begin
            word[11] <= signal;
            count <= 4'd12;
            rev_word <= 0;
            enable <= 1;
          end
          4'd12:begin
            count <= 4'd0;
            enable <= 0;
            rev_word <= word;
            word <= 0;
          end
        endcase
      end
      else begin
        word <= 0;
        count <= 0;
        enable <= 0;
        rev_word <= 0;
      end
    end

  end
end
endmodule