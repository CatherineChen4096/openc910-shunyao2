/*Copyright 2019-2021 T-Head Semiconductor Co., Ltd.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

// &Depend("cpu_cfig.h"); @23
// //&Depend("core_golden_port.vp"); @24

// &ModuleBeg; @26
module ct_core(
  biu_cp0_apb_base,
  biu_cp0_cmplt,
  biu_cp0_coreid,
  biu_cp0_me_int,
  biu_cp0_ms_int,
  biu_cp0_mt_int,
  biu_cp0_rdata,
  biu_cp0_rvba,
  biu_cp0_se_int,
  biu_cp0_ss_int,
  biu_cp0_st_int,
  biu_ifu_rd_data,
  biu_ifu_rd_data_vld,
  biu_ifu_rd_grnt,
  biu_ifu_rd_id,
  biu_ifu_rd_last,
  biu_ifu_rd_resp,
  biu_lsu_ac_addr,
  biu_lsu_ac_prot,
  biu_lsu_ac_req,
  biu_lsu_ac_snoop,
  biu_lsu_ar_ready,
  biu_lsu_aw_vb_grnt,
  biu_lsu_aw_wmb_grnt,
  biu_lsu_b_id,
  biu_lsu_b_resp,
  biu_lsu_b_vld,
  biu_lsu_cd_ready,
  biu_lsu_cr_ready,
  biu_lsu_r_data,
  biu_lsu_r_id,
  biu_lsu_r_last,
  biu_lsu_r_resp,
  biu_lsu_r_vld,
  biu_lsu_w_vb_grnt,
  biu_lsu_w_wmb_grnt,
  biu_yy_xx_no_op,
  cp0_biu_icg_en,
  cp0_biu_lpmd_b,
  cp0_biu_op,
  cp0_biu_sel,
  cp0_biu_wdata,
  cp0_had_cpuid_0,
  cp0_had_debug_info,
  cp0_had_lpmd_b,
  cp0_had_trace_pm_wdata,
  cp0_had_trace_pm_wen,
  cp0_hpcp_icg_en,
  cp0_hpcp_index,
  cp0_hpcp_int_disable,
  cp0_hpcp_mcntwen,
  cp0_hpcp_op,
  cp0_hpcp_pmdm,
  cp0_hpcp_pmds,
  cp0_hpcp_pmdu,
  cp0_hpcp_sel,
  cp0_hpcp_src0,
  cp0_hpcp_wdata,
  cp0_mmu_cskyee,
  cp0_mmu_icg_en,
  cp0_mmu_maee,
  cp0_mmu_mpp,
  cp0_mmu_mprv,
  cp0_mmu_mxr,
  cp0_mmu_no_op_req,
  cp0_mmu_ptw_en,
  cp0_mmu_reg_num,
  cp0_mmu_satp_sel,
  cp0_mmu_sum,
  cp0_mmu_tlb_all_inv,
  cp0_mmu_wdata,
  cp0_mmu_wreg,
  cp0_pad_mstatus,
  cp0_pmp_icg_en,
  cp0_pmp_mpp,
  cp0_pmp_mprv,
  cp0_pmp_reg_num,
  cp0_pmp_wdata,
  cp0_pmp_wreg,
  cp0_xx_core_icg_en,
  cp0_yy_priv_mode,
  forever_cpuclk,
  fpu_rst_b,
  had_cp0_xx_dbg,
  had_idu_debug_id_inst_en,
  had_idu_wbbr_data,
  had_idu_wbbr_vld,
  had_ifu_ir,
  had_ifu_ir_vld,
  had_ifu_pc,
  had_ifu_pcload,
  had_lsu_bus_trace_en,
  had_lsu_dbg_en,
  had_rtu_data_bkpt_dbgreq,
  had_rtu_dbg_disable,
  had_rtu_dbg_req_en,
  had_rtu_debug_retire_info_en,
  had_rtu_event_dbgreq,
  had_rtu_fdb,
  had_rtu_hw_dbgreq,
  had_rtu_hw_dbgreq_gateclk,
  had_rtu_inst_bkpt_dbgreq,
  had_rtu_non_irv_bkpt_dbgreq,
  had_rtu_pop1_disa,
  had_rtu_trace_dbgreq,
  had_rtu_trace_en,
  had_rtu_xx_jdbreq,
  had_rtu_xx_tme,
  had_yy_xx_bkpta_base,
  had_yy_xx_bkpta_mask,
  had_yy_xx_bkpta_rc,
  had_yy_xx_bkptb_base,
  had_yy_xx_bkptb_mask,
  had_yy_xx_bkptb_rc,
  had_yy_xx_exit_dbg,
  hpcp_cp0_cmplt,
  hpcp_cp0_data,
  hpcp_cp0_int_vld,
  hpcp_cp0_sce,
  hpcp_idu_cnt_en,
  hpcp_ifu_cnt_en,
  hpcp_lsu_cnt_en,
  hpcp_rtu_cnt_en,
  idu_had_debug_info,
  idu_had_id_inst0_info,
  idu_had_id_inst0_vld,
  idu_had_id_inst1_info,
  idu_had_id_inst1_vld,
  idu_had_id_inst2_info,
  idu_had_id_inst2_vld,
  idu_had_iq_empty,
  idu_had_pipe_stall,
  idu_had_pipeline_empty,
  idu_had_wb_data,
  idu_had_wb_vld,
  idu_hpcp_backend_stall,
  idu_hpcp_fence_sync_vld,
  idu_hpcp_ir_inst0_type,
  idu_hpcp_ir_inst0_vld,
  idu_hpcp_ir_inst1_type,
  idu_hpcp_ir_inst1_vld,
  idu_hpcp_ir_inst2_type,
  idu_hpcp_ir_inst2_vld,
  idu_hpcp_ir_inst3_type,
  idu_hpcp_ir_inst3_vld,
  idu_hpcp_rf_inst_vld,
  idu_hpcp_rf_pipe0_inst_vld,
  idu_hpcp_rf_pipe0_lch_fail_vld,
  idu_hpcp_rf_pipe1_inst_vld,
  idu_hpcp_rf_pipe1_lch_fail_vld,
  idu_hpcp_rf_pipe2_inst_vld,
  idu_hpcp_rf_pipe2_lch_fail_vld,
  idu_hpcp_rf_pipe3_inst_vld,
  idu_hpcp_rf_pipe3_lch_fail_vld,
  idu_hpcp_rf_pipe3_reg_lch_fail_vld,
  idu_hpcp_rf_pipe4_inst_vld,
  idu_hpcp_rf_pipe4_lch_fail_vld,
  idu_hpcp_rf_pipe4_reg_lch_fail_vld,
  idu_hpcp_rf_pipe5_inst_vld,
  idu_hpcp_rf_pipe5_lch_fail_vld,
  idu_hpcp_rf_pipe5_reg_lch_fail_vld,
  idu_hpcp_rf_pipe6_inst_vld,
  idu_hpcp_rf_pipe6_lch_fail_vld,
  idu_hpcp_rf_pipe7_inst_vld,
  idu_hpcp_rf_pipe7_lch_fail_vld,
  idu_rst_b,
  ifu_biu_r_ready,
  ifu_biu_rd_addr,
  ifu_biu_rd_burst,
  ifu_biu_rd_cache,
  ifu_biu_rd_domain,
  ifu_biu_rd_id,
  ifu_biu_rd_len,
  ifu_biu_rd_prot,
  ifu_biu_rd_req,
  ifu_biu_rd_req_gate,
  ifu_biu_rd_size,
  ifu_biu_rd_snoop,
  ifu_biu_rd_user,
  ifu_had_debug_info,
  ifu_had_no_inst,
  ifu_had_no_op,
  ifu_had_reset_on,
  ifu_hpcp_btb_inst,
  ifu_hpcp_btb_mispred,
  ifu_hpcp_frontend_stall,
  ifu_hpcp_icache_access,
  ifu_hpcp_icache_miss,
  ifu_mmu_abort,
  ifu_mmu_va,
  ifu_mmu_va_vld,
  ifu_rst_b,
  iu_had_debug_info,
  lsu_biu_ac_empty,
  lsu_biu_ac_ready,
  lsu_biu_ar_addr,
  lsu_biu_ar_bar,
  lsu_biu_ar_burst,
  lsu_biu_ar_cache,
  lsu_biu_ar_domain,
  lsu_biu_ar_dp_req,
  lsu_biu_ar_id,
  lsu_biu_ar_len,
  lsu_biu_ar_lock,
  lsu_biu_ar_prot,
  lsu_biu_ar_req,
  lsu_biu_ar_req_gate,
  lsu_biu_ar_size,
  lsu_biu_ar_snoop,
  lsu_biu_ar_user,
  lsu_biu_aw_req_gate,
  lsu_biu_aw_st_addr,
  lsu_biu_aw_st_bar,
  lsu_biu_aw_st_burst,
  lsu_biu_aw_st_cache,
  lsu_biu_aw_st_domain,
  lsu_biu_aw_st_dp_req,
  lsu_biu_aw_st_id,
  lsu_biu_aw_st_len,
  lsu_biu_aw_st_lock,
  lsu_biu_aw_st_prot,
  lsu_biu_aw_st_req,
  lsu_biu_aw_st_size,
  lsu_biu_aw_st_snoop,
  lsu_biu_aw_st_unique,
  lsu_biu_aw_st_user,
  lsu_biu_aw_vict_addr,
  lsu_biu_aw_vict_bar,
  lsu_biu_aw_vict_burst,
  lsu_biu_aw_vict_cache,
  lsu_biu_aw_vict_domain,
  lsu_biu_aw_vict_dp_req,
  lsu_biu_aw_vict_id,
  lsu_biu_aw_vict_len,
  lsu_biu_aw_vict_lock,
  lsu_biu_aw_vict_prot,
  lsu_biu_aw_vict_req,
  lsu_biu_aw_vict_size,
  lsu_biu_aw_vict_snoop,
  lsu_biu_aw_vict_unique,
  lsu_biu_aw_vict_user,
  lsu_biu_cd_data,
  lsu_biu_cd_last,
  lsu_biu_cd_valid,
  lsu_biu_cr_resp,
  lsu_biu_cr_valid,
  lsu_biu_r_linefill_ready,
  lsu_biu_w_st_data,
  lsu_biu_w_st_last,
  lsu_biu_w_st_strb,
  lsu_biu_w_st_vld,
  lsu_biu_w_st_wns,
  lsu_biu_w_vict_data,
  lsu_biu_w_vict_last,
  lsu_biu_w_vict_strb,
  lsu_biu_w_vict_vld,
  lsu_biu_w_vict_wns,
  lsu_had_debug_info,
  lsu_had_ld_addr,
  lsu_had_ld_data,
  lsu_had_ld_iid,
  lsu_had_ld_req,
  lsu_had_ld_type,
  lsu_had_no_op,
  lsu_had_st_addr,
  lsu_had_st_data,
  lsu_had_st_iid,
  lsu_had_st_req,
  lsu_had_st_type,
  lsu_hpcp_cache_read_access,
  lsu_hpcp_cache_read_miss,
  lsu_hpcp_cache_write_access,
  lsu_hpcp_cache_write_miss,
  lsu_hpcp_fence_stall,
  lsu_hpcp_ld_stall_cross_4k,
  lsu_hpcp_ld_stall_other,
  lsu_hpcp_replay_data_discard,
  lsu_hpcp_replay_discard_sq,
  lsu_hpcp_st_stall_cross_4k,
  lsu_hpcp_st_stall_other,
  lsu_hpcp_unalign_inst,
  lsu_mmu_abort0,
  lsu_mmu_abort1,
  lsu_mmu_bus_error,
  lsu_mmu_data,
  lsu_mmu_data_vld,
  lsu_mmu_id0,
  lsu_mmu_id1,
  lsu_mmu_st_inst0,
  lsu_mmu_st_inst1,
  lsu_mmu_stamo_pa,
  lsu_mmu_stamo_vld,
  lsu_mmu_tlb_all_inv,
  lsu_mmu_tlb_asid,
  lsu_mmu_tlb_asid_all_inv,
  lsu_mmu_tlb_va,
  lsu_mmu_tlb_va_all_inv,
  lsu_mmu_tlb_va_asid_inv,
  lsu_mmu_va0,
  lsu_mmu_va0_vld,
  lsu_mmu_va1,
  lsu_mmu_va1_vld,
  lsu_mmu_va2,
  lsu_mmu_va2_vld,
  lsu_mmu_vabuf0,
  lsu_mmu_vabuf1,
  lsu_rst_b,
  mmu_cp0_cmplt,
  mmu_cp0_data,
  mmu_cp0_satp_data,
  mmu_cp0_tlb_done,
  mmu_ifu_buf,
  mmu_ifu_ca,
  mmu_ifu_deny,
  mmu_ifu_pa,
  mmu_ifu_pavld,
  mmu_ifu_pgflt,
  mmu_ifu_sec,
  mmu_lsu_access_fault0,
  mmu_lsu_access_fault1,
  mmu_lsu_buf0,
  mmu_lsu_buf1,
  mmu_lsu_ca0,
  mmu_lsu_ca1,
  mmu_lsu_data_req,
  mmu_lsu_data_req_addr,
  mmu_lsu_data_req_size,
  mmu_lsu_mmu_en,
  mmu_lsu_pa0,
  mmu_lsu_pa0_vld,
  mmu_lsu_pa1,
  mmu_lsu_pa1_vld,
  mmu_lsu_pa2,
  mmu_lsu_pa2_err,
  mmu_lsu_pa2_vld,
  mmu_lsu_page_fault0,
  mmu_lsu_page_fault1,
  mmu_lsu_sec0,
  mmu_lsu_sec1,
  mmu_lsu_sec2,
  mmu_lsu_sh0,
  mmu_lsu_sh1,
  mmu_lsu_share2,
  mmu_lsu_so0,
  mmu_lsu_so1,
  mmu_lsu_stall0,
  mmu_lsu_stall1,
  mmu_lsu_tlb_busy,
  mmu_lsu_tlb_inv_done,
  mmu_lsu_tlb_wakeup,
  mmu_xx_mmu_en,
  mmu_yy_xx_no_op,
  pad_yy_icg_scan_en,
  pad_yy_scan_mode,
  pmp_cp0_data,
  rtu_cpu_no_retire,
  rtu_had_bkpt_data_st,
  rtu_had_data_bkpta_vld,
  rtu_had_data_bkptb_vld,
  rtu_had_dbg_ack_info,
  rtu_had_dbgreq_ack,
  rtu_had_debug_info,
  rtu_had_inst0_bkpt_inst,
  rtu_had_inst0_non_irv_bkpt,
  rtu_had_inst1_non_irv_bkpt,
  rtu_had_inst2_non_irv_bkpt,
  rtu_had_inst_bkpt_inst_vld,
  rtu_had_inst_bkpta_vld,
  rtu_had_inst_bkptb_vld,
  rtu_had_inst_exe_dead,
  rtu_had_inst_not_wb,
  rtu_had_inst_split,
  rtu_had_retire_inst0_info,
  rtu_had_retire_inst0_vld,
  rtu_had_retire_inst1_info,
  rtu_had_retire_inst1_vld,
  rtu_had_retire_inst2_info,
  rtu_had_retire_inst2_vld,
  rtu_had_rob_empty,
  rtu_had_xx_dbg_ack_pc,
  rtu_had_xx_mbkpt_chgflow,
  rtu_had_xx_mbkpt_data_ack,
  rtu_had_xx_mbkpt_inst_ack,
  rtu_had_xx_pc,
  rtu_had_xx_pcfifo_inst0_chgflow,
  rtu_had_xx_pcfifo_inst0_condbr,
  rtu_had_xx_pcfifo_inst0_condbr_taken,
  rtu_had_xx_pcfifo_inst0_iid,
  rtu_had_xx_pcfifo_inst0_jmp,
  rtu_had_xx_pcfifo_inst0_next_pc,
  rtu_had_xx_pcfifo_inst0_pcall,
  rtu_had_xx_pcfifo_inst0_preturn,
  rtu_had_xx_pcfifo_inst1_chgflow,
  rtu_had_xx_pcfifo_inst1_condbr,
  rtu_had_xx_pcfifo_inst1_condbr_taken,
  rtu_had_xx_pcfifo_inst1_jmp,
  rtu_had_xx_pcfifo_inst1_next_pc,
  rtu_had_xx_pcfifo_inst1_pcall,
  rtu_had_xx_pcfifo_inst1_preturn,
  rtu_had_xx_pcfifo_inst2_chgflow,
  rtu_had_xx_pcfifo_inst2_condbr,
  rtu_had_xx_pcfifo_inst2_condbr_taken,
  rtu_had_xx_pcfifo_inst2_jmp,
  rtu_had_xx_pcfifo_inst2_next_pc,
  rtu_had_xx_pcfifo_inst2_pcall,
  rtu_had_xx_pcfifo_inst2_preturn,
  rtu_had_xx_split_inst,
  rtu_hpcp_inst0_ack_int,
  rtu_hpcp_inst0_bht_mispred,
  rtu_hpcp_inst0_condbr,
  rtu_hpcp_inst0_cur_pc,
  rtu_hpcp_inst0_jmp,
  rtu_hpcp_inst0_jmp_mispred,
  rtu_hpcp_inst0_jmp_pc_offset_8m,
  rtu_hpcp_inst0_num,
  rtu_hpcp_inst0_pc_offset,
  rtu_hpcp_inst0_spec_fail,
  rtu_hpcp_inst0_split,
  rtu_hpcp_inst0_store,
  rtu_hpcp_inst0_vld,
  rtu_hpcp_inst1_condbr,
  rtu_hpcp_inst1_cur_pc,
  rtu_hpcp_inst1_jmp,
  rtu_hpcp_inst1_jmp_pc_offset_8m,
  rtu_hpcp_inst1_num,
  rtu_hpcp_inst1_pc_offset,
  rtu_hpcp_inst1_split,
  rtu_hpcp_inst1_store,
  rtu_hpcp_inst1_vld,
  rtu_hpcp_inst2_condbr,
  rtu_hpcp_inst2_cur_pc,
  rtu_hpcp_inst2_jmp,
  rtu_hpcp_inst2_jmp_pc_offset_8m,
  rtu_hpcp_inst2_num,
  rtu_hpcp_inst2_pc_offset,
  rtu_hpcp_inst2_split,
  rtu_hpcp_inst2_store,
  rtu_hpcp_inst2_vld,
  rtu_hpcp_trace_inst0_chgflow,
  rtu_hpcp_trace_inst0_next_pc,
  rtu_hpcp_trace_inst1_chgflow,
  rtu_hpcp_trace_inst1_next_pc,
  rtu_hpcp_trace_inst2_chgflow,
  rtu_hpcp_trace_inst2_next_pc,
  rtu_mmu_bad_vpn,
  rtu_mmu_expt_vld,
  rtu_pad_retire0,
  rtu_pad_retire0_pc,
  rtu_pad_retire1,
  rtu_pad_retire1_pc,
  rtu_pad_retire2,
  rtu_pad_retire2_pc,
//`ifdef SHUNSIM_MP
  value0,
  value1,
  value2,
//`endif
  rtu_yy_xx_dbgon,
  rtu_yy_xx_flush,
  rtu_yy_xx_retire0,
  rtu_yy_xx_retire0_normal,
  rtu_yy_xx_retire1,
  rtu_yy_xx_retire2
);

//&Ports("compare", "../../../gen_rtl/cpu/rtl/core_golden_port.v");
// &Ports; @28
//`ifdef SHUNSIM_MP
output [63:0] value0;
output [63:0] value1;
output [63:0] value2;
//`endif
input   [39 :0]  biu_cp0_apb_base;                       
input            biu_cp0_cmplt;                          
input   [2  :0]  biu_cp0_coreid;                         
input            biu_cp0_me_int;                         
input            biu_cp0_ms_int;                         
input            biu_cp0_mt_int;                         
input   [127:0]  biu_cp0_rdata;                          
input   [39 :0]  biu_cp0_rvba;                           
input            biu_cp0_se_int;                         
input            biu_cp0_ss_int;                         
input            biu_cp0_st_int;                         
input   [127:0]  biu_ifu_rd_data;                        
input            biu_ifu_rd_data_vld;                    
input            biu_ifu_rd_grnt;                        
input            biu_ifu_rd_id;                          
input            biu_ifu_rd_last;                        
input   [1  :0]  biu_ifu_rd_resp;                        
input   [39 :0]  biu_lsu_ac_addr;                        
input   [2  :0]  biu_lsu_ac_prot;                        
input            biu_lsu_ac_req;                         
input   [3  :0]  biu_lsu_ac_snoop;                       
input            biu_lsu_ar_ready;                       
input            biu_lsu_aw_vb_grnt;                     
input            biu_lsu_aw_wmb_grnt;                    
input   [4  :0]  biu_lsu_b_id;                           
input   [1  :0]  biu_lsu_b_resp;                         
input            biu_lsu_b_vld;                          
input            biu_lsu_cd_ready;                       
input            biu_lsu_cr_ready;                       
input   [127:0]  biu_lsu_r_data;                         
input   [4  :0]  biu_lsu_r_id;                           
input            biu_lsu_r_last;                         
input   [3  :0]  biu_lsu_r_resp;                         
input            biu_lsu_r_vld;                          
input            biu_lsu_w_vb_grnt;                      
input            biu_lsu_w_wmb_grnt;                     
input            biu_yy_xx_no_op;                        
input            forever_cpuclk;                         
input            fpu_rst_b;                              
input            had_cp0_xx_dbg;                         
input            had_idu_debug_id_inst_en;               
input   [63 :0]  had_idu_wbbr_data;                      
input            had_idu_wbbr_vld;                       
input   [31 :0]  had_ifu_ir;                             
input            had_ifu_ir_vld;                         
input   [38 :0]  had_ifu_pc;                             
input            had_ifu_pcload;                         
input            had_lsu_bus_trace_en;                   
input            had_lsu_dbg_en;                         
input            had_rtu_data_bkpt_dbgreq;               
input            had_rtu_dbg_disable;                    
input            had_rtu_dbg_req_en;                     
input            had_rtu_debug_retire_info_en;           
input            had_rtu_event_dbgreq;                   
input            had_rtu_fdb;                            
input            had_rtu_hw_dbgreq;                      
input            had_rtu_hw_dbgreq_gateclk;              
input            had_rtu_inst_bkpt_dbgreq;               
input            had_rtu_non_irv_bkpt_dbgreq;            
input            had_rtu_pop1_disa;                      
input            had_rtu_trace_dbgreq;                   
input            had_rtu_trace_en;                       
input            had_rtu_xx_jdbreq;                      
input            had_rtu_xx_tme;                         
input   [39 :0]  had_yy_xx_bkpta_base;                   
input   [7  :0]  had_yy_xx_bkpta_mask;                   
input            had_yy_xx_bkpta_rc;                     
input   [39 :0]  had_yy_xx_bkptb_base;                   
input   [7  :0]  had_yy_xx_bkptb_mask;                   
input            had_yy_xx_bkptb_rc;                     
input            had_yy_xx_exit_dbg;                     
input            hpcp_cp0_cmplt;                         
input   [63 :0]  hpcp_cp0_data;                          
input            hpcp_cp0_int_vld;                       
input            hpcp_cp0_sce;                           
input            hpcp_idu_cnt_en;                        
input            hpcp_ifu_cnt_en;                        
input            hpcp_lsu_cnt_en;                        
input            hpcp_rtu_cnt_en;                        
input            idu_rst_b;                              
input            ifu_rst_b;                              
input            lsu_rst_b;                              
input            mmu_cp0_cmplt;                          
input   [63 :0]  mmu_cp0_data;                           
input   [63 :0]  mmu_cp0_satp_data;                      
input            mmu_cp0_tlb_done;                       
input            mmu_ifu_buf;                            
input            mmu_ifu_ca;                             
input            mmu_ifu_deny;                           
input   [27 :0]  mmu_ifu_pa;                             
input            mmu_ifu_pavld;                          
input            mmu_ifu_pgflt;                          
input            mmu_ifu_sec;                            
input            mmu_lsu_access_fault0;                  
input            mmu_lsu_access_fault1;                  
input            mmu_lsu_buf0;                           
input            mmu_lsu_buf1;                           
input            mmu_lsu_ca0;                            
input            mmu_lsu_ca1;                            
input            mmu_lsu_data_req;                       
input   [39 :0]  mmu_lsu_data_req_addr;                  
input            mmu_lsu_data_req_size;                  
input            mmu_lsu_mmu_en;                         
input   [27 :0]  mmu_lsu_pa0;                            
input            mmu_lsu_pa0_vld;                        
input   [27 :0]  mmu_lsu_pa1;                            
input            mmu_lsu_pa1_vld;                        
input   [27 :0]  mmu_lsu_pa2;                            
input            mmu_lsu_pa2_err;                        
input            mmu_lsu_pa2_vld;                        
input            mmu_lsu_page_fault0;                    
input            mmu_lsu_page_fault1;                    
input            mmu_lsu_sec0;                           
input            mmu_lsu_sec1;                           
input            mmu_lsu_sec2;                           
input            mmu_lsu_sh0;                            
input            mmu_lsu_sh1;                            
input            mmu_lsu_share2;                         
input            mmu_lsu_so0;                            
input            mmu_lsu_so1;                            
input            mmu_lsu_stall0;                         
input            mmu_lsu_stall1;                         
input            mmu_lsu_tlb_busy;                       
input            mmu_lsu_tlb_inv_done;                   
input   [11 :0]  mmu_lsu_tlb_wakeup;                     
input            mmu_xx_mmu_en;                          
input            mmu_yy_xx_no_op;                        
input            pad_yy_icg_scan_en;                     
input            pad_yy_scan_mode;                       
input   [63 :0]  pmp_cp0_data;                           
output           cp0_biu_icg_en;                         
output  [1  :0]  cp0_biu_lpmd_b;                         
output  [15 :0]  cp0_biu_op;                             
output           cp0_biu_sel;                            
output  [63 :0]  cp0_biu_wdata;                          
output  [31 :0]  cp0_had_cpuid_0;                        
output  [3  :0]  cp0_had_debug_info;                     
output  [1  :0]  cp0_had_lpmd_b;                         
output  [1  :0]  cp0_had_trace_pm_wdata;                 
output           cp0_had_trace_pm_wen;                   
output           cp0_hpcp_icg_en;                        
output  [11 :0]  cp0_hpcp_index;                         
output           cp0_hpcp_int_disable;                   
output  [31 :0]  cp0_hpcp_mcntwen;                       
output  [3  :0]  cp0_hpcp_op;                            
output           cp0_hpcp_pmdm;                          
output           cp0_hpcp_pmds;                          
output           cp0_hpcp_pmdu;                          
output           cp0_hpcp_sel;                           
output  [63 :0]  cp0_hpcp_src0;                          
output  [63 :0]  cp0_hpcp_wdata;                         
output           cp0_mmu_cskyee;                         
output           cp0_mmu_icg_en;                         
output           cp0_mmu_maee;                           
output  [1  :0]  cp0_mmu_mpp;                            
output           cp0_mmu_mprv;                           
output           cp0_mmu_mxr;                            
output           cp0_mmu_no_op_req;                      
output           cp0_mmu_ptw_en;                         
output  [1  :0]  cp0_mmu_reg_num;                        
output           cp0_mmu_satp_sel;                       
output           cp0_mmu_sum;                            
output           cp0_mmu_tlb_all_inv;                    
output  [63 :0]  cp0_mmu_wdata;                          
output           cp0_mmu_wreg;                           
output  [63 :0]  cp0_pad_mstatus;                        
output           cp0_pmp_icg_en;                         
output  [1  :0]  cp0_pmp_mpp;                            
output           cp0_pmp_mprv;                           
output  [4  :0]  cp0_pmp_reg_num;                        
output  [63 :0]  cp0_pmp_wdata;                          
output           cp0_pmp_wreg;                           
output           cp0_xx_core_icg_en;                     
output  [1  :0]  cp0_yy_priv_mode;                       
output  [49 :0]  idu_had_debug_info;                     
output  [39 :0]  idu_had_id_inst0_info;                  
output           idu_had_id_inst0_vld;                   
output  [39 :0]  idu_had_id_inst1_info;                  
output           idu_had_id_inst1_vld;                   
output  [39 :0]  idu_had_id_inst2_info;                  
output           idu_had_id_inst2_vld;                   
output           idu_had_iq_empty;                       
output           idu_had_pipe_stall;                     
output           idu_had_pipeline_empty;                 
output  [63 :0]  idu_had_wb_data;                        
output           idu_had_wb_vld;                         
output           idu_hpcp_backend_stall;                 
output           idu_hpcp_fence_sync_vld;                
output  [6  :0]  idu_hpcp_ir_inst0_type;                 
output           idu_hpcp_ir_inst0_vld;                  
output  [6  :0]  idu_hpcp_ir_inst1_type;                 
output           idu_hpcp_ir_inst1_vld;                  
output  [6  :0]  idu_hpcp_ir_inst2_type;                 
output           idu_hpcp_ir_inst2_vld;                  
output  [6  :0]  idu_hpcp_ir_inst3_type;                 
output           idu_hpcp_ir_inst3_vld;                  
output           idu_hpcp_rf_inst_vld;                   
output           idu_hpcp_rf_pipe0_inst_vld;             
output           idu_hpcp_rf_pipe0_lch_fail_vld;         
output           idu_hpcp_rf_pipe1_inst_vld;             
output           idu_hpcp_rf_pipe1_lch_fail_vld;         
output           idu_hpcp_rf_pipe2_inst_vld;             
output           idu_hpcp_rf_pipe2_lch_fail_vld;         
output           idu_hpcp_rf_pipe3_inst_vld;             
output           idu_hpcp_rf_pipe3_lch_fail_vld;         
output           idu_hpcp_rf_pipe3_reg_lch_fail_vld;     
output           idu_hpcp_rf_pipe4_inst_vld;             
output           idu_hpcp_rf_pipe4_lch_fail_vld;         
output           idu_hpcp_rf_pipe4_reg_lch_fail_vld;     
output           idu_hpcp_rf_pipe5_inst_vld;             
output           idu_hpcp_rf_pipe5_lch_fail_vld;         
output           idu_hpcp_rf_pipe5_reg_lch_fail_vld;     
output           idu_hpcp_rf_pipe6_inst_vld;             
output           idu_hpcp_rf_pipe6_lch_fail_vld;         
output           idu_hpcp_rf_pipe7_inst_vld;             
output           idu_hpcp_rf_pipe7_lch_fail_vld;         
output           ifu_biu_r_ready;                        
output  [39 :0]  ifu_biu_rd_addr;                        
output  [1  :0]  ifu_biu_rd_burst;                       
output  [3  :0]  ifu_biu_rd_cache;                       
output  [1  :0]  ifu_biu_rd_domain;                      
output           ifu_biu_rd_id;                          
output  [1  :0]  ifu_biu_rd_len;                         
output  [2  :0]  ifu_biu_rd_prot;                        
output           ifu_biu_rd_req;                         
output           ifu_biu_rd_req_gate;                    
output  [2  :0]  ifu_biu_rd_size;                        
output  [3  :0]  ifu_biu_rd_snoop;                       
output  [1  :0]  ifu_biu_rd_user;                        
output  [82 :0]  ifu_had_debug_info;                     
output           ifu_had_no_inst;                        
output           ifu_had_no_op;                          
output           ifu_had_reset_on;                       
output           ifu_hpcp_btb_inst;                      
output           ifu_hpcp_btb_mispred;                   
output           ifu_hpcp_frontend_stall;                
output           ifu_hpcp_icache_access;                 
output           ifu_hpcp_icache_miss;                   
output           ifu_mmu_abort;                          
output  [62 :0]  ifu_mmu_va;                             
output           ifu_mmu_va_vld;                         
output  [9  :0]  iu_had_debug_info;                      
output           lsu_biu_ac_empty;                       
output           lsu_biu_ac_ready;                       
output  [39 :0]  lsu_biu_ar_addr;                        
output  [1  :0]  lsu_biu_ar_bar;                         
output  [1  :0]  lsu_biu_ar_burst;                       
output  [3  :0]  lsu_biu_ar_cache;                       
output  [1  :0]  lsu_biu_ar_domain;                      
output           lsu_biu_ar_dp_req;                      
output  [4  :0]  lsu_biu_ar_id;                          
output  [1  :0]  lsu_biu_ar_len;                         
output           lsu_biu_ar_lock;                        
output  [2  :0]  lsu_biu_ar_prot;                        
output           lsu_biu_ar_req;                         
output           lsu_biu_ar_req_gate;                    
output  [2  :0]  lsu_biu_ar_size;                        
output  [3  :0]  lsu_biu_ar_snoop;                       
output  [2  :0]  lsu_biu_ar_user;                        
output           lsu_biu_aw_req_gate;                    
output  [39 :0]  lsu_biu_aw_st_addr;                     
output  [1  :0]  lsu_biu_aw_st_bar;                      
output  [1  :0]  lsu_biu_aw_st_burst;                    
output  [3  :0]  lsu_biu_aw_st_cache;                    
output  [1  :0]  lsu_biu_aw_st_domain;                   
output           lsu_biu_aw_st_dp_req;                   
output  [4  :0]  lsu_biu_aw_st_id;                       
output  [1  :0]  lsu_biu_aw_st_len;                      
output           lsu_biu_aw_st_lock;                     
output  [2  :0]  lsu_biu_aw_st_prot;                     
output           lsu_biu_aw_st_req;                      
output  [2  :0]  lsu_biu_aw_st_size;                     
output  [2  :0]  lsu_biu_aw_st_snoop;                    
output           lsu_biu_aw_st_unique;                   
output           lsu_biu_aw_st_user;                     
output  [39 :0]  lsu_biu_aw_vict_addr;                   
output  [1  :0]  lsu_biu_aw_vict_bar;                    
output  [1  :0]  lsu_biu_aw_vict_burst;                  
output  [3  :0]  lsu_biu_aw_vict_cache;                  
output  [1  :0]  lsu_biu_aw_vict_domain;                 
output           lsu_biu_aw_vict_dp_req;                 
output  [4  :0]  lsu_biu_aw_vict_id;                     
output  [1  :0]  lsu_biu_aw_vict_len;                    
output           lsu_biu_aw_vict_lock;                   
output  [2  :0]  lsu_biu_aw_vict_prot;                   
output           lsu_biu_aw_vict_req;                    
output  [2  :0]  lsu_biu_aw_vict_size;                   
output  [2  :0]  lsu_biu_aw_vict_snoop;                  
output           lsu_biu_aw_vict_unique;                 
output           lsu_biu_aw_vict_user;                   
output  [127:0]  lsu_biu_cd_data;                        
output           lsu_biu_cd_last;                        
output           lsu_biu_cd_valid;                       
output  [4  :0]  lsu_biu_cr_resp;                        
output           lsu_biu_cr_valid;                       
output           lsu_biu_r_linefill_ready;               
output  [127:0]  lsu_biu_w_st_data;                      
output           lsu_biu_w_st_last;                      
output  [15 :0]  lsu_biu_w_st_strb;                      
output           lsu_biu_w_st_vld;                       
output           lsu_biu_w_st_wns;                       
output  [127:0]  lsu_biu_w_vict_data;                    
output           lsu_biu_w_vict_last;                    
output  [15 :0]  lsu_biu_w_vict_strb;                    
output           lsu_biu_w_vict_vld;                     
output           lsu_biu_w_vict_wns;                     
output  [183:0]  lsu_had_debug_info;                     
output  [39 :0]  lsu_had_ld_addr;                        
output  [63 :0]  lsu_had_ld_data;                        
output  [6  :0]  lsu_had_ld_iid;                         
output           lsu_had_ld_req;                         
output  [3  :0]  lsu_had_ld_type;                        
output           lsu_had_no_op;                          
output  [39 :0]  lsu_had_st_addr;                        
output  [63 :0]  lsu_had_st_data;                        
output  [6  :0]  lsu_had_st_iid;                         
output           lsu_had_st_req;                         
output  [3  :0]  lsu_had_st_type;                        
output           lsu_hpcp_cache_read_access;             
output           lsu_hpcp_cache_read_miss;               
output           lsu_hpcp_cache_write_access;            
output           lsu_hpcp_cache_write_miss;              
output           lsu_hpcp_fence_stall;                   
output           lsu_hpcp_ld_stall_cross_4k;             
output           lsu_hpcp_ld_stall_other;                
output           lsu_hpcp_replay_data_discard;           
output           lsu_hpcp_replay_discard_sq;             
output           lsu_hpcp_st_stall_cross_4k;             
output           lsu_hpcp_st_stall_other;                
output  [1  :0]  lsu_hpcp_unalign_inst;                  
output           lsu_mmu_abort0;                         
output           lsu_mmu_abort1;                         
output           lsu_mmu_bus_error;                      
output  [63 :0]  lsu_mmu_data;                           
output           lsu_mmu_data_vld;                       
output  [6  :0]  lsu_mmu_id0;                            
output  [6  :0]  lsu_mmu_id1;                            
output           lsu_mmu_st_inst0;                       
output           lsu_mmu_st_inst1;                       
output  [27 :0]  lsu_mmu_stamo_pa;                       
output           lsu_mmu_stamo_vld;                      
output           lsu_mmu_tlb_all_inv;                    
output  [15 :0]  lsu_mmu_tlb_asid;                       
output           lsu_mmu_tlb_asid_all_inv;               
output  [26 :0]  lsu_mmu_tlb_va;                         
output           lsu_mmu_tlb_va_all_inv;                 
output           lsu_mmu_tlb_va_asid_inv;                
output  [63 :0]  lsu_mmu_va0;                            
output           lsu_mmu_va0_vld;                        
output  [63 :0]  lsu_mmu_va1;                            
output           lsu_mmu_va1_vld;                        
output  [27 :0]  lsu_mmu_va2;                            
output           lsu_mmu_va2_vld;                        
output  [27 :0]  lsu_mmu_vabuf0;                         
output  [27 :0]  lsu_mmu_vabuf1;                         
output           rtu_cpu_no_retire;                      
output           rtu_had_bkpt_data_st;                   
output           rtu_had_data_bkpta_vld;                 
output           rtu_had_data_bkptb_vld;                 
output           rtu_had_dbg_ack_info;                   
output           rtu_had_dbgreq_ack;                     
output  [42 :0]  rtu_had_debug_info;                     
output           rtu_had_inst0_bkpt_inst;                
output  [3  :0]  rtu_had_inst0_non_irv_bkpt;             
output  [3  :0]  rtu_had_inst1_non_irv_bkpt;             
output  [3  :0]  rtu_had_inst2_non_irv_bkpt;             
output           rtu_had_inst_bkpt_inst_vld;             
output           rtu_had_inst_bkpta_vld;                 
output           rtu_had_inst_bkptb_vld;                 
output           rtu_had_inst_exe_dead;                  
output           rtu_had_inst_not_wb;                    
output           rtu_had_inst_split;                     
output  [63 :0]  rtu_had_retire_inst0_info;              
output           rtu_had_retire_inst0_vld;               
output  [63 :0]  rtu_had_retire_inst1_info;              
output           rtu_had_retire_inst1_vld;               
output  [63 :0]  rtu_had_retire_inst2_info;              
output           rtu_had_retire_inst2_vld;               
output           rtu_had_rob_empty;                      
output           rtu_had_xx_dbg_ack_pc;                  
output           rtu_had_xx_mbkpt_chgflow;               
output           rtu_had_xx_mbkpt_data_ack;              
output           rtu_had_xx_mbkpt_inst_ack;              
output  [38 :0]  rtu_had_xx_pc;                          
output           rtu_had_xx_pcfifo_inst0_chgflow;        
output           rtu_had_xx_pcfifo_inst0_condbr;         
output           rtu_had_xx_pcfifo_inst0_condbr_taken;   
output  [6  :0]  rtu_had_xx_pcfifo_inst0_iid;            
output           rtu_had_xx_pcfifo_inst0_jmp;            
output  [38 :0]  rtu_had_xx_pcfifo_inst0_next_pc;        
output           rtu_had_xx_pcfifo_inst0_pcall;          
output           rtu_had_xx_pcfifo_inst0_preturn;        
output           rtu_had_xx_pcfifo_inst1_chgflow;        
output           rtu_had_xx_pcfifo_inst1_condbr;         
output           rtu_had_xx_pcfifo_inst1_condbr_taken;   
output           rtu_had_xx_pcfifo_inst1_jmp;            
output  [38 :0]  rtu_had_xx_pcfifo_inst1_next_pc;        
output           rtu_had_xx_pcfifo_inst1_pcall;          
output           rtu_had_xx_pcfifo_inst1_preturn;        
output           rtu_had_xx_pcfifo_inst2_chgflow;        
output           rtu_had_xx_pcfifo_inst2_condbr;         
output           rtu_had_xx_pcfifo_inst2_condbr_taken;   
output           rtu_had_xx_pcfifo_inst2_jmp;            
output  [38 :0]  rtu_had_xx_pcfifo_inst2_next_pc;        
output           rtu_had_xx_pcfifo_inst2_pcall;          
output           rtu_had_xx_pcfifo_inst2_preturn;        
output           rtu_had_xx_split_inst;                  
output           rtu_hpcp_inst0_ack_int;                 
output           rtu_hpcp_inst0_bht_mispred;             
output           rtu_hpcp_inst0_condbr;                  
output  [39 :0]  rtu_hpcp_inst0_cur_pc;                  
output           rtu_hpcp_inst0_jmp;                     
output           rtu_hpcp_inst0_jmp_mispred;             
output           rtu_hpcp_inst0_jmp_pc_offset_8m;        
output  [1  :0]  rtu_hpcp_inst0_num;                     
output  [2  :0]  rtu_hpcp_inst0_pc_offset;               
output           rtu_hpcp_inst0_spec_fail;               
output           rtu_hpcp_inst0_split;                   
output           rtu_hpcp_inst0_store;                   
output           rtu_hpcp_inst0_vld;                     
output           rtu_hpcp_inst1_condbr;                  
output  [39 :0]  rtu_hpcp_inst1_cur_pc;                  
output           rtu_hpcp_inst1_jmp;                     
output           rtu_hpcp_inst1_jmp_pc_offset_8m;        
output  [1  :0]  rtu_hpcp_inst1_num;                     
output  [2  :0]  rtu_hpcp_inst1_pc_offset;               
output           rtu_hpcp_inst1_split;                   
output           rtu_hpcp_inst1_store;                   
output           rtu_hpcp_inst1_vld;                     
output           rtu_hpcp_inst2_condbr;                  
output  [39 :0]  rtu_hpcp_inst2_cur_pc;                  
output           rtu_hpcp_inst2_jmp;                     
output           rtu_hpcp_inst2_jmp_pc_offset_8m;        
output  [1  :0]  rtu_hpcp_inst2_num;                     
output  [2  :0]  rtu_hpcp_inst2_pc_offset;               
output           rtu_hpcp_inst2_split;                   
output           rtu_hpcp_inst2_store;                   
output           rtu_hpcp_inst2_vld;                     
output           rtu_hpcp_trace_inst0_chgflow;           
output  [38 :0]  rtu_hpcp_trace_inst0_next_pc;           
output           rtu_hpcp_trace_inst1_chgflow;           
output  [38 :0]  rtu_hpcp_trace_inst1_next_pc;           
output           rtu_hpcp_trace_inst2_chgflow;           
output  [38 :0]  rtu_hpcp_trace_inst2_next_pc;           
output  [26 :0]  rtu_mmu_bad_vpn;                        
output           rtu_mmu_expt_vld;                       
output           rtu_pad_retire0;                        
output  [39 :0]  rtu_pad_retire0_pc;                     
output           rtu_pad_retire1;                        
output  [39 :0]  rtu_pad_retire1_pc;                     
output           rtu_pad_retire2;                        
output  [39 :0]  rtu_pad_retire2_pc;                     
output           rtu_yy_xx_dbgon;                        
output           rtu_yy_xx_flush;                        
output           rtu_yy_xx_retire0;                      
output           rtu_yy_xx_retire0_normal;               
output           rtu_yy_xx_retire1;                      
output           rtu_yy_xx_retire2;                      

endmodule


