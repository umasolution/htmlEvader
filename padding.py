import re
import os

class setPadding():
	def __init__(self, filename, padsize):
		self.filename = filename
		self.padsize = padsize

		self.msize = padsize * 1048576

	
	def setPsize(self):
		data = 'A' * self.msize
		return data	

	def addPadding(self):
		dsize = self.setPsize()
		with open("static/"+self.filename, "r") as in_file:
    			buff = in_file.readlines()

		filew = open("/tmp/"+self.filename+"_pad", "w")
		d1=True
		for line in buff:
			if d1:
				if "<head>" in line: 
					print line
					filew.write(line)
	     				filew.write("<script>\n")
					filew.write("var secret_var = '%s'\n" % dsize)
	     				filew.write("</script>\n")
					results="set"
					d1=False
				else:
					results="Notset"
					filew.write(line)
			else:
				filew.write(line)

		filew.close()

		if results != "set":
			f = open("/tmp/"+self.filename+"_pad", 'r+')
			lines = f.readlines()
			f.seek(0)
	
			f.write("<script>\n")
			f.write("var secret_var = %s\n" % dsize)
			f.write("</script>\n")

			for line in lines:
				f.write(line)	

			f.close()



if __name__ == "__main__":
	res = setPadding('virus1.html', 10)
	print res.addPadding()

