`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/05/31 08:11:17
// Design Name: 
// Module Name: mips
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

module mycpu_top(
    input wire clk,
    input wire resetn,
    input wire[5:0]      int,
   
    input wire[`RegBus]     data_sram_rdata,
    output wire[`RegBus]    data_sram_addr,
    output wire[`RegBus]    data_sram_wdata,
    output wire[3:0]        data_sram_wen,
    output wire[3:0]        data_sram_en,
    
    input  wire[`RegBus]    inst_sram_rdata,
    output wire[`RegBus]    inst_sram_addr,
    output wire             inst_sram_en,
    output wire[31:0]       inst_sram_wdata,
    output wire[3:0]        inst_sram_wen,
    
    output wire            timer_int_o,
    output [31:0]           debug_wb_pc,
    output [3:0]            debug_wb_rf_wen,
    output [4:0]            debug_wb_rf_wnum,
    output [31:0]           debug_wb_rf_wdata
    );

    assign inst_sram_wen=4'h0;
    assign inst_sram_wdata=32'h0;
    
    wire rst;
    wire ram_ce_o;
    wire ram_we_o;
    wire[`InstAddrBus]  pc;
    wire[`InstAddrBus]  id_pc_i;
    wire[`InstBus]  id_inst_i;
    
    wire[`AluOpBus] id_aluop_o;
    wire[`AluSelBus] id_alusel_o;
    wire[`RegBus] id_reg1_o;
    wire[`RegBus] id_reg2_o;
    wire id_wreg_o;
    wire[`RegAddrBus]  id_wd_o;
    
    wire[`AluOpBus] ex_aluop_i;
    wire[`AluSelBus] ex_alusel_i;
    wire[`RegBus] ex_reg1_i;
    wire[`RegBus] ex_reg2_i;
    wire ex_wreg_i;
    wire[`RegAddrBus] ex_wd_i;
    
    wire ex_wreg_o;
    wire[`RegAddrBus] ex_wd_o;
    wire[`RegBus] ex_wdata_o;
    
    wire mem_wreg_i;
    wire[`RegAddrBus] mem_wd_i;
    wire[`RegBus] mem_wdata_i;
  
    wire em_wreg_o;
    wire[`RegAddrBus] em_wd_o;
    wire[`RegBus] em_wdata_o;   
    
    wire mem_wreg_o;
    wire[`RegAddrBus] mem_wd_o;
    wire[`RegBus] mem_wdata_o;
    
    wire wb_wreg_i;
    wire[`RegAddrBus] wb_wd_i;
    wire[`RegBus] wb_wdata_i;
    
    wire reg1_read;
    wire reg2_read;
    wire[`RegBus] reg1_data;
    wire[`RegBus] reg2_data;
    wire[`RegAddrBus] reg1_addr;
    wire[`RegAddrBus] reg2_addr;
    
    wire[`RegBus]         wb_hi_o;
    wire[`RegBus]         wb_lo_o;
    wire                  wb_whilo_o;
    wire[`RegBus]         reg_hi_o;
    wire[`RegBus]         reg_lo_o;
    wire[`RegBus]         ex_hi_o;
    wire[`RegBus]         ex_lo_o;
    wire                  ex_whilo_o;
    wire[`RegBus]         em_hi_o;
    wire[`RegBus]         em_lo_o;
    wire                  em_whilo_o;
    wire[`RegBus]         mem_hi_o;
    wire[`RegBus]         mem_lo_o;
    wire                  mem_whilo_o;
    wire[`RegBus]         mw_hi_o;
    wire[`RegBus]         mw_lo_o;
    wire                  mw_whilo_o;
    wire[`RegBus]         hl_hi_o;
    wire[`RegBus]         hl_lo_o;
    wire                  hl_whilo_o;
    
    wire[5:0]             stall_out;
    
    wire                  stallreq_from_id_i;
    wire                  stallreq_from_ex_i;
    
    wire[1:0]             cnt_ex_o;
    wire[`DoubleRegBus]   hilo_temp_ex_o;
    
    wire[1:0]             cnt_em_o;
    wire[`DoubleRegBus]   hilo_em_o;
    
    wire signed_div;
    wire[31:0] div_opdata1;
    wire[31:0] div_opdata2;
    wire div_start;
    
    wire[63:0] div_result;
    wire div_ready;
    wire div_ready_org;
    
    wire[`RegBus]         branch_target_address_ido;
    wire                  branch_flag_ido;
    wire                  next_inst_in_delayslot_ido;
    wire[`RegBus]         link_addr_ido;
    wire                  is_in_delayslot_ido;
    wire[`RegBus]         ex_link_address_deo;
    wire                  ex_is_in_delayslot_deo;
    wire                  is_in_delayslot_deo;
    
    wire[`RegBus]         inst_id_o;
    wire[`RegBus]         inst_de_o;
    wire[`AluOpBus]      aluop_ex_o;
    wire[`RegBus]        mem_addr_ex_o;
    wire[`RegBus]        reg2_ex_o;
    wire[`AluOpBus]      aluop_em_o;
    wire[`RegBus]        mem_addr_em_o;
    wire[`RegBus]       reg2_em_o;
    wire                LLbit_we_mo;
    wire                LLbit_value_mo;
    wire                LLbit_we_mwo;
    wire                LLbit_value_mwo;
    wire                LLbit_Lbo;
    wire[4:0]             cp0_regraddr_exo;
    wire                  cp0_regwe_exo;
    wire[4:0]             cp0_regwaddr_exo;
    wire[`RegBus]         cp0_rd_exo;
    wire                  cp0_regwe_emo;
    wire[4:0]             cp0_regwaddr_emo;
    wire[`RegBus]         cp0_rd_emo;    
    wire                  cp0_regwe_mo;
    wire[4:0]             cp0_regwaddr_mo;
    wire[`RegBus]         cp0_rd_mo; 
    wire                  cp0_regwe_mwo;
    wire[4:0]             cp0_regwaddr_mwo;
    wire[`RegBus]         cp0_rd_mwo;
    wire[`RegBus]         cp0_data_co;
    wire[`RegBus]          status_cpo;
    wire[`RegBus]          cause_cpo;
    wire[`RegBus]          epc_cpo;
    wire                  flush_mwo;
    wire[31:0]           excepttype_ido;
    wire[`RegBus]        current_inst_address_ido;
    wire[31:0]           excepttype_deo;
    wire[`RegBus]        current_inst_address_deo;
    wire[31:0]           excepttype_exo;
    wire                 is_in_delayslot_exo;
    wire[`RegBus]        current_inst_address_exo;
    wire[31:0]           excepttype_emo;
    wire                 is_in_delayslot_emo;
    wire[`RegBus]        current_inst_address_emo;
    wire[31:0]           excepttype_mo;
    wire                 is_in_delayslot_mo;
    wire[`RegBus]        current_inst_address_mo;    
    wire[`RegBus]        cp0_epc_mo;
    wire[`RegBus]         new_pc_co;
    wire                  flush_co;
    wire[`RegBus]         reg_pc;
    wire[`RegBus]         pre_pc;
    wire                  isjump;
    wire                  stall_for_div;
    wire[`RegBus]         sram_addr;
    wire[`RegBus]         mem_addr_out;
    wire                  inst_except;
    wire                  break_except_o;
    wire                  l_addr_except;
    wire                  s_addr_except;
    
    
    assign rst=resetn;
    assign data_sram_en={4{ram_ce_o}};
    assign data_sram_addr=sram_addr;
    
    
    pc_reg pc_reg0(
            .clk(clk),  .rst(rst),  .pc(pc),  .ce(inst_sram_en),.flush(flush_co),.new_pc(new_pc_co),.div_ready(div_ready),
            .branch_target_address_i(branch_target_address_ido),.branch_flag_i(branch_flag_ido),
            .stall(stall_out),.pre_pc(pre_pc),.div_ready_org(div_ready_org),.except_o(inst_except)
    );
    
    assign inst_sram_addr=pc;
    if_id if_id0(
        .clk(clk), .rst(rst) ,.if_pc(pre_pc) ,.flush(flush_co),.bflag(branch_flag_ido),.branch_address_i(branch_target_address_ido),
        .if_inst(inst_sram_rdata), .id_pc(id_pc_i),.excepttype_i(excepttype_mo),.div_ready(div_ready),.div_ready_org(div_ready_org),
        .id_inst(id_inst_i),.stall(stall_out)
    );
    
    id id0(
        .clk(clk),
        .rst(rst), .pc_i(id_pc_i), .inst_i(id_inst_i),
        .reg1_data_i(reg1_data), .reg2_data_i(reg2_data),
        .ex_wdata_i(ex_wdata_o),.ex_wd_i(ex_wd_o),
        .ex_wreg_i(ex_wreg_o),.excepttype_o(excepttype_ido),
        .mem_wdata_i(mem_wdata_o),.current_inst_address_o(current_inst_address_ido),
        .mem_wd_i(mem_wd_i),.mem_wreg_i(mem_wreg_o),
        .reg1_read_o(reg1_read), .reg2_read_o(reg2_read),
        .reg1_addr_o(reg1_addr), .reg2_addr_o(reg2_addr),
        .is_in_delayslot_i(is_in_delayslot_deo),.ex_aluop_i(aluop_ex_o),
        
        .aluop_o(id_aluop_o), .alusel_o(id_alusel_o),
        .reg1_o(id_reg1_o),   .reg2_o(id_reg2_o),
        .wd_o(id_wd_o),   .wreg_o(id_wreg_o), .stallreq(stallreq_from_id_i),
        .is_in_delayslot_o(is_in_delayslot_ido),.link_addr_o(link_addr_ido),
        .next_inst_in_delayslot_o(next_inst_in_delayslot_ido),.branch_target_address_o(branch_target_address_ido),
        .branch_flag_o(branch_flag_ido),.inst_o(inst_id_o)
    );
    
    Regfile regfile0(
        .clk(clk), .rst(rst),
        .we(wb_wreg_i), .waddr(wb_wd_i),
        .wdata(wb_wdata_i), .re1(reg1_read),
        .raddr1(reg1_addr), .rdata1(reg1_data),
        .re2(reg2_read), .raddr2(reg2_addr),.pc(reg_pc),.pc_o(debug_wb_pc),
        .rdata2(reg2_data),.we_o(debug_wb_rf_wen),.wdata_o(debug_wb_rf_wdata),.waddr_o(debug_wb_rf_wnum)
    );

    id_ex id_ex0(
        .clk(clk), .rst(rst),
        .id_aluop(id_aluop_o), .id_alusel(id_alusel_o),
        .id_reg1(id_reg1_o), .id_reg2(id_reg2_o),.flush(flush_co),
        .id_excepttype(excepttype_ido),.id_current_inst_address(current_inst_address_ido),
        .id_wd(id_wd_o),  .id_wreg(id_wreg_o),.id_inst(inst_id_o),
        .stall(stall_out),.id_is_in_delayslot(is_in_delayslot_ido),
        .id_link_address(link_addr_ido),.next_inst_in_delayslot_i(next_inst_in_delayslot_ido),
        .ex_aluop(ex_aluop_i), .ex_alusel(ex_alusel_i),
        .ex_reg1(ex_reg1_i), .ex_reg2(ex_reg2_i),.ex_excepttype(excepttype_deo),
        .ex_current_inst_address(current_inst_address_deo),
        .ex_wd(ex_wd_i), .ex_wreg(ex_wreg_i),.ex_inst(inst_de_o),
        .is_in_delayslot_o(is_in_delayslot_deo),.ex_link_address(ex_link_address_deo),
        .ex_is_in_delayslot(ex_is_in_delayslot_deo)
    );
    
    ex ex0(
        .rst(rst),
        .excepttype_i(excepttype_deo),.current_inst_address_i(current_inst_address_deo),
        .aluop_i(ex_aluop_i), .alusel_i(ex_alusel_i),
        .reg1_i(ex_reg1_i),  .reg2_i(ex_reg2_i),
        .wd_i(ex_wd_i), .wreg_i(ex_wreg_i),
        .hi_i(hl_hi_o),.lo_i(hl_lo_o),.inst_i(inst_de_o),
        .wb_whilo_i(wb_whilo_o),.wb_hi_i(wb_hi_o),
        .wb_lo_i(wb_lo_o),.cnt_i(cnt_em_o),
        .hilo_temp_i(hilo_em_o),.div_result_i(div_result),
        .div_ready_i(div_ready),.is_in_delayslot_i(ex_is_in_delayslot_deo),
        .link_address_i(ex_link_address_deo),.cp0_reg_data_i(cp0_data_co),
        .wb_cp0_reg_data(cp0_rd_mwo),.wb_cp0_reg_write_addr(cp0_regwaddr_mwo),
        .wb_cp0_reg_we(cp0_regwe_mwo),.mem_cp0_reg_data(cp0_rd_mo),
        .mem_cp0_reg_write_addr(cp0_regwaddr_mo),.mem_cp0_reg_we(cp0_regwe_mo),
        
        .cp0_reg_read_addr_o(cp0_regraddr_exo),.cp0_reg_data_o(cp0_rd_exo),
        .cp0_reg_write_addr_o(cp0_regwaddr_exo),.cp0_reg_we_o(cp0_regwe_exo),
        .mem_whilo_i(mem_whilo_o),.mem_hi_i(mem_hi_o),.is_in_delayslot_o(is_in_delayslot_exo),
        .mem_lo_i(mem_lo_o),.excepttype_o(excepttype_exo),
        .wd_o(ex_wd_o), .wreg_o(ex_wreg_o),
        .wdata_o(ex_wdata_o),.aluop_o(aluop_ex_o),
        .mem_addr_o(mem_addr_ex_o),.reg2_o(reg2_ex_o),
        .whilo_o(ex_whilo_o),.hi_o(ex_hi_o),.current_inst_address_o(current_inst_address_exo),
        .lo_o(ex_lo_o), .stallreq(stallreq_from_ex_i),
        .cnt_o(cnt_ex_o),.hilo_temp_o(hilo_temp_ex_o),
        .div_start_o(div_start),.div_opdata2_o(div_opdata2),
        .div_opdata1_o(div_opdata1),.signed_div_o(signed_div),
        .stall_for_div(stall_for_div)
    );
    
    ex_mem exmem0(
        .clk(clk), .rst(rst),.flush(flush_co),
        .ex_excepttype(excepttype_exo),.ex_current_inst_address(current_inst_address_exo),
        .ex_is_in_delayslot(is_in_delayslot_exo),
        .ex_wd(ex_wd_o), .ex_wreg(ex_wreg_o),
        .ex_wdata(ex_wdata_o),.ex_whilo(ex_whilo_o),
        .ex_hi(ex_hi_o),.ex_lo(ex_lo_o),.stall(stall_out),
        .cnt_i(cnt_ex_o),.hilo_i(hilo_temp_ex_o),.aluop_i(aluop_ex_o),
        .mem_addr_i(mem_addr_ex_o),.reg2_i(reg2_ex_o),
        .ex_cp0_reg_data(cp0_rd_exo),.ex_cp0_reg_write_addr(cp0_regwaddr_exo),
        .ex_cp0_reg_we(cp0_regwe_exo),.excepttype_i(excepttype_mo),.wb_LLbit_we_i(LLbit_we_mwo),
        .wb_LLbit_value_i(LLbit_value_mwo),
        
        .mem_excepttype(excepttype_emo),.mem_current_inst_address(current_inst_address_emo),
        .mem_is_in_delayslot(is_in_delayslot_emo),
        .mem_cp0_reg_data(cp0_rd_emo),.mem_cp0_reg_write_addr(cp0_regwaddr_emo),
        .mem_cp0_reg_we(cp0_regwe_emo),.l_addr_except(l_addr_except),.s_addr_except(s_addr_except),
        .mem_wd(mem_wd_i), .mem_wreg(mem_wreg_i),
        .mem_wdata(mem_wdata_i),.mem_we_o(ram_we_o),
        .mem_sel_o(data_sram_wen),.mem_ce_o(ram_ce_o),
        .mem_whilo(em_whilo_o),.mem_hi(em_hi_o),
        .mem_lo(em_lo_o),.cnt_o(cnt_em_o),
        .hilo_o(hilo_em_o),.mem_aluop(aluop_em_o),.mem_addr_out(mem_addr_out),
        .mem_addr_o(sram_addr),.mem_reg2(reg2_em_o),.mem_data_o(data_sram_wdata)
        
    );
    
    mem mem0(
        .rst(rst),
        .wd_i(mem_wd_i), .wreg_i(mem_wreg_i),.excepttype_ex_i(excepttype_exo),
        .wdata_i(mem_wdata_i),.aluop_i(aluop_em_o),.ex_in_delayslot_i(ex_is_in_delayslot_deo),
        .reg2_i(reg2_em_o),.inst_except_i(inst_except),.l_addr_except_i(l_addr_except),.s_addr_except_i(s_addr_except),
        .whilo_i(em_whilo_o),.hi_i(em_hi_o),.mem_addr_i(mem_addr_out),
        .lo_i(em_lo_o),.mem_data_i(data_sram_rdata),
        .cp0_reg_data_i(cp0_rd_emo),.cp0_reg_write_addr_i(cp0_regwaddr_emo),
        .cp0_reg_we_i(cp0_regwe_emo),.excepttype_i(excepttype_emo),.current_inst_address_i(current_inst_address_emo),
        .is_in_delayslot_i(is_in_delayslot_emo),.cp0_status_i(status_cpo),.cp0_cause_i(cause_cpo),
        .cp0_epc_i(epc_cpo),.wb_cp0_reg_we(cp0_regwe_mwo),.wb_cp0_reg_write_addr(cp0_regwaddr_mwo),
        .wb_cp0_reg_data(cp0_rd_mwo),
        
        .cp0_reg_data_o(cp0_rd_mo),.cp0_reg_write_addr_o(cp0_regwaddr_mo),
        .cp0_reg_we_o(cp0_regwe_mo),.cp0_epc_o(cp0_epc_mo),.excepttype_o(excepttype_mo),
        .current_inst_address_o(current_inst_address_mo),.is_in_delayslot_o(is_in_delayslot_mo),
        .LLbit_i(LLbit_Lbo),.wb_LLbit_we_i(LLbit_we_mwo),
        .wb_LLbit_value_i(LLbit_value_mwo),
        .LLbit_we_o(LLbit_we_mo),.LLbit_value_o(LLbit_value_mo),
        
        .wd_o(mem_wd_o),  .wreg_o(mem_wreg_o),
        .wdata_o(mem_wdata_o),
        .whilo_o(mem_whilo_o),.hi_o(mem_hi_o),
        .lo_o(mem_lo_o)
    );
    
    mem_wb mem_wb0(
        .clk(clk), .rst(rst),.flush(flush_co),
        .mem_LLbit_we(LLbit_we_mo),.mem_LLbit_value(LLbit_value_mo),
        .mem_wd(mem_wd_o), .mem_wreg(mem_wreg_o),
        .mem_wdata(mem_wdata_o),.current_pc_i(current_inst_address_emo),
        .mem_whilo(mem_whilo_o),.mem_hi(mem_hi_o),
        .mem_cp0_reg_data(cp0_rd_mo),.mem_cp0_reg_write_addr(cp0_regwaddr_mo),
        .mem_cp0_reg_we(cp0_regwe_mo),
        
        .wb_cp0_reg_data(cp0_rd_mwo),.wb_cp0_reg_write_addr(cp0_regwaddr_mwo),
        .wb_cp0_reg_we(cp0_regwe_mwo),.current_pc_o(reg_pc),
        .mem_lo(mem_lo_o),.stall(stall_out),
        .wb_LLbit_we(LLbit_we_mwo),.wb_LLbit_value(LLbit_value_mwo),
        .wb_wd(wb_wd_i),  .wb_wreg(wb_wreg_i),
        .wb_wdata(wb_wdata_i), .wb_whilo(wb_whilo_o),
        .wb_hi(wb_hi_o), .wb_lo(wb_lo_o)
    );

    
    hilo_reg hilo_reg0(
    .rst(rst),.clk(clk),
    .we(wb_whilo_o), .hi_i(wb_hi_o),
    .lo_i(wb_lo_o),
    .hi_o(hl_hi_o),.lo_o(hl_lo_o)
    );
    
    ctrl ctrl0(
        .rst(rst),.stallreq_from_id(stallreq_from_id_i),
        .stallreq_from_ex(stallreq_from_ex_i),.cp0_epc_i(cp0_epc_mo),
        .excepttype_i(excepttype_mo),.stallreq_for_div(stall_for_div),
        .new_pc(new_pc_co),.flush(flush_co),
        .stall(stall_out)
    );
    
    div div0(
        .clk(clk),
        .rst(rst),
        .signed_div_i(signed_div),
        .opdata1_i(div_opdata1),
        .opdata2_i(div_opdata2),
        .start_i(div_start),
        .annul_i(flush_co),
        .result_o(div_result),
        .ready_o(div_ready)
    );
    
    LLbit_reg LLbit0(
        .clk(clk),.flush(flush_co),
        .rst(rst),
        .we(LLbit_we_mwo),.LLbit_i(LLbit_value_mwo),
        .LLbit_o(LLbit_Lbo)
    );
    
    cp0_reg cp0_reg0(
        .clk(clk),.rst(rst),.bad_mem_addr(mem_addr_ex_o),.inst_except(inst_except),.bad_inst_addr(pre_pc),
        .raddr_i(cp0_regraddr_exo),.data_i(cp0_rd_mwo),.ex_in_delayslot_i(ex_is_in_delayslot_deo),
        .waddr_i(cp0_regwaddr_mwo),.we_i(cp0_regwe_mwo),
        .int_i(int),.excepttype_i(excepttype_mo),
        .current_inst_addr_i(current_inst_address_mo),.is_in_delayslot_i(is_in_delayslot_mo),
        .status_o(status_cpo),.cause_o(cause_cpo),.epc_o(epc_cpo),
        .data_o(cp0_data_co),.timer_int_o(timer_int_o)
    );
    
endmodule
