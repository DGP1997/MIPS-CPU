`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/05/29 15:40:06
// Design Name: 
// Module Name: mem
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

module mem(
    input wire rst,
    input wire[`RegAddrBus] wd_i,
    input wire wreg_i,
    input wire[`RegBus] wdata_i,
    input wire[`RegBus] hi_i,
    input wire[`RegBus] lo_i,
    input wire          whilo_i,
    input wire[`AluOpBus]   aluop_i,
    input wire[`RegBus]     mem_addr_i,
    input wire[`RegBus]     reg2_i,
    input wire[`RegBus]     mem_data_i,
    input wire          LLbit_i,
    input wire          wb_LLbit_we_i,
    input wire          wb_LLbit_value_i,
    input wire          cp0_reg_we_i,
    input wire[4:0]     cp0_reg_write_addr_i,
    input wire[`RegBus] cp0_reg_data_i,
    input wire[31:0]    excepttype_i,
    input wire[31:0]    excepttype_ex_i,
    input wire          is_in_delayslot_i,
    input wire          ex_in_delayslot_i,
    input wire[`RegBus] current_inst_address_i,
    input wire[`RegBus] cp0_status_i,
    input wire[`RegBus] cp0_cause_i,
    input wire[`RegBus] cp0_epc_i,
    input wire          wb_cp0_reg_we,
    input wire[4:0]     wb_cp0_reg_write_addr,
    input wire[`RegBus] wb_cp0_reg_data,
    input wire[3:0]     mem_sel_ri,
    input wire          inst_except_i,
    input wire          l_addr_except_i,
    input wire          s_addr_except_i,
   
    output reg[31:0]    excepttype_o,
    output wire[`RegBus] cp0_epc_o,
    output wire         is_in_delayslot_o,
    output wire[`RegBus] current_inst_address_o,
    output reg  cp0_reg_we_o,
    output reg[4:0]  cp0_reg_write_addr_o,
    output reg[`RegBus] cp0_reg_data_o,
    output reg[`RegAddrBus] wd_o,
    output reg wreg_o,
    output reg[`RegBus] wdata_o,
    output reg[`RegBus] hi_o,
    output reg[`RegBus] lo_o,
    output reg          whilo_o,
    output reg[`RegBus] mem_addr_o,
    output wire        mem_we_o,
    output reg[3:0]     mem_sel_o,
    output reg[`RegBus] mem_data_o,
    output reg         mem_ce_o,
    output reg          LLbit_we_o,
    output reg          LLbit_value_o
    );
    wire[`RegBus] zero32;
    reg mem_we;
    reg LLbit;
    reg[`RegBus] cp0_status;
    reg[`RegBus] cp0_cause;
    reg[`RegBus] cp0_epc;
    reg          l_addr_except;
    reg          s_addr_except;

    
    

    
    assign zero32=`ZeroWord;
    assign is_in_delayslot_o=is_in_delayslot_i;
    assign current_inst_address_o=current_inst_address_i;
    
    
    
    always@(*)begin
        if(rst==`RstEnable)begin
            cp0_status<=`ZeroWord;
            
        end else if((wb_cp0_reg_we==`WriteEnable)&&
                    (wb_cp0_reg_write_addr==`CP0_REG_STATUS))begin
            cp0_status<=wb_cp0_reg_data;
        end else begin
            cp0_status<=cp0_status_i;
        end
    end
    
   always @(*)begin
     if(rst==`RstEnable)begin
        cp0_epc<=`ZeroWord;
     end else if((wb_cp0_reg_we==`WriteEnable)&&(wb_cp0_reg_write_addr==`CP0_REG_EPC))begin
        cp0_epc<=wb_cp0_reg_data;
     end else begin
        cp0_epc<=cp0_epc_i;
     end
   end
   
   assign cp0_epc_o=cp0_epc;
   
   
   always @(*)begin
    if(rst==`RstEnable)begin
        cp0_cause<=`ZeroWord;
    end else if((wb_cp0_reg_we==`WriteEnable)&&(wb_cp0_reg_write_addr)==`CP0_REG_CAUSE)begin
        cp0_cause[9:8]<=wb_cp0_reg_data[9:8];
        cp0_cause[22]<=wb_cp0_reg_data[22];
        cp0_cause[23]<=wb_cp0_reg_data[23];
    end else begin
        cp0_cause<=cp0_cause_i;
    end
            
   end
   
   always@(*)begin
        if(rst==`RstEnable)begin
            excepttype_o<=`ZeroWord;
        end else begin
            excepttype_o<=`ZeroWord;
            if(current_inst_address_i!=`ZeroWord)begin
                if(((cp0_cause[15:8]&(cp0_status[15:8]))!=8'h00)&&(cp0_status[1]==1'b0)&&(cp0_status[0]==1'b1))begin
                    excepttype_o<=32'h00000001;
                end else if(excepttype_i[8]==1'b1)begin
                    excepttype_o<=32'h00000008;
                end else if(excepttype_i[13]==1'b1)begin
                    excepttype_o<=32'h0000009;                                      
                end else if(excepttype_i[9]==1'b1) begin
                    excepttype_o<=32'h0000000a;                 
                end else if(excepttype_i[10]==1'b1)begin
                    excepttype_o<=32'h0000000d;
                end else if(excepttype_i[11]==1'b1)begin
                    excepttype_o<=32'h0000000c;
                end else if(l_addr_except==1'b1)begin
                    excepttype_o<=32'h0000000e;
                end else if(s_addr_except==1'b1)begin
                    excepttype_o<=32'h0000000f;
                end else if(inst_except_i==1'b1)begin
                            excepttype_o<=32'h0000000e; 
                            if(ex_in_delayslot_i==1'b1&&((|excepttype_ex_i==1'b1)||l_addr_except_i==1'b1||s_addr_except_i==1'b1))begin
                                excepttype_o<=32'h0;
                            end                     
                end else if(excepttype_i[12]==1'b1)begin
                    excepttype_o<=32'h00000010;
                end
            end
        end
   end
   
   
   assign mem_we_o=mem_we&(~(|excepttype_o));
   
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
            wd_o<=`NOPRegAddr;
            wreg_o<=`WriteDisable;
            wdata_o<=`ZeroWord;
            hi_o<=`ZeroWord;
            lo_o<=`ZeroWord;
            whilo_o<=`WriteDisable;
            mem_addr_o<=`ZeroWord;
            LLbit_we_o<=1'b0;
            LLbit_value_o<=1'b0;
            cp0_reg_we_o<=`WriteDisable;
            cp0_reg_write_addr_o<=5'b00000;
            cp0_reg_data_o<=`ZeroWord;
            l_addr_except<=1'b0;
            s_addr_except<=1'b0;
        end else begin
            wd_o<=wd_i;
            wreg_o<=wreg_i;
            wdata_o<=wdata_i;
            hi_o<=hi_i;
            lo_o<=lo_i;
            whilo_o<=whilo_i;
            mem_addr_o<=mem_addr_i;
            LLbit_we_o<=1'b0;
            LLbit_value_o<=1'b0;
            cp0_reg_we_o<=cp0_reg_we_i;
            cp0_reg_write_addr_o<=cp0_reg_write_addr_i;
            cp0_reg_data_o<=cp0_reg_data_i;
            l_addr_except<=1'b0;
            s_addr_except<=1'b0;
            case(aluop_i) 
                `EXE_LL_OP:begin
                    wdata_o<=mem_data_i;
                    LLbit_we_o<=1'b1;
                    LLbit_value_o<=1'b1;
                end
                `EXE_SC_OP:begin
                    if(LLbit==1'b1)begin
                        LLbit_we_o<=1'b1;
                        LLbit_value_o<=1'b0;
                        wdata_o<=32'b1;
                    end else begin
                        wdata_o<=32'b0;
                    end
                end
                `EXE_LB_OP:begin
                    case(mem_addr_o[1:0])
                        2'b11:begin
                            wdata_o<={{24{mem_data_i[31]}},mem_data_i[31:24]};
                        end
                        2'b10:begin
                            wdata_o<={{24{mem_data_i[23]}},mem_data_i[23:16]};
                        end
                        2'b01:begin
                            wdata_o<={{24{mem_data_i[15]}},mem_data_i[15:8]};
                        end   
                        2'b00:begin
                            wdata_o<={{24{mem_data_i[7]}},mem_data_i[7:0]};
                        end   
                        default:begin
                            wdata_o<=`ZeroWord;
                        end                                                                  
                    endcase//mem_addr_i
                end
                `EXE_LBU_OP:begin
                    case(mem_addr_o[1:0])
                        2'b11:begin
                            wdata_o<={{24{1'b0}},mem_data_i[31:24]};

                        end
                        2'b10:begin
                            wdata_o<={{24{1'b0}},mem_data_i[23:16]};

                        end
                        2'b01:begin
                            wdata_o<={{24{1'b0}},mem_data_i[15:8]};

                        end   
                        2'b00:begin
                            wdata_o<={{24{1'b0}},mem_data_i[7:0]};

                        end   
                        default:begin
                            wdata_o<=`ZeroWord;
                        end                                                                  
                    endcase//mem_addr_i
                end
                `EXE_LH_OP:begin

                    case(mem_addr_o[1:0])
                        2'b10:begin
                            wdata_o<={{16{mem_data_i[31]}},mem_data_i[31:16]};
                        end
                        2'b00:begin
                            wdata_o<={{16{mem_data_i[15]}},mem_data_i[15:0]};
                        end      
                        default:begin
                            wdata_o<=`ZeroWord;
                            l_addr_except<=1'b1;
                        end                                                                  
                    endcase                    
                end
                `EXE_LHU_OP:begin
                    case(mem_addr_o[1:0])
                        2'b10:begin
                            wdata_o<={{16{1'B0}},mem_data_i[31:16]};
                        end
                        2'b00:begin
                            wdata_o<={{16{1'B0}},mem_data_i[15:0]};
                        end      
                        default:begin
                            wdata_o<=`ZeroWord;
                            l_addr_except<=1'b1;
                        end                                                                  
                    endcase                    
                end 
                `EXE_LW_OP:begin
                    wdata_o<=mem_data_i;  
                    if(mem_addr_o[1:0]!=2'b00)begin
                        l_addr_except<=1'b1;
                    end
                 end   
                 `EXE_LWL_OP:begin
                    case(mem_addr_o[1:0])
                       2'b00: begin
                           wdata_o<=mem_data_i[31:0];
                        end
                        2'b01:begin
                            wdata_o<={mem_data_i[23:0],reg2_i[7:0]};
                        end
                        2'b10:begin
                            wdata_o<={mem_data_i[15:0],reg2_i[15:0]};
                        end
                        2'b11:begin
                            wdata_o<={mem_data_i[7:0],reg2_i[23:0]};
                        end
                        default:begin
                            wdata_o<=`ZeroWord;
                        end
                    endcase
                 end   
                 `EXE_LWR_OP:begin
                 case(mem_addr_o[1:0])
                    2'b00: begin
                        wdata_o<={reg2_i[31:8],mem_data_i[31:24]};
                     end
                     2'b01:begin
                         wdata_o<={reg2_i[31:16],mem_data_i[31:16]};
                     end
                     2'b10:begin
                         wdata_o<={reg2_i[31:16],mem_data_i[31:16]};
                     end
                     2'b11:begin
                         wdata_o<=`ZeroWord;
                     end
                     default:begin
                         wdata_o<=`ZeroWord;
                     end
                 endcase                 
                 end    
                 `EXE_SH_OP:begin
                    if(mem_addr_o[0]!=1'b0)begin
                        s_addr_except<=1'b1;
                    end
                 end                         
                 `EXE_SW_OP:begin
                    if(mem_addr_o[1:0]!=2'b00)begin
                        s_addr_except<=1'b1;
                    end
                 end                                         
            endcase //aluop_i
         end
     end
endmodule

