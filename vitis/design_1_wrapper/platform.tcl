# 
# Usage: To re-create this platform project launch xsct with below options.
# xsct C:\Users\zhengzb\Desktop\project\kv260\lenet_kv260\vitis\design_1_wrapper\platform.tcl
# 
# OR launch xsct and run below command.
# source C:\Users\zhengzb\Desktop\project\kv260\lenet_kv260\vitis\design_1_wrapper\platform.tcl
# 
# To create the platform in a different location, modify the -out option of "platform create" command.
# -out option specifies the output directory of the platform project.

platform create -name {design_1_wrapper}\
-hw {C:\Users\zhengzb\Desktop\project\kv260\lenet_kv260\design_1_wrapper.xsa}\
-arch {64-bit} -fsbl-target {psu_cortexa53_0} -out {C:/Users/zhengzb/Desktop/project/kv260/lenet_kv260/vitis}

platform write
domain create -name {standalone_psu_cortexa53_0} -display-name {standalone_psu_cortexa53_0} -os {standalone} -proc {psu_cortexa53_0} -runtime {cpp} -arch {64-bit} -support-app {hello_world}
platform generate -domains 
platform active {design_1_wrapper}
domain active {zynqmp_fsbl}
domain active {zynqmp_pmufw}
domain active {standalone_psu_cortexa53_0}
platform generate -quick
platform generate

proc boot_jtag { } {
############################
# Switch to JTAG boot mode #
############################
targets -set -filter {name =~ "PSU"}
# update multiboot to ZERO
mwr 0xffca0010 0x0
# change boot mode to JTAG
mwr 0xff5e0200 0x0100
# reset
rst -system
}