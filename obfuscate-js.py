#!/usr/bin/python

from __future__ import print_function
from optparse import OptionParser
import subprocess,traceback,sys,os,re
import string
import collections
import xml.etree.ElementTree as ET
import re
import shutil
import string
import random
import logging
import errno
import signal

SIG_EXIT_CODE    = 130

#logger
logging.basicConfig(stream=sys.stdout, level=logging.INFO,
                format=('%(asctime)s - %(levelname)s - [line:%(lineno)d] -- %(message)s'))
logger = logging.getLogger("jsobfuscator")

#ctrl+c handler
def interrupt_handler(signal , frame):
    logger.info("Keyboard interrupt received");
    os._exit(SIG_EXIT_CODE)

signal.signal(signal.SIGINT, interrupt_handler)





#defines
SCRIPT_START     = "<script"
SCRIPT_END       = "</script>"


TMP_DIR          = "/tmp/node_tmp/"
NODE_JS_BIN_DIR  = "node_modules/.bin"          # $ npm bin
SCRIPT_DIR       = "./"
VENDOR_DIR       = SCRIPT_DIR + "/vendor"

JFOG_CMD         = NODE_JS_BIN_DIR + "/jfogs \"%s\" -o \"%s\""
JFOG_REV_CMD     = NODE_JS_BIN_DIR + "/jfogs -t reverse \"%s\" -o \"%s\""
JSOBFUSCATE_CMD  = NODE_JS_BIN_DIR + "/jsobfuscate \"%s\" > \"%s\""
AAENCODE_CMD     = NODE_JS_BIN_DIR + "/aaencode \"%s\" -o \"%s\""
JJENCODE_CMD     = SCRIPT_DIR      + "/utils/jjencode.js \"%s\" -o \"%s\""
CODEPROTECT_CMD  = SCRIPT_DIR      + "/utils/code-protect.js \"%s\" -o \"%s\""
BABEL_MINIFY_CMD = NODE_JS_BIN_DIR + "/babel-minify \"%s\" -o \"%s\""
CONFUSION_CMD    = NODE_JS_BIN_DIR + "/confusion < \"%s\" > \"%s\""
JSMIN_CMD        = NODE_JS_BIN_DIR + "/jsmin \"%s\" > \"%s\""
QZX_CMD          = NODE_JS_BIN_DIR + "/javascript-obfuscator \"%s\" --output \"%s\""
JS_BEAUTY_CMD    = NODE_JS_BIN_DIR + "/js-beautify -f \"%s\" -o \"%s\""
STUNIX_CMD       = VENDOR_DIR      + "/Stunnix-JS-Obfus-5.8-Linux-trial/bin/js-obfus -i prefix -n none -s none -jam 1 -e 0 \"%s\" > \"%s\""
CLOSURE_CMD      = "closure-compiler --js \"%s\" > \"%s\""
UGLIFYJS_CMD     = NODE_JS_BIN_DIR + "/uglifyjs -c hoist_vars=true \"%s\" > \"%s\""
SCRENC_CMD       = "wine " + VENDOR_DIR      + "/ScrEnc/screnc.exe -l JScript \"%s\" \"%s\""

def execute_with_subprocess(cmd):
    sub_cmd = [ "bash", "-c", cmd]
    ret = 0
    try:
        ret = subprocess.call(sub_cmd)
        return ret
    except KeyboardInterrupt:
        logger.error("Keyboard interrupt exiting..!!")
	os._exit(SIG_EXIT_CODE)
    except:
	return 1


def is_valid_obfucation_type(obfucation_type):
    if (obfucation_type == "aaencode" or
        obfucation_type == "babel-minify" or
        obfucation_type == "closure" or
        obfucation_type == "code-protect" or
        obfucation_type == "confusion" or
        obfucation_type == "jfogs" or
        obfucation_type == "jfogs-reverse" or
        obfucation_type == "jjencode" or
        obfucation_type == "jsbeautifier" or
        obfucation_type == "jsmin" or
        obfucation_type == "js-obfuscator" or
        obfucation_type == "qzx-obfuscator" or
        obfucation_type == "scripts_encryptor" or
        obfucation_type == "stunnix" or
        obfucation_type == "uglifyjs-es"):
        return True

    return False





def prepare_wine_path(linuxpath):
    #Z:\tmp\plain-js.js
    winepath = "Z:" + os.path.abspath(linuxpath).replace("/", "\\")
    return winepath

def prepare_output_filename(outdir, infile, filetype, testcasename):
    return os.path.join(outdir, os.path.basename(infile).split(".")[0] + "_" + testcasename + "." + filetype)

def generate_random_filename():
    return (''.join(random.SystemRandom().choice(string.ascii_uppercase + string.digits) for _ in range(10))) + ".js"








def comp_aaencode_obfuscate(jsfile, outfile):
    ret = execute_with_subprocess(AAENCODE_CMD % (jsfile, outfile))
    if (ret != 0):
        logger.error("comp_aaencode command return non zero for file %s retcode = %d" % (jsfile, ret))
        return False

    return True

def comp_jjencode_obfuscate(jsfile, outfile):
    ret = execute_with_subprocess(JJENCODE_CMD % (jsfile, outfile))
    if (ret != 0):
        logger.error("comp_jjencode command return non zero for file %s retcode = %d" % (jsfile, ret))
        return False

    return True

def comp_jsfog_obfuscate (jsfile, outfile, jfog_type):
    if (jfog_type == 'reverse'):
        jfog_cmd = JFOG_CMD % (jsfile, outfile)
    else:
        jfog_cmd = JFOG_REV_CMD % (jsfile, outfile)

    ret = execute_with_subprocess(jfog_cmd)
    if (ret != 0):
        logger.error("Jfog command return non zero for file %s retcode = %d" % (jsfile, ret))
        return False

    return True

def comp_jsobfuscator_obfuscate(jsfile, outfile):
    ret = execute_with_subprocess(JSOBFUSCATE_CMD % (jsfile, outfile))
    if (ret != 0):
        logger.error("comp_jsobfuscator command return non zero for file %s retcode = %d" % (jsfile, ret))
        return False

    return True

def comp_babel_minify_obfuscate(jsfile, outfile):
    ret = execute_with_subprocess(BABEL_MINIFY_CMD % (jsfile, outfile))
    if (ret != 0):
        logger.error("comp_babel_minify command return non zero for file %s retcode = %d" % (jsfile, ret))
        return False

    return True

def comp_confusion_obfuscate(jsfile, outfile):
    ret = execute_with_subprocess(CONFUSION_CMD % (jsfile, outfile))
    if (ret != 0):
        logger.error("comp_confusion command return non zero for file %s retcode = %d" % (jsfile, ret))
        return False

    return True

def comp_jsmin_obfuscate(jsfile, outfile):
    ret = execute_with_subprocess(JSMIN_CMD % (jsfile, outfile))
    if (ret != 0):
        logger.error("comp_jsmin command return non zero for file %s retcode = %d" % (jsfile, ret))
        return False

    return True

def comp_qzx_obfuscate(jsfile, outfile):
    ret = execute_with_subprocess(QZX_CMD % (jsfile, outfile))
    if (ret != 0):
        logger.error("comp_qzx command return non zero for file %s retcode = %d" % (jsfile, ret))
        return False

    return True

def comp_jsbeauty_obfuscate(jsfile, outfile):
    ret = execute_with_subprocess(JS_BEAUTY_CMD % (jsfile, outfile))
    if (ret != 0):
        logger.error("comp_jsbeauty command return non zero for file %s retcode = %d" % (jsfile, ret))
        return False

    return True

def comp_stunnix_obfuscate(jsfile, outfile):
    ret = execute_with_subprocess(STUNIX_CMD % (jsfile, outfile))
    if (ret != 0):
        logger.error("comp_stunnix command return non zero for file %s retcode = %d" % (jsfile, ret))
        return False

    return True

def comp_closure_obfuscate(jsfile, outfile):
    ret = execute_with_subprocess(CLOSURE_CMD % (jsfile, outfile))
    if (ret != 0):
        logger.error("comp_closure command return non zero for file %s retcode = %d" % (jsfile, ret))
        return False

    return True

def comp_uglifyjs_obfuscate(jsfile, outfile):
    ret = execute_with_subprocess(UGLIFYJS_CMD % (jsfile, outfile))
    if (ret != 0):
        logger.error("comp_uglifyjs command return non zero for file %s retcode = %d" % (jsfile, ret))
        return False

    return True

def comp_scripts_encryptor_obfuscate(jsfile, outfile):
    ret = execute_with_subprocess(SCRENC_CMD % (prepare_wine_path(jsfile), prepare_wine_path(outfile)))
    if (ret != 0):
        logger.error("comp_uglifyjs command return non zero for file %s retcode = %d" % (jsfile, ret))
        return False

    return True

def comp_code_protect_obfuscate(jsfile, outfile):
    ret = execute_with_subprocess(CODEPROTECT_CMD % (jsfile, outfile))
    if (ret != 0):
        logger.error("comp_codeprotect command return non zero for file %s retcode = %d" % (jsfile, ret))
        return False

    return True

def js_obfuscate(jscontent, obfucation_type):

    # write jscontent into jsfile
    # format name of outfile (Where obfuscated content will be written by components)
    # After component call read outfile and return it's content

    logger.debug("jscontent :: \n%s\n" % (jscontent))

    jsfile = generate_random_filename()
    outfile = generate_random_filename()
    jsfile = os.path.join(TMP_DIR, jsfile)
    outfile = os.path.join(TMP_DIR, outfile)

    try:
        js_fh = open(jsfile, 'w')
        js_fh.write(jscontent)
        js_fh.close()
    except KeyboardInterrupt:
        logger.error("Keyboard interrupt exiting..!!")
	sys.exit(SIG_EXIT_CODE)
    except:
        logger.error("Unable to open random file for write %s" % (jsfile))
        return None

    ret = False

    if (obfucation_type == "aaencode"):
	ret = comp_aaencode_obfuscate(jsfile, outfile)
    elif (obfucation_type == "babel-minify"):
	ret = comp_babel_minify_obfuscate(jsfile, outfile)
    elif (obfucation_type == "confusion"):
	ret = comp_confusion_obfuscate(jsfile, outfile)
    elif (obfucation_type == "jfogs"):
        ret = comp_jsfog_obfuscate(jsfile, outfile, "")
    elif (obfucation_type == "jfogs-reverse"):
        ret = comp_jsfog_obfuscate(jsfile, outfile, "reverse")
    elif (obfucation_type == "jjencode"):
	ret = comp_jjencode_obfuscate(jsfile, outfile)
    elif (obfucation_type == "jsmin"):
	ret = comp_jsmin_obfuscate(jsfile, outfile)
    elif (obfucation_type == "js-obfuscator"):
	ret = comp_jsobfuscator_obfuscate(jsfile, outfile)
    elif (obfucation_type == "qzx-obfuscator"):
	ret = comp_qzx_obfuscate(jsfile, outfile)
    elif (obfucation_type == "scripts_encryptor"):
	ret = comp_scripts_encryptor_obfuscate(jsfile, outfile)
	# bypass
	#shutil.copyfile(jsfile, outfile)
	#ret = True
    elif (obfucation_type == "stunnix"):
	ret = comp_stunnix_obfuscate(jsfile, outfile)
    elif (obfucation_type == "uglifyjs-es"):
	# need to do research on this. How generate var names in hex format ?
	ret = comp_uglifyjs_obfuscate(jsfile, outfile)
    elif (obfucation_type == "closure"):
	ret = comp_closure_obfuscate(jsfile, outfile)
    elif (obfucation_type == "code-protect"):
	ret = comp_code_protect_obfuscate(jsfile, outfile)
    elif (obfucation_type == "jsbeautifier"):
	ret = comp_jsbeauty_obfuscate(jsfile, outfile)
    else:
        try:
            os.remove(outfile)
            os.remove(jsfile)
        except KeyboardInterrupt:
            logger.error("Keyboard interrupt exiting..!!")
	    sys.exit(SIG_EXIT_CODE)
        except:
            pass
        return None

    if (ret != True):
	logger.error("Obfuscation failed")
        return None

    try:
        with open(outfile, 'r') as jo_fh:
            content = jo_fh.read()
        jo_fh.close()
        os.remove(outfile)
        os.remove(jsfile)
        return content
    except KeyboardInterrupt:
        logger.error("Keyboard interrupt exiting..!!")
	sys.exit(SIG_EXIT_CODE)
    except Exception, e:
        logger.error("Exception %s" % (str(e)))
        return None

    return None












# Get command line arguments
o_parser = OptionParser()
o_parser.add_option("-i", "--inputfile", dest="inputfile",
                    help="Path to input html/js file", metavar="inputfile")
o_parser.add_option("-t", "--filetype", dest="filetype",
                    help="File type  html or js", metavar="filetype")
o_parser.add_option("-o", "--outdir", dest="outdir",
                    help="Directory where to put output files", metavar="outdir")
o_parser.add_option("-d", "--debug", dest="debug",
                    help="Debug", metavar="debug")
o_parser.add_option("-e", "--obfuscationtype", dest="obfuscationtype",
                    help="obfuscationtype supported\n\t\t\taaencode\t\t\t\t\t\nbabel-minify\t\t\t\t\t\nclosure\t\t\t\t\t\t\t\ncode-protect\t\t\t\t\t\nconfusion\t\t\t\t\t\t\t\njfogs\t\t\t\t\t\t\t\t\njfogs-reverse\t\t\t\t\t\njjencode\t\t\t\t\t\njsbeautifier\t\t\t\t\t\t\t\njsmin\t\t\t\t\t\t\t\njs-obfuscator\t\t\t\t\t\t\t\nqzx-obfuscator\t\t\t\t\t\nscripts_encryptor\t\t\t\t\t\nstunnix\t\t\t\t\t\t\t\nuglifyjs-es\t\t\t\t\t\t\t\n")
(c_options, c_args) = o_parser.parse_args()

if (c_options.debug):
    logger.level = logging.DEBUG

if (c_options.inputfile == None):
    logger.error("Input File argument missing")
    exit(1)

if (c_options.filetype != None):
    if (c_options.filetype != 'html' and c_options.filetype != 'js'):
        logger.error("Input file type should be html or js")
        exit(1)
else:
    logger.info('No filetype provided. assuming html!!')
    c_options.filetype = 'html'

if (c_options.outdir == None):
    logger.error("Output directory missing")
    exit(1)

if (c_options.obfuscationtype == None):
    logger.error("Obfucation type missing")
    exit(1)

if (is_valid_obfucation_type(c_options.obfuscationtype) == False):
    logger.error("Please provide valid obfucation type")
    exit(1)


# Make temp directory to work with
try:
    os.makedirs(TMP_DIR)
except KeyboardInterrupt:
    logger.error("Keyboard interrupt exiting..!!")
    sys.exit(SIG_EXIT_CODE)
except OSError as e:
    if e.errno == errno.EEXIST:
        logger.debug('Directory exists.')
    else:
	logger.error("Exception %s" % (str(e)))
	exit(1)



# prepare and open outputfile name
out_file_name = prepare_output_filename(c_options.outdir, c_options.inputfile, c_options.filetype, c_options.obfuscationtype)

try:
    os.makedirs(c_options.outdir)
except KeyboardInterrupt:
    logger.error("Keyboard interrupt exiting..!!")
    sys.exit(SIG_EXIT_CODE)
except OSError as e:
    if e.errno == errno.EEXIST:
        logger.debug('Directory exists.')
    else:
	logger.error("Exception %s" % (str(e)))
	exit(1)

try:
    out_fh = open(out_file_name, 'w')
except KeyboardInterrupt:
    logger.error("Keyboard interrupt exiting..!!")
    sys.exit(SIG_EXIT_CODE)
except:
    logger.error("Unable to open file " + out_file_name)
    exit(1)


# read and obfuscate javascript from html/js file
with open(c_options.inputfile, 'r') as in_file:
    content = in_file.read()
    content_len = len(content)

    ret = 0
    script_start_index = 0
    script_start_end_index = 0
    script_end_index = 0

    prev_script_start_index = 0
    prev_script_start_end_index = 0
    prev_script_end_index = 0

    obfuscated_once = False

    logger.info("Obfucating file %s with obfucation_type = %s" % (c_options.inputfile, c_options.obfuscationtype))
    logger.debug("Content : " + content)

    while (True):
        if (c_options.filetype == 'html'):
	    lower_content = content.lower()
            script_start_index     = lower_content.find(SCRIPT_START, ret)
            script_start_end_index = lower_content.find('>', script_start_index)
            script_end_index       = lower_content.find(SCRIPT_END, script_start_index)

            logger.debug("ssi = %d  ssei = %d  sei = %d" % (script_start_index, script_start_end_index, script_end_index))

            if (script_start_index == -1):
                logger.debug("Script indexes -1")
                if (ret == 0):
                    logger.error("No JS content found in file %s" % (c_options.inputfile))
                    exit(1)
                break
            if (script_start_end_index == -1 or script_end_index == -1):
		ret = script_start_index + 1
		continue

            script_start_end_index += 1

	    if (script_start_end_index == script_end_index):
                out_fh.write(content[ret:script_end_index])
		ret = script_end_index + 1
		continue

            if (script_start_index > script_start_end_index or
                script_start_end_index > script_end_index):
                logger.error("Strange this should not happen file %s" % (c_options.inputfile))
                break

            prev_script_start_index = script_start_index
            prev_script_start_end_index = script_start_end_index
            prev_script_end_index = script_end_index

            out_fh.write(content[ret:script_start_end_index])

            obfuscated_js_content = js_obfuscate(content[script_start_end_index:script_end_index], c_options.obfuscationtype)
            if (obfuscated_js_content == None):
		out_fh.write(content[script_start_end_index:script_end_index])
                logger.info("Bypassing since obfuscataion failed")
	    else:
	        obfuscated_once = True
                out_fh.write(obfuscated_js_content)

            ret = script_end_index
        else:
            obfuscated_js_content = js_obfuscate(content[0:content_len], c_options.obfuscationtype)
            if (obfuscated_js_content == None):
                logger.error("Unable to obfuscate jscontent")
                exit(1)
	    obfuscated_once = True
            out_fh.write(obfuscated_js_content)
            break

    if (prev_script_end_index):
        out_fh.write(content[prev_script_end_index:content_len])

    out_fh.close()

    if (obfuscated_once == False):
        logger.error("Nothing got obfuscated exit(1)")
        exit(1)

    logger.info("Successfully generated file %s" % (out_file_name ))
