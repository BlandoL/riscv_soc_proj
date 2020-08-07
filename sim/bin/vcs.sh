#! /bin/bash

# general script for simulation

fsdbfile=top.fsdb
rtl_file_list=../bin/rtl.flist
#rtc_file_list=../bin/rtc.flist
#nls_file_list=../bin/nls.flist
#pmu_file_list=../bin/pmu.flist
#fpga_file_list=../bin/fpga.flist

file_list=$rtl_file_list

# format parameter define
para="";
opentimingcheck=notimingcheck;
gui_mode=0;
for i in $@; do
	if [ $i == "gui" ]; then
		gui_mode=1;
	elif [ $i == "rtc" ]; then
		file_list=$rtc_file_list;
	elif [ $i == "pmu_nls" ]; then
		file_list=$pmu_file_list;
		opentimingcheck="";
	elif [ $i == "nls" ]; then
		file_list=$nls_file_list;
		oentimingcheck="";
		fsdbfile=project_nls.fsdb;
	elif [ $i == "FPGA" ]; then
		file_list=$fpga_file_list;
	fi
	para=${i}"+"${para};
done

echo ""
echo ""
echo "DEFINE PARAMETER: $para";
echo "opentimingcheck: $opentimingcheck"
echo ""
echo ""
sleep 0.3

if [ $gui_mode == 1 ]; then
#	verdi -sv +define+$para -f $file_list -f $bt_rtl_flist -ssf $fsdbfile -nologo &
	verdi -2005 -sv +define+$para -f $file_list -ssf $fsdbfile -nologo &
	exit
fi

vcs \
	-R \
	-Mupdate \
	+plusarg_save \
	+ntb_random_seed_automatic \
	-P /eda/verdi/verdi3_2012/share/PLI/VCS/LINUX/novas.tab \
	/eda/verdi/verdi3_2012/share/PLI/VCS/LINUX/pli.a \
	+v2k \
	-assert svaext \
	-cm assert \
	+vpi \
	+neg_tchk \
	-negdelay \
	-lca \
	+sdfverbose \
	+$opentimingcheck \
	-sverilog \
	+define+$para \
	-timescale=1ns/1ps \
	-debug_all \
	-f $file_list \
	-l vcs.log

