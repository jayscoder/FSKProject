module GenWord(rst, clk_word, word, enable);
input rst, clk_word;
output reg[7:0] word;
output reg enable; // 当发送word的时候enable为1，否则为0
reg [2:0] word_index; // 0 ~ 7

always@(posedge clk_word or negedge rst) begin
  if(~rst) begin
    word <= 0;
    word_index <= 0;
    enable <= 0;
  end
  else begin
    case (word_index)
      3'b000:begin
        word <= 8'b00000001;
        word_index <= 3'b001;
      end 
      3'b001:begin
        word <= 8'b00000010;
        word_index <= 3'b010;
      end
      3'b010:begin
        word <= 8'b00000100;
        word_index <= 3'b011;
      end
      3'b011:begin
        word <= 8'b00001000;
        word_index <= 3'b100;
      end
      3'b100:begin
        word <= 8'b00010000;
        word_index <= 3'b101;
      end
      3'b101:begin
        word <= 8'b00100000;
        word_index <= 3'b110;
      end
      3'b110:begin
        word <= 8'b01000000;
        word_index <= 3'b111;
      end
      3'b111:begin
        word <= 8'b10000000;
        word_index <= 3'b000;
      end
    endcase
    enable <= 1;
  end
end



endmodule