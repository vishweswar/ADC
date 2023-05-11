vlib work 
vlog signalCaptureBlock.v
vsim signalCaptureBlock

log {/*}
add wave {/*}


force {CLOCK_50} 0,1 10ns -r 20ns

force {resetN} 0
force {clkCounterEn} 0
run 25ns

force {clkCounterEn} 1
run 10ns

force {resetN} 1
run 1000ns

