
#Python 3
# Phill Moore
# Contact: randomaccess3@gmail.com

import argparse, os, sys, subprocess
from pathlib import Path

def checkObjectID (path):
	command = "fsutil objectid query " + path + " | find \"Object ID\""
	output = subprocess.getoutput(command)	
	if output:
		o2 = output.replace('Object ID :        ','')
		print (path + "\t\t| " + o2)

parser = argparse.ArgumentParser(description='Process path.')
parser.add_argument('path', type=str, 
                   help='path. For a drive add an extra \\')

args = parser.parse_args()
p = Path(args.path)

for dirpath, dirs, files in os.walk(p): 
	dname = os.path.join(dirpath)
	checkObjectID(dname)
		
	for filename in files:
		fname = os.path.join(dirpath,filename)
		checkObjectID(fname)
	