#!/usr/bin/env python
import re,sys,string,os

if __name__ == '__main__': 
	# Process options
	filepath = sys.argv[1]
	outpath = sys.argv[2]
	if(os.path.exists(filepath)):
		f=open(filepath,'rw')
		filecontent = f.read()
		filecontent = "<html>\n<body>\n%s"%(filecontent)
		p = re.compile('http',re.VERBOSE)
		filecontent = p.sub("<a href=\"http",filecontent)
		p = re.compile("(http://.*\/(.*\.rar)(\.html)?)",re.VERBOSE)
		filecontent = p.sub("\g<1>\">\g<2></a></br>",filecontent)
		filecontent = "%s\n</html>\n</body>"%(filecontent)
		f=open(outpath,'w')
		f.write(filecontent)