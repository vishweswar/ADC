vlib work 
vlog signalCaptureBlock.v
vsim signalCaptureBlock

log {/*}
add wave {/*}


force {clkCounterEn} 0
run 10ns

force {clkCounterEn} 1
force {CLOCK_50} 0,1 10ns -r 20ns
run 500ns  

