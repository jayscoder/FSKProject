module HammingEncode(inputBits, outputBits);
input wire [7:0] inputBits;
output reg [11:0] outputBits;

always@(*)begin
  outputBits[11:4] = inputBits[7:0];
  outputBits[3] = ((inputBits[7] ^ inputBits[6]) ^ inputBits[5] )^ inputBits[1];
  outputBits[2] = (((inputBits[7] ^ inputBits[4]) ^ inputBits[3] )^ inputBits[1]) ^ inputBits[0];
  outputBits[1] = (((inputBits[6] ^ inputBits[4]) ^ inputBits[2] )^ inputBits[1] ^ inputBits[0]);
  outputBits[0] = ((inputBits[5] ^ inputBits[3]) ^ inputBits[2] )^ inputBits[0];
end

endmodule


module HammingDecode(inputBits, outputBits);
input wire [11:0] inputBits;
output wire [7:0] outputBits;

reg [3:0] check;
reg [11:0] correctedInputBits;

always@(*)begin
    check[3] = (((inputBits[11] ^ inputBits[10] )^ inputBits[9]) ^ inputBits[5]) ^ inputBits[3];
    check[2] = ((((inputBits[11] ^ inputBits[8]) ^ inputBits[7]) ^ inputBits[5]) ^ inputBits[4]) ^ inputBits[2];
    check[1] = ((((inputBits[10] ^ inputBits[8]) ^ inputBits[6]) ^ inputBits[5]) ^ inputBits[4]) ^ inputBits[1];
    check[0] =  (((inputBits[9] ^ inputBits[7]) ^ inputBits[6]) ^ inputBits[4]) ^ inputBits[0];

    case(check[3:0])
        4'b1100: correctedInputBits = {~inputBits[11], inputBits[10:0]};
        4'b1010: correctedInputBits = {inputBits[11], ~inputBits[10], inputBits[9:0]};
        4'b1001: correctedInputBits = {inputBits[11:10], ~inputBits[9], inputBits[8:0]};
        4'b0110: correctedInputBits = {inputBits[11:9], ~inputBits[8], inputBits[7:0]};
        4'b0101: correctedInputBits = {inputBits[11:8], ~inputBits[7], inputBits[6:0]};
        4'b0011: correctedInputBits = {inputBits[11:7], ~inputBits[6], inputBits[5:0]};
        4'b1110: correctedInputBits = {inputBits[11:6], ~inputBits[5], inputBits[4:0]};
        4'b0111: correctedInputBits = {inputBits[11:5], ~inputBits[4], inputBits[3:0]};
        4'b1000: correctedInputBits = {inputBits[11:4], ~inputBits[3], inputBits[2:0]};
        4'b0100: correctedInputBits = {inputBits[11:3], ~inputBits[2], inputBits[1:0]};
        4'b0010: correctedInputBits = {inputBits[11:2], ~inputBits[1], inputBits[0]};
        4'b0001: correctedInputBits = {inputBits[11:1], ~inputBits[0]};
    default:
        correctedInputBits = inputBits;

  endcase
end

assign outputBits = correctedInputBits[11:4];
endmodule