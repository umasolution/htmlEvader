import base64



class base64_encode():
	def __init__(self, filename):
		self.filename = filename

	def set_base64(self):
		data = open(self.filename, 'rb')
		data_read = data.read()
		data_64_encode = base64.encodestring(data_read)

		print data_64_encode

		dataw = open(self.filename+"_base64", 'w')
		dataw.write(data_64_encode)
		dataw.close()
	


if __name__ == "__main__":
	res = base64_encode("poc.html")
	res.set_base64()

