#!/usr/bin/env python3

import subprocess;

def ctrl_tb():
    subprocess.run("vlog -coveropt 3 +cover +acc control.sv control_tb.sv", shell = True)
    subprocess.run('vsim -coverage -vopt work.control_tb -c -do "coverage save -onexit -directive -codeAll control.ucdb; run -all; exit"', shell = True)
    subprocess.run('vsim -c -do "vcover report -details -html control.ucdb; exit"', shell = True)
    subprocess.run('mv ./covhtmlreport ./ctrl_coverage', shell =  True)

def ext_tb():
    subprocess.run("vlog -coveropt 3 +cover +acc extend_15.sv extend_tb.sv", shell = True)
    subprocess.run('vsim -coverage -vopt work.extend_tb -c -do "coverage save -onexit -directive -codeAll extend.ucdb; run -all; exit"', shell = True)
    subprocess.run('vsim -c -do "vcover report -details -html extend.ucdb; exit"', shell = True)
    subprocess.run('mv ./covhtmlreport ./ext_coverage', shell =  True)

def rf_tb():
    subprocess.run("vlog -coveropt 3 +cover +acc rf.sv rf_tb.sv", shell = True)
    subprocess.run('vsim -coverage -vopt work.rf_tb -c -do "coverage save -onexit -directive -codeAll rf.ucdb; run -all"', shell = True)
    subprocess.run('vsim -c -do "vcover report -details -html rf.ucdb; exit"', shell = True)
    subprocess.run('mv ./covhtmlreport ./rf_coverage', shell =  True)

    
if __name__ == '__main__':
    ctrl_tb()
    ext_tb()
    rf_tb()
    
