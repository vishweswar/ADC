vlib work 
vlog signalCaptureBlock.sv
vsim signalCaptureBlock

log {/*}
add wave {/*}


force {CLOCK_50} 0,1 10ns -r 20ns
force {Enable} 1


force {resetN} 1
run 25ns

force {resetN} 0 
run 25ns

force {resetN} 1
run 3000ns

