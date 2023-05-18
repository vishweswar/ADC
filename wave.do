vlib work 
vlog signalCaptureBlock.sv
vsim signalCaptureBlock

log {/*}
add wave {/*}


force {CLOCK_50} 0,1 10ns -r 20ns
force {Enable} 1

force {channelSelect[2]} 1
force {channelSelect[1]} 0
force {channelSelect[0]} 0

force {SCLKresetN} 1
run 25ns

force {SCLKresetN} 0
run 50ns

force {SCLKresetN} 1

force {resetN} 1
run 25ns

force {resetN} 0
run 50ns

force {resetN} 1
run 3000ns

