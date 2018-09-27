`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/05/30 18:56:48
// Design Name: 
// Module Name: Regfile
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
`include "defines.v"

module Regfile(
        input wire clk,
        input wire rst,
        input wire we,
        input wire[`RegAddrBus] waddr,
        input wire[`RegBus] wdata,
        input wire[`RegBus] pc,
        output reg[`RegBus] wdata_o,
        output reg[`RegAddrBus] waddr_o,
        output reg[3:0] we_o,
        output reg[`RegBus] pc_o,
        
        input wire re1,
        input wire[`RegAddrBus] raddr1,
        output reg[`RegBus] rdata1,
        
        input wire re2,
        input wire[`RegAddrBus] raddr2,
        output reg[`RegBus] rdata2
    );
    
    reg[`RegBus] regs[0:`RegNum-1];
    initial begin
        regs[0]<=32'h0;
    end
    always@(posedge clk) begin
        if(rst==`RstDisable) begin
            if((we==`WriteEnable)&&(waddr!=`RegNumLog2'H0))begin
                regs[waddr]<=wdata;
                wdata_o<=wdata;
                waddr_o<=waddr;
                we_o<=4'b1111;
                pc_o<=pc;
            end
            else begin
                we_o<=4'b0000;
            end
        end
    end
    
    
    always@(*)begin
        if(rst==`RstEnable) begin
            rdata1<=`ZeroWord;
        end else if(raddr1==`RegNumLog2'h0) begin
            rdata1<=`ZeroWord;
        end else if((raddr1==waddr)&&(we==`WriteEnable)&&(re1==`ReadEnable)) begin
            rdata1<=wdata;
        end else if(re1==`ReadEnable) begin
            rdata1<=regs[raddr1];
        end else begin
            rdata1<=`ZeroWord;   
        end
    end
    
        always@(*)begin
        if(rst==`RstEnable) begin
            rdata2<=`ZeroWord;
        end else if(raddr2==`RegNumLog2'h0) begin
            rdata2<=`ZeroWord;
        end else if((raddr2==waddr)&&(we==`WriteEnable)&&(re2==`ReadEnable)) begin
            rdata2<=wdata;
        end else if(re2==`ReadEnable) begin
            rdata2<=regs[raddr2];
        end else begin
            rdata2<=`ZeroWord;   
        end
    end
endmodule
