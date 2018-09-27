`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/05/29 15:35:27
// Design Name: 
// Module Name: ex_mem
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

module ex_mem(
    input wire clk,
    input wire rst,
    input wire[`RegAddrBus] ex_wd,
    input wire ex_wreg,
    input wire[`RegBus] ex_wdata,
    input wire[`RegBus] ex_hi,
    input wire[`RegBus] ex_lo,
    input wire          ex_whilo,
    input wire[5:0]     stall,
    input wire[`DoubleRegBus]   hilo_i,
    input wire[1:0]     cnt_i,
    input wire[`RegBus] reg2_i,
    input wire[`AluOpBus]   aluop_i,
    input wire             ex_cp0_reg_we,
    input wire[4:0]        ex_cp0_reg_write_addr,
    input wire[`RegBus]    ex_cp0_reg_data,
    input wire[31:0]     ex_excepttype,
    input wire           ex_is_in_delayslot,
    input wire[`RegBus]  ex_current_inst_address,
    input wire           flush,
    input wire          LLbit_i,
    input wire          wb_LLbit_we_i,
    input wire          wb_LLbit_value_i,
    input wire[`RegBus]     mem_addr_i,
    input wire[31:0]    excepttype_i,
    
    output wire        mem_we_o,
    output reg[3:0]     mem_sel_o,
    output reg[3:0]     mem_sel_ro,
    output reg[`RegBus] mem_data_o,
    output reg         mem_ce_o,    
    
    output reg[31:0]     mem_excepttype,
    output reg           mem_is_in_delayslot,
    output reg[`RegBus]  mem_current_inst_address,
    output reg           mem_cp0_reg_we,
    output reg[4:0]      mem_cp0_reg_write_addr,
    output reg[`RegBus]  mem_cp0_reg_data,
    output reg[`RegAddrBus] mem_wd,
    output reg          mem_wreg,
    output reg[`RegBus] mem_wdata,
    output reg[`RegBus] mem_hi,
    output reg[`RegBus] mem_lo,
    output reg          mem_whilo,
    output reg[`DoubleRegBus]   hilo_o,
    output reg[1:0]         cnt_o,
    output reg[31:0]        mem_aluop,
    output reg[`RegBus]     mem_reg2,
    output reg[`RegBus]     mem_addr_o,
    output reg[`RegBus]     mem_addr_out,
    output reg              l_addr_except,
    output reg              s_addr_except
    );
    reg LLbit;
    reg mem_we;
    wire[`RegBus] zero32;
    assign zero32=`ZeroWord;
    always@(*)begin
        if(rst==`RstEnable) begin
            LLbit<=1'b0;
        end else begin
            if(wb_LLbit_we_i==1'b1)begin
                LLbit<=wb_LLbit_value_i;
            end else begin
                LLbit<=LLbit_i;
            end
        end
    end  
    

    

    
    always @ (*) begin
        if(rst==`RstEnable) begin
            mem_addr_o<=`ZeroWord;
            mem_ce_o<=`ChipDisable;
            mem_sel_o<=4'hf;
            mem_sel_ro<=4'b0000;
            mem_data_o<=`ZeroWord;
            l_addr_except<=1'b0;
            s_addr_except<=1'b0;
        end else begin
            mem_addr_o<=`ZeroWord;
            mem_ce_o<=`ChipEnable;
            mem_sel_o<=4'h0;
            mem_sel_ro<=4'b0000;
            mem_data_o<=`ZeroWord;
            l_addr_except<=1'b0;
            s_addr_except<=1'b0;            
            case(aluop_i) 
                `EXE_LL_OP:begin
                    mem_addr_o<=mem_addr_i;
                    mem_ce_o<=`ChipEnable;
                    mem_sel_ro<=4'b1111;
                    mem_sel_o<=4'b0000;
                end
                `EXE_SC_OP:begin
                    if(LLbit==1'b1)begin
                        mem_data_o<=reg2_i;
                        mem_addr_o<=mem_addr_i;
                        mem_ce_o<=`ChipEnable;
                        mem_sel_o<=4'b1111;
                    end
                end
                `EXE_LB_OP:begin
                    mem_addr_o<=mem_addr_i;
                    mem_ce_o<=`ChipEnable;
                    mem_sel_o<=4'b0000;
                    case(mem_addr_i[1:0])
                        2'b00:begin
                            mem_sel_o<=4'b1110;
                        end
                        2'b01:begin
                            mem_sel_o<=4'b1101;
                        end
                        2'b10:begin
                            mem_sel_o<=4'b1011;
                        end   
                        2'b11:begin
                            mem_sel_o<=4'b0111;
                        end                                                                   
                    endcase                 
                end
                `EXE_LBU_OP:begin
                    mem_addr_o<=mem_addr_i;
                    mem_ce_o<=`ChipEnable;
                    mem_sel_o<=4'b0000;
                    case(mem_addr_i[1:0])
                        2'b00:begin
                            mem_sel_o<=4'b1110;
                        end
                        2'b01:begin
                            mem_sel_o<=4'b1101;
                        end
                        2'b10:begin
                            mem_sel_o<=4'b1011;
                        end   
                        2'b11:begin
                            mem_sel_o<=4'b0111;
                        end   
                        default:begin
                        end                                                                  
                    endcase//mem_addr_i
                end
                `EXE_LH_OP:begin
                    mem_addr_o<=mem_addr_i;
                    mem_ce_o<=`ChipEnable;
                    mem_sel_o<=4'b0000;
                    case(mem_addr_i[1:0])
                        2'b00:begin
                            mem_sel_o<=4'b1100;
                        end
                        2'b10:begin
                            mem_sel_o<=4'b0011;
                        end      
                        default:begin
                        l_addr_except<=1'b1;
                        end                                                                  
                    endcase                    
                end
                `EXE_LHU_OP:begin
                    mem_addr_o<=mem_addr_i;
                    mem_ce_o<=`ChipEnable;
                    mem_sel_o<=4'b0000;
                    case(mem_addr_i[1:0])
                        2'b00:begin
                            mem_sel_ro<=4'b1100;
                        end
                        2'b10:begin
                            mem_sel_ro<=4'b0011;
                        end      
                        default:begin
                        l_addr_except<=1'b1;
                        end                                                                  
                    endcase                    
                end 
                `EXE_LW_OP:begin
                    mem_addr_o<=mem_addr_i;
                    mem_sel_ro<=4'b1111;
                    mem_sel_o<=4'b0000;
                    mem_ce_o<=`ChipEnable;   
                    if(mem_addr_i[1:0]!=2'b00)begin
                        l_addr_except<=1'b1;
                    end
                 end   
                 `EXE_LWL_OP:begin
                    mem_addr_o<={mem_addr_i[31:2],2'b00};
                    mem_sel_o<=4'b0000;
                    mem_ce_o<=`ChipEnable;
                 end   
                 `EXE_LWR_OP:begin
                    mem_addr_o<={mem_addr_i[31:2],2'b00};
                    mem_sel_o<=4'b0000;
                    mem_ce_o<=`ChipEnable;                
                 end   
                `EXE_SB_OP:begin
                    mem_addr_o<=mem_addr_i;
                    mem_data_o<={reg2_i[7:0],reg2_i[7:0],reg2_i[7:0],reg2_i[7:0]};
                    mem_ce_o<=`ChipEnable;
                 case(mem_addr_i[1:0])
                    2'b11: begin
                        mem_sel_o<=4'b1000;
                     end
                     2'b10:begin
                         mem_sel_o<=4'b0100;
                     end
                     2'b01:begin
                         mem_sel_o<=4'b0010;
                     end
                     2'b00:begin
                        mem_sel_o<=4'b0001;
                     end
                     default:begin
                        mem_sel_o<=4'b0000;
                     end
                 endcase                 
                 end
                 `EXE_SH_OP:begin
                 mem_addr_o<=mem_addr_i;
                 mem_data_o<={reg2_i[15:0],reg2_i[15:0]};
                 mem_ce_o<=`ChipEnable;
                 case(mem_addr_i[1:0])
                    2'b00: begin
                        mem_sel_o<=4'b0011;
                     end
                     2'b10:begin
                         mem_sel_o<=4'b1100;
                     end
                     default:begin
                        mem_sel_o<=4'b0000;
                        s_addr_except<=1'b1;
                     end
                 endcase                 
                 end   
                 `EXE_SW_OP:begin
                    mem_addr_o<=mem_addr_i;
                    mem_data_o<=reg2_i;
                    if(mem_addr_i[1:0]==2'b00)begin
                        mem_sel_o<=4'b1111;
                    end else begin
                        s_addr_except<=1'b1;
                    end
                    mem_ce_o<=`ChipEnable;
                 end  
                 `EXE_SWL_OP:begin
                    mem_addr_o<={mem_addr_i[31:2],2'b00};
                    mem_ce_o<=`ChipEnable;
                 case(mem_addr_i[1:0])
                    2'b00: begin
                        mem_sel_o<=4'b1111;
                        mem_data_o<=reg2_i;
                     end
                    2'b01: begin
                         mem_sel_o<=4'b0111;
                         mem_data_o<={zero32[7:0],reg2_i[31:8]};
                      end                     
                     2'b10:begin
                         mem_sel_o<=4'b0011;
                         mem_data_o<={zero32[15:0],reg2_i[31:16]};
                     end
                     2'b11:begin
                         mem_sel_o<=4'b0001;
                         mem_data_o<={zero32[23:0],reg2_i[31:24]};
                     end                    
                     default:begin
                        mem_sel_o<=4'b0000;
                     end
                 endcase                 
                 end
                 `EXE_SWR_OP:begin
                    mem_addr_o<={mem_addr_i[31:2],2'b00};
                    mem_ce_o<=`ChipEnable;
                 case(mem_addr_i[1:0])
                    2'b00: begin
                        mem_sel_o<=4'b1000;
                        mem_data_o<={reg2_i[7:0],zero32[23:0]};
                     end
                    2'b01: begin
                         mem_sel_o<=4'b1100;
                         mem_data_o<={reg2_i[15:0],zero32[15:0]};
                      end                     
                     2'b10:begin
                        mem_sel_o<=4'b1110;
                        mem_data_o<={reg2_i[23:0],zero32[7:0]};
                     end
                     2'b11:begin
                        mem_sel_o<=4'b1111;
                        mem_data_o<=reg2_i;
                     end                    
                     default:begin
                        mem_sel_o<=4'b0000;
                     end
                 endcase                 
                 end
 

  
                 default:begin
                 end                                                                    
            endcase //aluop_i
            if(mem_addr_i>32'h9fffffff&&mem_addr_i<32'hc0000000)begin
                mem_addr_o<=mem_addr_i-32'ha0000000;
            end 
             if(mem_addr_i>32'h7fffffff&&mem_addr_i<32'ha0000000)begin
                mem_addr_o<=mem_addr_i-32'h80000000;
            end
            if(|excepttype_i)begin
                mem_sel_o<=4'b0000;
            end
         end
        end
    
    always @(posedge clk)begin
        if(rst==`RstEnable) begin
            mem_wd<=`NOPRegAddr;
            mem_wreg<=`WriteDisable;
            mem_wdata<=`ZeroWord;
            mem_hi<=`ZeroWord;
            mem_lo<=`ZeroWord;
            mem_whilo<=`WriteDisable;
            hilo_o<={`ZeroWord,`ZeroWord};
            cnt_o<=2'b00;
            mem_aluop<=`EXE_NOP_OP;
            //mem_mem_addr<=`ZeroWord;
            mem_reg2<=`ZeroWord;
            mem_cp0_reg_we<=`WriteDisable;
            mem_cp0_reg_write_addr<=5'b00000;
            mem_cp0_reg_data<=`ZeroWord;
            mem_excepttype<=`ZeroWord;
            mem_is_in_delayslot<=`NotInDelaySlot;
            mem_current_inst_address<=`ZeroWord;
            mem_addr_out<=`ZeroWord;
         end else if(flush==1'b1)begin
            mem_wd<=`NOPRegAddr;
            mem_wreg<=`WriteDisable;
            mem_wdata<=`ZeroWord;
            mem_hi<=`ZeroWord;
             mem_lo<=`ZeroWord;
            mem_whilo<=`WriteDisable;
            hilo_o<={`ZeroWord,`ZeroWord};
            cnt_o<=2'b00;
            mem_aluop<=`EXE_NOP_OP;
            //mem_mem_addr<=`ZeroWord;
            mem_reg2<=`ZeroWord;
            mem_cp0_reg_we<=`WriteDisable;
            mem_cp0_reg_write_addr<=5'b00000;
            mem_cp0_reg_data<=`ZeroWord;
            mem_excepttype<=`ZeroWord;
            mem_is_in_delayslot<=`NotInDelaySlot;
            mem_current_inst_address<=`ZeroWord;        
            mem_addr_out<=`ZeroWord;                         
            end else if(stall[3]==`Stop||stall[4]==`Stop)begin
           mem_wd<= `NOPRegAddr;
           mem_wreg<=`WriteDisable;
           mem_wdata<=`ZeroWord;
           mem_hi<= `ZeroWord;
           mem_lo<=`ZeroWord;
           mem_whilo<=`WriteDisable;
           hilo_o<=hilo_i;
           cnt_o<=cnt_i;
           mem_aluop<= `EXE_NOP_OP;
           //mem_mem_addr<=`ZeroWord;
           mem_reg2<=`ZeroWord;
            mem_cp0_reg_we<=`WriteDisable;
           mem_cp0_reg_write_addr<=5'b00000;
           mem_cp0_reg_data<= `ZeroWord; 
           mem_excepttype<=`ZeroWord;
           mem_is_in_delayslot<=`NotInDelaySlot;
           mem_current_inst_address<=`ZeroWord; 
           mem_addr_out<=`ZeroWord;                    
         end else if(stall[3]==`NotStop)begin
            mem_wd <=ex_wd;
            mem_wreg <=ex_wreg;
            mem_wdata <=ex_wdata;
            mem_hi<=ex_hi;
            mem_lo<=ex_lo;
            mem_whilo<=ex_whilo;
            hilo_o<={`ZeroWord,`ZeroWord};
            cnt_o<=2'b00;
            mem_aluop<=aluop_i;
            //mem_mem_addr<=ex_mem_addr;
            mem_reg2<=reg2_i;
            mem_cp0_reg_we<=ex_cp0_reg_we;
            mem_cp0_reg_write_addr<=ex_cp0_reg_write_addr;
            mem_cp0_reg_data<=ex_cp0_reg_data;
            mem_excepttype<=ex_excepttype;
            mem_is_in_delayslot<=ex_is_in_delayslot;
            mem_current_inst_address<=ex_current_inst_address;
            mem_addr_out<=mem_addr_o;
        end else begin
            hilo_o<=hilo_i;
            cnt_o<=cnt_i;
        end
    end
    

    
endmodule
