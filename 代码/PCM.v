module PCMmodu(datain,dataoutput);
input wire [7:0] datain;
output reg [7:0] dataoutput;

wire [12:0] datapcm;
assign datapcm = {datain[7:0], 5'b0};

always@(*)
begin
    dataoutput[7]=datapcm[12];
    if (datapcm[11:5]==7'b0)
        begin 
            dataoutput[6:4]=3'b000; 
            dataoutput[3:0]=datapcm[4:1];
        end
    else if (datapcm[11:5]==7'b1)
        begin
            dataoutput[6:4]=3'b001;
            dataoutput[3:0]=datapcm[4:1];
        end
    else if (datapcm[11:6]==6'b1)
        begin
            dataoutput[6:4]=3'b010; 
            dataoutput[3:0]=datapcm[5:2];
        end
    else if (datapcm[11:7]==5'b1)
        begin
            dataoutput[6:4]=3'b011;
            dataoutput[3:0]=datapcm[6:3];
        end
    else if (datapcm[11:8]==4'b1)
        begin
            dataoutput[6:4]=3'b100;
            dataoutput[3:0]=datapcm[7:4];
        end
    else if (datapcm[11:9]==3'b1)
        begin
            dataoutput[6:4]=3'b101;
            dataoutput[3:0]=datapcm[8:5];
        end
    else if (datapcm[11:10]==2'b1)
        begin
            dataoutput[6:4]=3'b110;
            dataoutput[3:0]=datapcm[9:6];
        end
    else if (datapcm[11]==1'b1)
        begin
            dataoutput[6:4]=3'b111;
            dataoutput[3:0]=datapcm[10:7];
        end
end

endmodule


module PCMdemo(dataouttopcm, dataout);
input [7:0] dataouttopcm;
reg [12:0] linearoutput;
output reg [7:0] dataout;

always@(*)
begin
    linearoutput[12] =dataouttopcm[7];
    case (dataouttopcm[6:4])
        3'b000: 
        begin
            linearoutput[11:5] =7'b0;
            linearoutput[4:1] =dataouttopcm[3:0];
            linearoutput[0] =1'b1;
        end
        3'b001: 
        begin
            linearoutput[11:5] =7'b1;
            linearoutput[4:1] =dataouttopcm[3:0];
            linearoutput[0] =1'b1;
        end
        3'b010:
        begin
            linearoutput[11:6]=6'b1;
            linearoutput[5:2]=dataouttopcm[3:0];
            linearoutput[1:0]=2'b10;
        end    
        3'b011:
        begin
            linearoutput[11:7]=5'b1;
            linearoutput[6:3]=dataouttopcm[3:0];
            linearoutput[2:0]=3'b100;
        end
        3'b100:
        begin
            linearoutput[11:8]=4'b1;
            linearoutput[7:4]=dataouttopcm[3:0];
            linearoutput[3:0]=4'b1000;
        end
        3'b101:
        begin
            linearoutput[11:9]=3'b1;
            linearoutput[8:5]=dataouttopcm[3:0];
            linearoutput[4:0]=5'b10000;
        end
        3'b110:
        begin
            linearoutput[11:10]=2'b1;
            linearoutput[9:6]=dataouttopcm[3:0];
            linearoutput[5:0]=6'b100000;
        end
        3'b111:
        begin
            linearoutput[11] = 1'b1;
            linearoutput[10:7]=dataouttopcm[3:0];
            linearoutput[6:0]=7'b1000000;
        end
    endcase
    dataout[7:0]=linearoutput[12:5];
end

endmodule