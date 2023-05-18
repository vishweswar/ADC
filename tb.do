vlib testbenchresults
vlog testbench.sv
vsim testbench

log {/*}
add wave {/*} 

force {CLOCK_50} 0,1 10ns -r 20ns
run 6000ns
