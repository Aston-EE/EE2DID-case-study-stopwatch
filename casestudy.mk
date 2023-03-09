display_testbench: display.vhd display_testbench.vhd
stopwatch_ssm_testbench: stopwatch_ssm.vhd stopwatch_ssm_testbench.vhd
timer_testbench: EE2IDD.vhd counter.vhd timer.vhd timer_testbench.vhd
stopwatch.bit stopwatch.bin: EE2IDD.vhd stopwatch.vhd clk_prescaler.vhd counter.vhd display.vhd debounce.vhd stopwatch_ssm.vhd timer.vhd
timer.check: EE2IDD.vhd timer.vhd