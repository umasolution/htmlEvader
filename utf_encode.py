import codecs
import commands



class utf_encode():
	def __init__(self, filename):
		self.filename = filename
		print "jayesh %s" % self.filename

	def set_utf8bom(self):
		with open(self.filename) as df:
			dataf = df.read()

		print self.filename
		out = file(self.filename+"_utf8bom", "w" )
		out.write( codecs.BOM_UTF8 )
		out.write( dataf.encode( "utf-8" ) )
		out.close()

	def set_utf7(self):
		self.set_utf8bom()
		cmd = "iconv -f utf-8 -t utf7 %s_utf8bom > %s_utf7" % (self.filename, self.filename)
		status, output = commands.getstatusoutput(cmd)
		
	def set_utf16(self):
		self.set_utf8bom()
		cmd = "iconv -f utf-8 -t utf16 %s_utf8bom > %s_utf16" % (self.filename, self.filename)
		status, output = commands.getstatusoutput(cmd)

	def set_utf32(self):
		self.set_utf8bom()
		cmd = "iconv -f utf-8 -t utf32 %s_utf8bom > %s_utf32" % (self.filename, self.filename)
		print "cmd %s" % cmd
		status, output = commands.getstatusoutput(cmd)

	def set_utf16le(self):
		self.set_utf8bom()
		cmd = "iconv -f utf-8 -t utf16le %s_utf8bom > %s_utf16le" % (self.filename, self.filename)
		status, output = commands.getstatusoutput(cmd)

	def set_utf16be(self):
		self.set_utf8bom()
		cmd = "iconv -f utf-8 -t utf16be %s_utf8bom > %s_utf16be" % (self.filename, self.filename)
		status, output = commands.getstatusoutput(cmd)

	def set_utf32le(self):
		self.set_utf8bom()
		cmd = "iconv -f utf-8 -t utf32le %s_utf8bom > %s_utf32le" % (self.filename, self.filename)
		status, output = commands.getstatusoutput(cmd)

	def set_utf32be(self):
		self.set_utf8bom()
		cmd = "iconv -f utf-8 -t utf32be %s_utf8bom > %s_utf32be" % (self.filename, self.filename)
		status, output = commands.getstatusoutput(cmd)



if __name__ == "__main__":
	res = utf_encode('poc.html')
	res.set_utf8bom()
