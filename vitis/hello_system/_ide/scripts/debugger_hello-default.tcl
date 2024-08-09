# Usage with Vitis IDE:
# In Vitis IDE create a Single Application Debug launch configuration,
# change the debug type to 'Attach to running target' and provide this 
# tcl script in 'Execute Script' option.
# Path of this script: C:\Users\yeshe\Desktop\rep\code\lenet_kv260\vitis\hello_system\_ide\scripts\debugger_hello-default.tcl
# 
# 
# Usage with xsct:
# To debug using xsct, launch xsct and run below command
# source C:\Users\yeshe\Desktop\rep\code\lenet_kv260\vitis\hello_system\_ide\scripts\debugger_hello-default.tcl
# 
connect -url tcp:127.0.0.1:3121
source D:/vivado2022.2/Vitis/2022.2/scripts/vitis/util/zynqmp_utils.tcl
targets -set -nocase -filter {name =~"APU*"}
rst -system
after 3000
targets -set -filter {jtag_cable_name =~ "Xilinx X-MLCC-01 XFL1NV1MN4ZKA" && level==0 && jtag_device_ctx=="jsn-X-MLCC-01-XFL1NV1MN4ZKA-04724093-0"}
fpga -file C:/Users/yeshe/Desktop/rep/code/lenet_kv260/vitis/hello/_ide/bitstream/design_2_wrapper.bit
targets -set -nocase -filter {name =~"APU*"}
loadhw -hw C:/Users/yeshe/Desktop/rep/code/lenet_kv260/vitis/design_2_wrapper/export/design_2_wrapper/hw/design_2_wrapper.xsa -mem-ranges [list {0x80000000 0xbfffffff} {0x400000000 0x5ffffffff} {0x1000000000 0x7fffffffff}] -regs
configparams force-mem-access 1
targets -set -nocase -filter {name =~"APU*"}
set mode [expr [mrd -value 0xFF5E0200] & 0xf]
targets -set -nocase -filter {name =~ "*A53*#0"}
rst -processor
dow C:/Users/yeshe/Desktop/rep/code/lenet_kv260/vitis/design_2_wrapper/export/design_2_wrapper/sw/design_2_wrapper/boot/fsbl.elf
set bp_50_56_fsbl_bp [bpadd -addr &XFsbl_Exit]
con -block -timeout 60
bpremove $bp_50_56_fsbl_bp
targets -set -nocase -filter {name =~ "*A53*#0"}
rst -processor
dow C:/Users/yeshe/Desktop/rep/code/lenet_kv260/vitis/hello/Debug/hello.elf
configparams force-mem-access 0
targets -set -nocase -filter {name =~ "*A53*#0"}
con
