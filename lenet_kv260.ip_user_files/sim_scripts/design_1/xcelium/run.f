-makelib xcelium_lib/xilinx_vip -sv \
  "D:/vivado2022.2/Vivado/2022.2/data/xilinx_vip/hdl/axi4stream_vip_axi4streampc.sv" \
  "D:/vivado2022.2/Vivado/2022.2/data/xilinx_vip/hdl/axi_vip_axi4pc.sv" \
  "D:/vivado2022.2/Vivado/2022.2/data/xilinx_vip/hdl/xil_common_vip_pkg.sv" \
  "D:/vivado2022.2/Vivado/2022.2/data/xilinx_vip/hdl/axi4stream_vip_pkg.sv" \
  "D:/vivado2022.2/Vivado/2022.2/data/xilinx_vip/hdl/axi_vip_pkg.sv" \
  "D:/vivado2022.2/Vivado/2022.2/data/xilinx_vip/hdl/axi4stream_vip_if.sv" \
  "D:/vivado2022.2/Vivado/2022.2/data/xilinx_vip/hdl/axi_vip_if.sv" \
  "D:/vivado2022.2/Vivado/2022.2/data/xilinx_vip/hdl/clk_vip_if.sv" \
  "D:/vivado2022.2/Vivado/2022.2/data/xilinx_vip/hdl/rst_vip_if.sv" \
-endlib
-makelib xcelium_lib/xpm -sv \
  "D:/vivado2022.2/Vivado/2022.2/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
  "D:/vivado2022.2/Vivado/2022.2/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \
-endlib
-makelib xcelium_lib/xpm \
  "D:/vivado2022.2/Vivado/2022.2/data/ip/xpm/xpm_VCOMP.vhd" \
-endlib
-makelib xcelium_lib/axi_infrastructure_v1_1_0 \
  "../../../../lenet_kv260.gen/sources_1/bd/design_1/ipshared/ec67/hdl/axi_infrastructure_v1_1_vl_rfs.v" \
-endlib
-makelib xcelium_lib/axi_vip_v1_1_13 -sv \
  "../../../../lenet_kv260.gen/sources_1/bd/design_1/ipshared/ffc2/hdl/axi_vip_v1_1_vl_rfs.sv" \
-endlib
-makelib xcelium_lib/zynq_ultra_ps_e_vip_v1_0_13 -sv \
  "../../../../lenet_kv260.gen/sources_1/bd/design_1/ipshared/abef/hdl/zynq_ultra_ps_e_vip_v1_0_vl_rfs.sv" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../bd/design_1/ip/design_1_zynq_ultra_ps_e_0_0/sim/design_1_zynq_ultra_ps_e_0_0_vip_wrapper.v" \
-endlib
-makelib xcelium_lib/lib_cdc_v1_0_2 \
  "../../../../lenet_kv260.gen/sources_1/bd/design_1/ipshared/ef1e/hdl/lib_cdc_v1_0_rfs.vhd" \
-endlib
-makelib xcelium_lib/proc_sys_reset_v5_0_13 \
  "../../../../lenet_kv260.gen/sources_1/bd/design_1/ipshared/8842/hdl/proc_sys_reset_v5_0_vh_rfs.vhd" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../bd/design_1/ip/design_1_rst_ps8_0_99M_0/sim/design_1_rst_ps8_0_99M_0.vhd" \
-endlib
-makelib xcelium_lib/generic_baseblocks_v2_1_0 \
  "../../../../lenet_kv260.gen/sources_1/bd/design_1/ipshared/b752/hdl/generic_baseblocks_v2_1_vl_rfs.v" \
-endlib
-makelib xcelium_lib/axi_register_slice_v2_1_27 \
  "../../../../lenet_kv260.gen/sources_1/bd/design_1/ipshared/f0b4/hdl/axi_register_slice_v2_1_vl_rfs.v" \
-endlib
-makelib xcelium_lib/fifo_generator_v13_2_7 \
  "../../../../lenet_kv260.gen/sources_1/bd/design_1/ipshared/83df/simulation/fifo_generator_vlog_beh.v" \
-endlib
-makelib xcelium_lib/fifo_generator_v13_2_7 \
  "../../../../lenet_kv260.gen/sources_1/bd/design_1/ipshared/83df/hdl/fifo_generator_v13_2_rfs.vhd" \
-endlib
-makelib xcelium_lib/fifo_generator_v13_2_7 \
  "../../../../lenet_kv260.gen/sources_1/bd/design_1/ipshared/83df/hdl/fifo_generator_v13_2_rfs.v" \
-endlib
-makelib xcelium_lib/axi_data_fifo_v2_1_26 \
  "../../../../lenet_kv260.gen/sources_1/bd/design_1/ipshared/3111/hdl/axi_data_fifo_v2_1_vl_rfs.v" \
-endlib
-makelib xcelium_lib/axi_crossbar_v2_1_28 \
  "../../../../lenet_kv260.gen/sources_1/bd/design_1/ipshared/c40e/hdl/axi_crossbar_v2_1_vl_rfs.v" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../bd/design_1/ip/design_1_xbar_2/sim/design_1_xbar_2.v" \
  "../../../bd/design_1/sim/design_1.v" \
-endlib
-makelib xcelium_lib/axi_protocol_converter_v2_1_27 \
  "../../../../lenet_kv260.gen/sources_1/bd/design_1/ipshared/aeb3/hdl/axi_protocol_converter_v2_1_vl_rfs.v" \
-endlib
-makelib xcelium_lib/axi_clock_converter_v2_1_26 \
  "../../../../lenet_kv260.gen/sources_1/bd/design_1/ipshared/b8be/hdl/axi_clock_converter_v2_1_vl_rfs.v" \
-endlib
-makelib xcelium_lib/blk_mem_gen_v8_4_5 \
  "../../../../lenet_kv260.gen/sources_1/bd/design_1/ipshared/25a8/simulation/blk_mem_gen_v8_4.v" \
-endlib
-makelib xcelium_lib/axi_dwidth_converter_v2_1_27 \
  "../../../../lenet_kv260.gen/sources_1/bd/design_1/ipshared/4675/hdl/axi_dwidth_converter_v2_1_vl_rfs.v" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../bd/design_1/ip/design_1_auto_ds_0/sim/design_1_auto_ds_0.v" \
  "../../../bd/design_1/ip/design_1_auto_pc_0/sim/design_1_auto_pc_0.v" \
  "../../../bd/design_1/ip/design_1_auto_us_0/sim/design_1_auto_us_0.v" \
  "../../../bd/design_1/ip/design_1_auto_us_1/sim/design_1_auto_us_1.v" \
  "../../../bd/design_1/ip/design_1_Accelerator_1_0/src/fifo_generator_0/sim/fifo_generator_0.v" \
-endlib
-makelib xcelium_lib/xbip_utils_v3_0_10 \
  "../../../../lenet_kv260.gen/sources_1/bd/design_1/ip/design_1_Accelerator_1_0/src/multiplier/hdl/xbip_utils_v3_0_vh_rfs.vhd" \
-endlib
-makelib xcelium_lib/xbip_pipe_v3_0_6 \
  "../../../../lenet_kv260.gen/sources_1/bd/design_1/ip/design_1_Accelerator_1_0/src/multiplier/hdl/xbip_pipe_v3_0_vh_rfs.vhd" \
-endlib
-makelib xcelium_lib/xbip_bram18k_v3_0_6 \
  "../../../../lenet_kv260.gen/sources_1/bd/design_1/ip/design_1_Accelerator_1_0/src/multiplier/hdl/xbip_bram18k_v3_0_vh_rfs.vhd" \
-endlib
-makelib xcelium_lib/mult_gen_v12_0_18 \
  "../../../../lenet_kv260.gen/sources_1/bd/design_1/ip/design_1_Accelerator_1_0/src/multiplier/hdl/mult_gen_v12_0_vh_rfs.vhd" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../bd/design_1/ip/design_1_Accelerator_1_0/src/multiplier/sim/multiplier.vhd" \
-endlib
-makelib xcelium_lib/c_reg_fd_v12_0_6 \
  "../../../../lenet_kv260.gen/sources_1/bd/design_1/ip/design_1_Accelerator_1_0/src/pooling_shift/hdl/c_reg_fd_v12_0_vh_rfs.vhd" \
-endlib
-makelib xcelium_lib/c_mux_bit_v12_0_6 \
  "../../../../lenet_kv260.gen/sources_1/bd/design_1/ip/design_1_Accelerator_1_0/src/pooling_shift/hdl/c_mux_bit_v12_0_vh_rfs.vhd" \
-endlib
-makelib xcelium_lib/c_shift_ram_v12_0_14 \
  "../../../../lenet_kv260.gen/sources_1/bd/design_1/ip/design_1_Accelerator_1_0/src/pooling_shift/hdl/c_shift_ram_v12_0_vh_rfs.vhd" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../bd/design_1/ip/design_1_Accelerator_1_0/src/pooling_shift/sim/pooling_shift.vhd" \
-endlib
-makelib xcelium_lib/dist_mem_gen_v8_0_13 \
  "../../../../lenet_kv260.gen/sources_1/bd/design_1/ip/design_1_Accelerator_1_0/src/ROM_data/simulation/dist_mem_gen_v8_0.v" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../bd/design_1/ip/design_1_Accelerator_1_0/src/ROM_data/sim/ROM_data.v" \
  "../../../bd/design_1/ip/design_1_Accelerator_1_0/src/RAM_ip/sim/RAM_ip.v" \
  "../../../bd/design_1/ip/design_1_Accelerator_1_0/src/ROM_weight/sim/ROM_weight.v" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../bd/design_1/ip/design_1_Accelerator_1_0/src/pooling_shift_1/sim/pooling_shift_1.vhd" \
-endlib
-makelib xcelium_lib/xbip_dsp48_wrapper_v3_0_4 \
  "../../../../lenet_kv260.gen/sources_1/bd/design_1/ip/design_1_Accelerator_1_0/src/adder/hdl/xbip_dsp48_wrapper_v3_0_vh_rfs.vhd" \
-endlib
-makelib xcelium_lib/xbip_dsp48_addsub_v3_0_6 \
  "../../../../lenet_kv260.gen/sources_1/bd/design_1/ip/design_1_Accelerator_1_0/src/adder/hdl/xbip_dsp48_addsub_v3_0_vh_rfs.vhd" \
-endlib
-makelib xcelium_lib/xbip_addsub_v3_0_6 \
  "../../../../lenet_kv260.gen/sources_1/bd/design_1/ip/design_1_Accelerator_1_0/src/adder/hdl/xbip_addsub_v3_0_vh_rfs.vhd" \
-endlib
-makelib xcelium_lib/c_addsub_v12_0_14 \
  "../../../../lenet_kv260.gen/sources_1/bd/design_1/ip/design_1_Accelerator_1_0/src/adder/hdl/c_addsub_v12_0_vh_rfs.vhd" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../bd/design_1/ip/design_1_Accelerator_1_0/src/adder/sim/adder.vhd" \
  "../../../bd/design_1/ip/design_1_Accelerator_1_0/src/shift_ram/sim/shift_ram.vhd" \
  "../../../bd/design_1/ip/design_1_Accelerator_1_0/src/multiplier_fc/sim/multiplier_fc.vhd" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../bd/design_1/ip/design_1_Accelerator_1_0/src/fifo_FClayer/sim/fifo_FClayer.v" \
  "../../../bd/design_1/ip/design_1_Accelerator_1_0/src/bram_fcweight/sim/bram_fcweight.v" \
  "../../../bd/design_1/ip/design_1_Accelerator_1_0/src/ROM_bias/sim/ROM_bias.v" \
-endlib
-makelib xcelium_lib/xbip_dsp48_acc_v3_0_6 \
  "../../../../lenet_kv260.gen/sources_1/bd/design_1/ip/design_1_Accelerator_1_0/src/accum/hdl/xbip_dsp48_acc_v3_0_vh_rfs.vhd" \
-endlib
-makelib xcelium_lib/xbip_accum_v3_0_6 \
  "../../../../lenet_kv260.gen/sources_1/bd/design_1/ip/design_1_Accelerator_1_0/src/accum/hdl/xbip_accum_v3_0_vh_rfs.vhd" \
-endlib
-makelib xcelium_lib/c_accum_v12_0_14 \
  "../../../../lenet_kv260.gen/sources_1/bd/design_1/ip/design_1_Accelerator_1_0/src/accum/hdl/c_accum_v12_0_vh_rfs.vhd" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../bd/design_1/ip/design_1_Accelerator_1_0/src/accum/sim/accum.vhd" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../bd/design_1/ip/design_1_Accelerator_1_0/src/bram_layer2/sim/bram_layer2.v" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../bd/design_1/ip/design_1_Accelerator_1_0/src/shift_ram_1/sim/shift_ram_1.vhd" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../bd/design_1/ipshared/65d0/src/Acc_Controller.v" \
  "../../../bd/design_1/ipshared/65d0/src/Bias_input.v" \
  "../../../bd/design_1/ipshared/65d0/src/ConvPE.v" \
  "../../../bd/design_1/ipshared/65d0/src/ConvPE_list.v" \
  "../../../bd/design_1/ipshared/65d0/src/Layer_buffer.v" \
  "../../../bd/design_1/ipshared/65d0/src/Relu_MaxPooling.v" \
  "../../../bd/design_1/ipshared/65d0/src/Relu_MaxPooling_list.v" \
  "../../../bd/design_1/ipshared/65d0/src/Win_input.v" \
  "../../../bd/design_1/ipshared/65d0/src/adder.v" \
  "../../../bd/design_1/ipshared/65d0/src/adderTree.v" \
  "../../../bd/design_1/ipshared/65d0/src/dataCorrect.v" \
  "../../../bd/design_1/ipshared/65d0/src/dataShift.v" \
  "../../../bd/design_1/ipshared/65d0/src/multMatrix.v" \
  "../../../bd/design_1/ipshared/65d0/src/multiplier.v" \
  "../../../bd/design_1/ipshared/65d0/src/weightShift.v" \
  "../../../bd/design_1/ipshared/65d0/src/Conv_layer.v" \
  "../../../bd/design_1/ipshared/65d0/src/FClayer_buffer.v" \
  "../../../bd/design_1/ipshared/65d0/src/Multiplier_List.v" \
  "../../../bd/design_1/ipshared/65d0/src/FC_layer.v" \
  "../../../bd/design_1/ipshared/65d0/src/multiplier_fc.v" \
  "../../../bd/design_1/ipshared/65d0/src/Accelerator.v" \
  "../../../bd/design_1/ip/design_1_Accelerator_1_0/sim/design_1_Accelerator_1_0.v" \
  "../../../bd/design_1/ip/design_1_DMA_Controller_0_1/src/fifo_data/sim/fifo_data.v" \
  "../../../bd/design_1/ip/design_1_DMA_Controller_0_1/src/fifo_dataout/sim/fifo_dataout.v" \
  "../../../bd/design_1/ipshared/df45/src/AXI_HP_MAster_Transceiver.v" \
  "../../../bd/design_1/ipshared/df45/src/AXI_HP_Master_Burst_Transceiver.v" \
  "../../../bd/design_1/ipshared/df45/src/Controller.v" \
  "../../../bd/design_1/ipshared/df45/src/OutputFIFO.v" \
  "../../../bd/design_1/ipshared/df45/src/dataFIFO.v" \
  "../../../bd/design_1/ipshared/df45/src/DMA_Controller.v" \
  "../../../bd/design_1/ip/design_1_DMA_Controller_0_1/sim/design_1_DMA_Controller_0_1.v" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  glbl.v
-endlib

