`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/05/28 20:31:53
// Design Name: 
// Module Name: if_id
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


module if_id(
    input wire rst,
    input wire clk,
    input wire[`InstAddrBus] if_pc,
    input wire[`InstBus] if_inst,
    input wire[`RegBus] excepttype_i,
    input wire[5:0] stall,
    input wire  flush,
    input wire bflag,
    input wire div_ready_org,
    input wire div_ready,
    input wire[`InstAddrBus] branch_address_i,
    output reg[`InstAddrBus] id_pc,
    output reg[`InstBus] id_inst
    );

    reg [`InstAddrBus] branch_address=`ZeroWord;
    reg[`RegBus] excepttype;
    reg isjump;
    reg stall0;
    
    always @(posedge clk)begin
        if(rst==`RstEnable||excepttype!=32'h0)begin
            isjump<=1'b0;
        end else if(bflag==1'b1)begin
            isjump<=1'b1;
            branch_address<=branch_address_i;
        end  else begin
            isjump<=1'b0;
        end
        /*if(!stall[0]&&stall0)begin
            isjump<=1'b0;
         end
        if(isjump==1'b1&&branch_address==if_pc)begin
             isjump<=1'b0;
             branch_address<=`ZeroWord;
         end*/
    end
    

    
    always @(posedge clk)begin
        excepttype<=excepttype_i;
        stall0<=stall[0];
    end


    always @(posedge clk)begin
       if(rst==`RstEnable) begin
           id_pc<=`ZeroWord;
           id_inst<=`ZeroWord;
       end else if(flush==1'b1||div_ready==1'b1||div_ready_org==1'b1)begin
            id_pc<=`ZeroWord;
            id_inst<=`ZeroWord; 
       end else if(stall[1]==`Stop||stall[2]==`Stop||isjump==1'b1||(excepttype!=32'h0))begin
            id_pc<=`ZeroWord;
            id_inst<=`ZeroWord;        
       end else if(!stall[0]&&stall0)begin
            id_pc<=`ZeroWord;
            id_inst<=`ZeroWord; 
       end else if(stall[1]==`NotStop&&isjump==1'b0) begin
           id_pc<=if_pc;
           id_inst<=if_inst; 
       end
    end
endmodule
