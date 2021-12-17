# Testing

This folder contains details on running regression tests and code coverage for these tests.

## reg_tb_unit.ini

This file contains the dependencies needed by each test or test bench to run. It also contains the relative path to all the dependencies. Ensure that the dependencies
are commma seperated and the test bench is always the last file.

## reg_tb_unit.py

This file will parse and run each test bench sub section. Dependenices are added and run on questasim. Parses from the top the bottom. Coverage results for each module
can  be found in their respective folders in the index.html file. Look at the file for the results of each test bench.
