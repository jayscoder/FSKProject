`timescale 1ns/1ns

module FSKProject(rst, clk, input_light, output_light);

input rst, clk;
output wire[7:0] input_light;
output wire[7:0] output_light;


// 时钟信号
wire clk_sample ,clk_serial_bits, clk_f0, clk_f1;
// 生成时钟信号
GenCLK genclk(.rst(rst), .clk(clk), .clk_f0(clk_f0), .clk_f1(clk_f1), .clk_serial_bits(clk_serial_bits), .clk_sample(clk_sample));

// 传输的数字
wire [7:0] word;
wire send_word_enable; // 当前word是否有效
// 生成当前传输的数字
GenWord genWord(.rst(rst), .clk_word(clk_sample), .word(word), .enable(send_word_enable));
assign input_light = word;

// PCM编码
wire [7:0] pcmEncodeWord;
//assign pcmEncodeWord = word;
PCMmodu pcmmodu(.datain(word),.dataoutput(pcmEncodeWord));

// Hamming编码
wire [11:0] hammingEncodeWord;
HammingEncode hammingEncode(.inputBits(pcmEncodeWord), .outputBits(hammingEncodeWord));

// 模拟信道噪声带来的1bit误差
wire [11:0] hammingEncodeWord_Error;
assign hammingEncodeWord_Error = {hammingEncodeWord[11:8], ~hammingEncodeWord[7], hammingEncodeWord[6:0]};

// 生成传输bit流
wire signal;
GenSignal gensignal(.rst(rst), .clk_serial_bits(clk_serial_bits), .enable(send_word_enable), .word(hammingEncodeWord), .signal(signal));

// fsk编码
wire fsk_signal;
FSKEncode fskEncode(.clk_f0(clk_f0), .clk_f1(clk_f1), .din(signal), .dout(fsk_signal));

// 模拟信道
wire fsk_rev_signal;
assign fsk_rev_signal = fsk_signal;

// fsk解码
wire fsk_decode_signal;
FSKDecode fskDecode(.rst(rst), .clk(clk), .clk_serial_bits(clk_serial_bits), .din(fsk_rev_signal), .dout(fsk_decode_signal));

// 通过传输bit流生成Hamming编码

wire [11:0] hamming_rev_word;
wire rev_enable;
 DecodeSignal decodesignal(.rst(rst), .clk_serial_bits(clk_serial_bits), .signal(fsk_decode_signal), .rev_word(hamming_rev_word), .enable(rev_enable));

reg [11:0] hamming_rev_word_save;
always @(negedge rev_enable or negedge rst) begin
  if (~rst) begin
    hamming_rev_word_save <= 0;
  end
  else begin
    hamming_rev_word_save <= hamming_rev_word;
  end
end



// Hamming解码
wire [7:0] hammingDecodeWord;
HammingDecode hammingdecode(.inputBits(hamming_rev_word_save), .outputBits(hammingDecodeWord));

// PCM解码
//assign output_light = hammingDecodeWord;
PCMdemo pcmDemo(.dataouttopcm(hammingDecodeWord), .dataout(output_light));

// Test

// assign output_light = {clk_sample, clk_serial_bits, clk_f0, clk_f1, send_word_enable, rev_enable, signal ,fsk_decode_signal};
endmodule 