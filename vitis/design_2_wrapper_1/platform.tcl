# 
# Usage: To re-create this platform project launch xsct with below options.
# xsct C:\Users\yeshe\Desktop\rep\code\lenet_kv260\vitis\design_2_wrapper_1\platform.tcl
# 
# OR launch xsct and run below command.
# source C:\Users\yeshe\Desktop\rep\code\lenet_kv260\vitis\design_2_wrapper_1\platform.tcl
# 
# To create the platform in a different location, modify the -out option of "platform create" command.
# -out option specifies the output directory of the platform project.

platform create -name {design_2_wrapper_1}\
-hw {C:\Users\yeshe\Desktop\rep\code\lenet_kv260\design_2_wrapper.xsa}\
-arch {64-bit} -fsbl-target {psu_cortexa53_0} -out {C:/Users/yeshe/Desktop/rep/code/lenet_kv260/vitis}

platform write
domain create -name {standalone_psu_cortexa53_0} -display-name {standalone_psu_cortexa53_0} -os {standalone} -proc {psu_cortexa53_0} -runtime {cpp} -arch {64-bit} -support-app {hello_world}
platform generate -domains 
platform active {design_2_wrapper_1}
domain active {zynqmp_fsbl}
domain active {zynqmp_pmufw}
domain active {standalone_psu_cortexa53_0}
platform generate -quick
platform generate
platform generate
