transcript on
if {[file exists gate_work]} {
	vdel -lib gate_work -all
}
vlib gate_work
vmap work gate_work

vlog -sv -work work +incdir+. {single_cycle_processor_32bit_top.svo}

vlog -sv -work work +incdir+/home/hiu/Documents/Thiet_ke_so_va_vi_xu_ly/final_term_project/test_bench {/home/hiu/Documents/Thiet_ke_so_va_vi_xu_ly/final_term_project/test_bench/tb_single_cycle_processor.sv}

vsim -t 1ps -L altera_ver -L altera_lnsim_ver -L fiftyfivenm_ver -L gate_work -L work -voptargs="+acc"  tb_single_cycle_processor

add wave *
view structure
view signals
run -all
