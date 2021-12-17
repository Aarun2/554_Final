#!/usr/bin/env python3
from configparser import ConfigParser
import subprocess
import re

parser = ConfigParser()
parser.read('reg_tb_unit.ini')

for section in parser.sections():
    rel_path = parser.get(section, 'path_relative')
    # First command vlog maps the files to work directory
    vlog_cmd = "vlog -coveropt 3 +cover +acc"
    dependencies = re.split("[\n,]", parser.get(section, 'dependencies'))
    for dependency in dependencies:
        vlog_cmd += " " + rel_path + dependency
    # Second command vsim with coverage
    # Last dependency is the main testbench
    vsim1_cmd = "vsim -coverage -vopt work.{} -c -do \"coverage save -onexit".format(dependencies[-1][:-3])
    vsim1_cmd += " -directive -codeAll {}.ucdb; run -all; exit;\"".format(section)
    # Third command vsim coverage report
    vsim2_cmd = 'vsim -c -do "vcover report -details -html {}.ucdb; exit;"'.format(section)
    # Fourth command rename html report
    mv_cmd = 'mv ./covhtmlreport ./{}_coverage'.format(section)  
    subprocess.run(vlog_cmd, shell=True)
    subprocess.run(vsim1_cmd, shell=True)
    subprocess.run(vsim2_cmd, shell=True)
    subprocess.run(mv_cmd, shell=True)
    break # for testing purposes

