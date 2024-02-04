@echo off
set xv_path=C:\\NIFPGA\\programs\\Vivado2015_4\\bin
call %xv_path%/xsim d_microblaze_wrapper_tb_behav -key {Behavioral:sim_1:Functional:d_microblaze_wrapper_tb} -tclbatch d_microblaze_wrapper_tb.tcl -log simulate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
