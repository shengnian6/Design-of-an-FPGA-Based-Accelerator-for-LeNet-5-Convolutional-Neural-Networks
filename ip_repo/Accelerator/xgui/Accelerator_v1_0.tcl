# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "ConvPE_latency" -parent ${Page_0}
  ipgui::add_param $IPINST -name "Maxpooling_latency" -parent ${Page_0}
  ipgui::add_param $IPINST -name "PE_Num" -parent ${Page_0}
  ipgui::add_param $IPINST -name "conv_size" -parent ${Page_0}
  ipgui::add_param $IPINST -name "conv_strides" -parent ${Page_0}
  ipgui::add_param $IPINST -name "dwidth" -parent ${Page_0}
  ipgui::add_param $IPINST -name "featmap1_size" -parent ${Page_0}
  ipgui::add_param $IPINST -name "featmap2_size" -parent ${Page_0}
  ipgui::add_param $IPINST -name "featmap3_size" -parent ${Page_0}
  ipgui::add_param $IPINST -name "featmap4_size" -parent ${Page_0}
  ipgui::add_param $IPINST -name "featmap5_size" -parent ${Page_0}
  ipgui::add_param $IPINST -name "pooling_size" -parent ${Page_0}
  ipgui::add_param $IPINST -name "pooling_strides" -parent ${Page_0}
  ipgui::add_param $IPINST -name "qwidth" -parent ${Page_0}


}

proc update_PARAM_VALUE.ConvPE_latency { PARAM_VALUE.ConvPE_latency } {
	# Procedure called to update ConvPE_latency when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ConvPE_latency { PARAM_VALUE.ConvPE_latency } {
	# Procedure called to validate ConvPE_latency
	return true
}

proc update_PARAM_VALUE.Maxpooling_latency { PARAM_VALUE.Maxpooling_latency } {
	# Procedure called to update Maxpooling_latency when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.Maxpooling_latency { PARAM_VALUE.Maxpooling_latency } {
	# Procedure called to validate Maxpooling_latency
	return true
}

proc update_PARAM_VALUE.PE_Num { PARAM_VALUE.PE_Num } {
	# Procedure called to update PE_Num when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.PE_Num { PARAM_VALUE.PE_Num } {
	# Procedure called to validate PE_Num
	return true
}

proc update_PARAM_VALUE.conv_size { PARAM_VALUE.conv_size } {
	# Procedure called to update conv_size when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.conv_size { PARAM_VALUE.conv_size } {
	# Procedure called to validate conv_size
	return true
}

proc update_PARAM_VALUE.conv_strides { PARAM_VALUE.conv_strides } {
	# Procedure called to update conv_strides when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.conv_strides { PARAM_VALUE.conv_strides } {
	# Procedure called to validate conv_strides
	return true
}

proc update_PARAM_VALUE.dwidth { PARAM_VALUE.dwidth } {
	# Procedure called to update dwidth when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.dwidth { PARAM_VALUE.dwidth } {
	# Procedure called to validate dwidth
	return true
}

proc update_PARAM_VALUE.featmap1_size { PARAM_VALUE.featmap1_size } {
	# Procedure called to update featmap1_size when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.featmap1_size { PARAM_VALUE.featmap1_size } {
	# Procedure called to validate featmap1_size
	return true
}

proc update_PARAM_VALUE.featmap2_size { PARAM_VALUE.featmap2_size } {
	# Procedure called to update featmap2_size when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.featmap2_size { PARAM_VALUE.featmap2_size } {
	# Procedure called to validate featmap2_size
	return true
}

proc update_PARAM_VALUE.featmap3_size { PARAM_VALUE.featmap3_size } {
	# Procedure called to update featmap3_size when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.featmap3_size { PARAM_VALUE.featmap3_size } {
	# Procedure called to validate featmap3_size
	return true
}

proc update_PARAM_VALUE.featmap4_size { PARAM_VALUE.featmap4_size } {
	# Procedure called to update featmap4_size when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.featmap4_size { PARAM_VALUE.featmap4_size } {
	# Procedure called to validate featmap4_size
	return true
}

proc update_PARAM_VALUE.featmap5_size { PARAM_VALUE.featmap5_size } {
	# Procedure called to update featmap5_size when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.featmap5_size { PARAM_VALUE.featmap5_size } {
	# Procedure called to validate featmap5_size
	return true
}

proc update_PARAM_VALUE.pooling_size { PARAM_VALUE.pooling_size } {
	# Procedure called to update pooling_size when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.pooling_size { PARAM_VALUE.pooling_size } {
	# Procedure called to validate pooling_size
	return true
}

proc update_PARAM_VALUE.pooling_strides { PARAM_VALUE.pooling_strides } {
	# Procedure called to update pooling_strides when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.pooling_strides { PARAM_VALUE.pooling_strides } {
	# Procedure called to validate pooling_strides
	return true
}

proc update_PARAM_VALUE.qwidth { PARAM_VALUE.qwidth } {
	# Procedure called to update qwidth when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.qwidth { PARAM_VALUE.qwidth } {
	# Procedure called to validate qwidth
	return true
}


proc update_MODELPARAM_VALUE.dwidth { MODELPARAM_VALUE.dwidth PARAM_VALUE.dwidth } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.dwidth}] ${MODELPARAM_VALUE.dwidth}
}

proc update_MODELPARAM_VALUE.qwidth { MODELPARAM_VALUE.qwidth PARAM_VALUE.qwidth } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.qwidth}] ${MODELPARAM_VALUE.qwidth}
}

proc update_MODELPARAM_VALUE.featmap1_size { MODELPARAM_VALUE.featmap1_size PARAM_VALUE.featmap1_size } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.featmap1_size}] ${MODELPARAM_VALUE.featmap1_size}
}

proc update_MODELPARAM_VALUE.featmap2_size { MODELPARAM_VALUE.featmap2_size PARAM_VALUE.featmap2_size } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.featmap2_size}] ${MODELPARAM_VALUE.featmap2_size}
}

proc update_MODELPARAM_VALUE.featmap3_size { MODELPARAM_VALUE.featmap3_size PARAM_VALUE.featmap3_size } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.featmap3_size}] ${MODELPARAM_VALUE.featmap3_size}
}

proc update_MODELPARAM_VALUE.featmap4_size { MODELPARAM_VALUE.featmap4_size PARAM_VALUE.featmap4_size } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.featmap4_size}] ${MODELPARAM_VALUE.featmap4_size}
}

proc update_MODELPARAM_VALUE.featmap5_size { MODELPARAM_VALUE.featmap5_size PARAM_VALUE.featmap5_size } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.featmap5_size}] ${MODELPARAM_VALUE.featmap5_size}
}

proc update_MODELPARAM_VALUE.conv_size { MODELPARAM_VALUE.conv_size PARAM_VALUE.conv_size } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.conv_size}] ${MODELPARAM_VALUE.conv_size}
}

proc update_MODELPARAM_VALUE.pooling_size { MODELPARAM_VALUE.pooling_size PARAM_VALUE.pooling_size } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.pooling_size}] ${MODELPARAM_VALUE.pooling_size}
}

proc update_MODELPARAM_VALUE.conv_strides { MODELPARAM_VALUE.conv_strides PARAM_VALUE.conv_strides } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.conv_strides}] ${MODELPARAM_VALUE.conv_strides}
}

proc update_MODELPARAM_VALUE.pooling_strides { MODELPARAM_VALUE.pooling_strides PARAM_VALUE.pooling_strides } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.pooling_strides}] ${MODELPARAM_VALUE.pooling_strides}
}

proc update_MODELPARAM_VALUE.ConvPE_latency { MODELPARAM_VALUE.ConvPE_latency PARAM_VALUE.ConvPE_latency } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ConvPE_latency}] ${MODELPARAM_VALUE.ConvPE_latency}
}

proc update_MODELPARAM_VALUE.Maxpooling_latency { MODELPARAM_VALUE.Maxpooling_latency PARAM_VALUE.Maxpooling_latency } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.Maxpooling_latency}] ${MODELPARAM_VALUE.Maxpooling_latency}
}

proc update_MODELPARAM_VALUE.PE_Num { MODELPARAM_VALUE.PE_Num PARAM_VALUE.PE_Num } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PE_Num}] ${MODELPARAM_VALUE.PE_Num}
}

