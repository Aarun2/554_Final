#!/usr/bin/env python3

import subprocess;

def ctrl_tb():
    subprocess.run("vlog -work work control.sv control_tb.sv", shell = True)
    subprocess.run("vsim -c work.control_tb -do run.do", shell = True)

def ext_tb():
    subprocess.run("vlog -work work extend_15.sv extend_tb.sv", shell = True)
    subprocess.run("vsim -c work.extend_tb -do run.do", shell = True)

def rf_tb():
    subprocess.run("vlog -work work rf.sv rf_tb.sv", shell = True)
    subprocess.run("vsim -c work.rf_tb -do run.do", shell = True)
    
if __name__ == '__main__':
    ctrl_tb()
    ext_tb()
    rf_tb()
    