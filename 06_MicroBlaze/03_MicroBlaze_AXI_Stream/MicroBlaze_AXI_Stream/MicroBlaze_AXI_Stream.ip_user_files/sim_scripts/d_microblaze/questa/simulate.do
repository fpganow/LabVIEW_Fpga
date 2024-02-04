onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib d_microblaze_opt

do {wave.do}

view wave
view structure
view signals

do {d_microblaze.udo}

run -all

quit -force
