#!/usr/bin/env python
import sys

inputfile = sys.argv[1]
outfile = sys.argv[2]

date = 0

o = open(outfile, 'w')

with open(inputfile, 'r') as f:
	o.write("Days,CA125\n")
	for line in f:
		s = line.split(",")
		
		if (date == 0 and s[2] == 'CA125\n'):
			date = s[0]
			
		if(s[2] == 'CA125\n'):
			day = int(s[0]) - int(date)
			o.write(str(day) + "," + s[1] + "\n")

o.close()
