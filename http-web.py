#!/usr/bin/env python
# Owner : Jayesh Patel
from BaseHTTPServer import BaseHTTPRequestHandler, HTTPServer
from SimpleHTTPServer import SimpleHTTPRequestHandler
from SocketServer import ThreadingMixIn
import threading
import SocketServer
import commands
import os
from deflat import deflate_zip
from base64_encode import base64_encode
from utf_encode import utf_encode
from padding import setPadding


class S(BaseHTTPRequestHandler):
    def _set_headers(self):

	print self.headers

	if self.headers['Content-Type']:
		contentType = self.headers['Content-Type']
	else:
		contentType = "None"

	if self.headers['Content-Encoding']:
		contentEncoding = self.headers['Content-Encoding']
	else:
		contentType = "None"

        self.send_response(200)

	if "UTF-7" in contentType: 
                self.send_header('Content-type', 'text/html; charset=utf-7' )

	if "UTF-8" in contentType: 
                self.send_header('Content-type', 'text/html; charset=utf-8' )

        if "UTF-16" in contentType:
                self.send_header('Content-type', 'text/html; charset=utf-16' )

        if "UTF-16LE" in contentType:
                self.send_header('Content-type', 'text/html; charset=utf-16le' )

        if "UTF-16BE" in contentType:
                self.send_header('Content-type', 'text/html; charset=utf-16be' )

        if "UTF-32" in contentType:
                self.send_header('Content-type', 'text/html; charset=utf-32' )

        if "UTF-32LE" in contentType:
                self.send_header('Content-type', 'text/html; charset=utf-32le' )

        if "UTF-32BE" in contentType:
                self.send_header('Content-type', 'text/html; charset=utf-32be' )

        if "base64" in contentType:
                self.send_header('Content-type', 'text/html')
                self.send_header('Content-Transfer-Encoding', 'BASE64' )

	if "deflate" in contentEncoding:
                self.send_header('Content-Encoding', 'deflate')

	if "gzip" in contentEncoding:
                self.send_header('Content-Encoding', 'gzip')

	if "chunked" in contentEncoding:
		self.send_header('Transfer-Encoding', 'chunked')

        self.end_headers()

    def run_evasion(self, payload, file_type, evasion_name):
	if evasion_name == "scripts_encryptor":
		if os.path.exists("SrcEnv/%s_se" % payload.split('/')[1]):
			status, output = commands.getstatusoutput('cp SrcEnv/%s_se /tmp/%s' %(payload.split('/')[1], self.file_name))
			command = 'cp SrcEnv/%s_se /tmp/%s' %(payload.split('/')[1], self.file_name)
			print command
			return "Done"
		else:
			return "None"
	else:
		status, output = commands.getstatusoutput('python obfuscate-js.py -i %s -t %s -o /tmp/ -e %s' % (payload, file_type, evasion_name))
		command = 'python obfuscate-js.py -i %s -t %s -o /tmp/ -e %s' % (payload, file_type, evasion_name)
		print "============== %s" % command

	print status
	print output

	if status != 0:
		return "None"
	else:
		return "Done"
	

    def chunks(self, s, n):
    	for start in range(0, len(s), n):
        	yield s[start:start+n]

    def do_GET(self):
        self._set_headers()

	payload_name = self.path.split('?')[0][1:]
	next_str = self.path.split('?')[1]
	next_final_str = next_str.split('%26')
	str_array = dict(s.split('=') for s in next_final_str)
	file_type = str_array['type']
	evasion_name = str_array['evasion']
	compress = str_array['compress']
	chunked = str_array['chunked']
	characterSet = str_array['characterset']
	padding = str_array['padding']

	if ("None") in padding:
		padding = "None"

	print "jayesh %s" % padding

	print "payload name %s" % payload_name
	print "filetype %s" % file_type
	print "evasion name %s" % evasion_name

	file_name = payload_name.split('.')[0] +"_"+ evasion_name +"."+ file_type
	self.file_name = payload_name.split('.')[0] +"_"+ evasion_name +"."+ file_type

	if padding != "None":
		res = setPadding(payload_name, int(padding))
        	res.addPadding()
		file_name = payload_name+"_pad"

	
	if evasion_name != "None":
		if padding != "None":
			command_status = self.run_evasion("/tmp/"+payload_name+"_pad", file_type, evasion_name)

		if padding == "None":
			command_status = self.run_evasion("static/"+payload_name, file_type, evasion_name)
		

		print "command status %s" % command_status
		file_name = payload_name.split('.')[0] +"_"+ evasion_name +"."+ file_type

	else:
		if padding == "None":
			os.system("cp static/%s /tmp/%s" % (payload_name, file_name))
		command_status = "Done"

	
	if characterSet != "None":
	    res = utf_encode("/tmp/"+file_name)


	    if characterSet == "utf7":
        	res.set_utf7()

	    if characterSet == "utf8bom":
        	res.set_utf8bom()

	    if characterSet == "utf16":
        	res.set_utf16()

	    if characterSet == "utf16le":
		res.set_utf16le()

	    if characterSet == "utf16be":
		res.set_utf16be()

	    if characterSet == "utf32":
		res.set_utf32()
		
	    if characterSet == "utf32le":
		res.set_utf32le()
	
	    if characterSet == "utf32be":
		res.set_utf32be()

	    if characterSet == "base64":
		self.setBase64(file_name)
		

	else:
	    os.system("cp /tmp/%s /tmp/%s_%s" % (file_name, file_name, characterSet))

	
	    # Generate file /tmp/filename_utf32be

	if compress != "None":
	    if compress == "deflate":
		self.setDeflat(file_name + "_" + characterSet)

	    if compress == "gzip":
		self.setGzip(file_name+"_"+characterSet)

	else:
	    os.system("cp /tmp/%s_%s /tmp/%s_%s_%s" % (file_name, characterSet, file_name, characterSet, compress))


	if command_status == "Done":
	    if chunked == "yes":
		for chunk in self.chunks(''.join(open("/tmp/"+file_name+"_"+characterSet+"_"+compress, 'r').readlines()), 15):
                	chkn = len(chunk)

        		if chkn == 15:
                		chk_num = "f"
        		elif chkn == 14:
                		chk_num = "e"
        		elif chkn == 13:
                		chk_num = "d"
        		elif chkn == 12:
                		chk_num = "c"
        		elif chkn == 11:
                		chk_num = "b"
        		elif chkn == 10:
                		chk_num = "a"
        		else:
                		chk_num = chkn

        		self.wfile.write("%s\r\n" % chk_num)
        		self.wfile.write("%s\r\n" % chunk)

       		self.wfile.write('0\r\n\r\n')
	    else:
	    	with open("/tmp/"+file_name+"_"+characterSet+"_"+compress) as data:
        		self.wfile.write(data.read())
        		self.wfile.write("Jayesh Patel")
	else:
	    print "Error 404"
	    self.send_error(404, 'file not found')

	os.system("rm -rf /tmp/%s*" % payload_name.split('.')[0])
	print "remove file rm -rf /tmp/%s*" % payload_name.split('.')[0]
	

    def setBase64(self, filename):
		res = base64_encode("/tmp/"+filename)
                res.set_base64()
		# Generate New file in /tmp/filename_b64

    def setDeflat(self, filename):
		res = deflate_zip("/tmp/"+filename)
		res.set_deflate()
		# Generate New file with name filename_deflate

    def setGzip(self, filename):
		res = deflate_zip("/tmp/"+filename)
		res.set_gzip()
		# Generate New file filename_gzip



    def do_HEAD(self):
        self._set_headers()
        
    def do_POST(self):
        # Doesn't do anything with posted data
        self._set_headers()
        self.wfile.write("<html><body><h1>POST!</h1></body></html>")

        
def run(server_class=HTTPServer, handler_class=S, port=80):
    server_address = ('', port)
    httpd = server_class(server_address, handler_class)
    print 'Starting httpd...'
    httpd.serve_forever()

if __name__ == "__main__":
    from sys import argv

    if len(argv) == 2:
        run(port=int(argv[1]))
    else:
	run()
