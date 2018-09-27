`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/06/21 08:40:01
// Design Name: 
// Module Name: ctrl
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`include  "defines.v"

module ctrl(
    input wire rst,
    input wire stallreq_from_id,
    input wire stallreq_from_ex,
    input wire stallreq_for_div,
    input wire[31:0] excepttype_i,
    input wire[`RegBus] cp0_epc_i,
    output reg[`RegBus] new_pc,
    output reg  flush,
    output reg[5:0] stall
    );
    
    reg [1:0] counter1;
    reg [1:0] counter2;
    
    
    always@(*) begin
        if(rst==`RstEnable) begin
            stall<=6'b000000;
            flush<=1'b0;
            new_pc<=`ZeroWord;
        end else if(excepttype_i!=`ZeroWord)begin
            flush<=1'b1;
            stall<=6'b000000;
            case(excepttype_i)
                32'h00000001:begin
                    new_pc<=32'hbfc00380;
                end
                32'h00000008:begin
                    new_pc<=32'hbfc00380;
                end
                32'h00000009:begin
                    new_pc<=32'hbfc00380;
                end
                32'h0000000a:begin
                    new_pc<=32'hbfc00380;
                end
                32'h0000000d:begin
                    new_pc<=32'hbfc00380;
                end
                32'h0000000c:begin
                    new_pc<=32'hbfc00380;
                end
                32'h0000000e:begin
                    new_pc<=32'hbfc00380;
                end
                32'h0000000f:begin
                    new_pc<=32'hbfc00380;
                end
                32'h00000010:begin
                    new_pc<=cp0_epc_i;
                end
                default:begin
                end
            endcase
        end else if(stallreq_for_div==1'b1)begin
            stall<=6'b00110;
            flush<=1'b0;
        end else if(stallreq_from_ex==`Stop) begin
            counter1<=1'b1;
            stall<=6'b011111;
            flush<=1'b0;
        end else if(stallreq_from_id==`Stop) begin
            counter2<=1'b1;
            stall<=6'b001111;
            flush<=1'b0;
        end else begin
            counter1<=1'b0;
            counter2<=1'b0;
            stall<=6'b000000;
            flush<=1'b0;
            new_pc<=`ZeroWord;
        end
    end
endmodule
