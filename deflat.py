import zlib
import gzip


class deflate_zip():
	def __init__(self, filename):
		self.filename = filename


	def set_deflate(self):		
		with open(self.filename) as df:
			dataf = df.read()
		compressed_data = zlib.compress(dataf)
		f = open(self.filename+'_deflate', 'w')  
		f.write(compressed_data)  
		f.close()  

	def set_gzip(self):		
		f_in = open(self.filename, 'rb')
		f_out = gzip.open(self.filename+'_gzip', 'wb')
		f_out.writelines(f_in)
		f_out.close()
		f_in.close()


if __name__ == "__main__":
	res = deflate_zip("virus.html")
	res.set_deflate()
