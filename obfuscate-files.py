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
import time


SIG_EXIT_CODE    = 130


#logger
logging.basicConfig(stream=sys.stdout, level=logging.INFO,
                format=('%(asctime)s - %(levelname)s - %(message)s'))
logger = logging.getLogger("jsobfuscator")

#ctrl+c handler
def interrupt_handler(signal , frame):
    logger.info("Keyboard interrupt received");
    os._exit(SIG_EXIT_CODE)

signal.signal(signal.SIGINT, interrupt_handler)



#defines
OBFUSCATE_SCRIPT = "./obfuscate-js.py"
OBFUSCATE_CMD    = OBFUSCATE_SCRIPT + " -i \'%s\' -t %s -o \'%s\' -e \'%s\'"


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


def get_file_extension (fullpath):
    try:
        return os.path.basename(fullpath).split(".")[-1]
    except:
        return None


def call_obfuscator (obfuscation_type, inpath, outdir, failure_ok):
    in_file_ext = get_file_extension(inpath)
    if (in_file_ext == 'js' or in_file_ext == 'JS'):
        in_file_ext = 'js'
    else:
        in_file_ext = 'html'

    if (obfuscation_type != "all"):
        cmd = OBFUSCATE_CMD % (inpath, in_file_ext, outdir, obfuscation_type)
        ret = execute_with_subprocess(cmd);
        if (ret != 0):
            return False
    else:
        cmd = ""
        try:
            cmd = OBFUSCATE_CMD % (inpath, in_file_ext, outdir, "aaencode")
            logger.debug(cmd)
            ret = execute_with_subprocess(cmd);
            if (ret != 0 and failure_ok == False):
                raise
            cmd = OBFUSCATE_CMD % (inpath, in_file_ext, outdir, "babel-minify")
            logger.debug(cmd)
            ret = execute_with_subprocess(cmd);
            if (ret != 0 and failure_ok == False):
                raise
            cmd = OBFUSCATE_CMD % (inpath, in_file_ext, outdir, "closure")
            logger.debug(cmd)
            ret = execute_with_subprocess(cmd);
            if (ret != 0 and failure_ok == False):
                raise
            cmd = OBFUSCATE_CMD % (inpath, in_file_ext, outdir, "code-protect")
            logger.debug(cmd)
            ret = execute_with_subprocess(cmd);
            if (ret != 0 and failure_ok == False):
                raise
            cmd = OBFUSCATE_CMD % (inpath, in_file_ext, outdir, "confusion")
            logger.debug(cmd)
            ret = execute_with_subprocess(cmd);
            if (ret != 0 and failure_ok == False):
                raise
            cmd = OBFUSCATE_CMD % (inpath, in_file_ext, outdir, "jfogs")
            logger.debug(cmd)
            ret = execute_with_subprocess(cmd);
            if (ret != 0 and failure_ok == False):
                raise
            cmd = OBFUSCATE_CMD % (inpath, in_file_ext, outdir, "jfogs-reverse")
            logger.debug(cmd)
            ret = execute_with_subprocess(cmd);
            if (ret != 0 and failure_ok == False):
                raise
            cmd = OBFUSCATE_CMD % (inpath, in_file_ext, outdir, "jjencode")
            logger.debug(cmd)
            ret = execute_with_subprocess(cmd);
            if (ret != 0 and failure_ok == False):
                raise
            cmd = OBFUSCATE_CMD % (inpath, in_file_ext, outdir, "jsbeautifier")
            logger.debug(cmd)
            ret = execute_with_subprocess(cmd);
            if (ret != 0 and failure_ok == False):
                raise
            cmd = OBFUSCATE_CMD % (inpath, in_file_ext, outdir, "jsmin")
            logger.debug(cmd)
            ret = execute_with_subprocess(cmd);
            if (ret != 0 and failure_ok == False):
                raise
            cmd = OBFUSCATE_CMD % (inpath, in_file_ext, outdir, "js-obfuscator")
            logger.debug(cmd)
            ret = execute_with_subprocess(cmd);
            if (ret != 0 and failure_ok == False):
                raise
            cmd = OBFUSCATE_CMD % (inpath, in_file_ext, outdir, "qzx-obfuscator")
            logger.debug(cmd)
            ret = execute_with_subprocess(cmd);
            if (ret != 0 and failure_ok == False):
                raise
            cmd = OBFUSCATE_CMD % (inpath, in_file_ext, outdir, "scripts_encryptor")
            logger.debug(cmd)
            ret = execute_with_subprocess(cmd);
            if (ret != 0 and failure_ok == False):
                raise
            cmd = OBFUSCATE_CMD % (inpath, in_file_ext, outdir, "stunnix")
            logger.debug(cmd)
            ret = execute_with_subprocess(cmd);
            if (ret != 0 and failure_ok == False):
                raise
            cmd = OBFUSCATE_CMD % (inpath, in_file_ext, outdir, "uglifyjs-es")
            logger.debug(cmd)
            ret = execute_with_subprocess(cmd);
            if (ret != 0 and failure_ok == False):
                raise
        except:
            return False


    return True



# Get command line arguments
o_parser = OptionParser()
o_parser.add_option("-a", "--absolute-path-for-input-files", dest="inabspath",
                    help="Absolute path to all input files", metavar="inabspath")
o_parser.add_option("-i", "--indexfile", dest="indexfile",
                    help="Path to input file which contains filelist to obfuscate", metavar="indexfile")
o_parser.add_option("-o", "--outdir", dest="outdir",
                    help="Directory where to put output files", metavar="outdir")
o_parser.add_option("-d", "--donotdelete-directory-on-failure", dest="donotdelete",
                    help="do no delete directory on failure", metavar="donotdelete")
o_parser.add_option("-e", "--obfuscationtype", dest="obfuscationtype",
                    help="obfuscationtype supported\n\t\t\taaencode\t\t\t\t\t\nbabel-minify\t\t\t\t\t\nclosure\t\t\t\t\t\t\t\ncode-protect\t\t\t\t\t\nconfusion\t\t\t\t\t\t\t\njfogs\t\t\t\t\t\t\t\t\njfogs-reverse\t\t\t\t\t\njjencode\t\t\t\t\t\njsbeautifier\t\t\t\t\t\t\t\njsmin\t\t\t\t\t\t\t\njs-obfuscator\t\t\t\t\t\t\t\nqzx-obfuscator\t\t\t\t\t\nscripts_encryptor\t\t\t\t\t\nstunnix\t\t\t\t\t\t\t\nuglifyjs-es\t\t\t\t\t\t\t\nall [*Default]")
(c_options, c_args) = o_parser.parse_args()


if (c_options.indexfile == None):
    logger.error("Input File argument missing")
    exit(1)

if (c_options.outdir == None):
    logger.error("Output directory missing")
    exit(1)

if (c_options.inabspath == None):
    logger.error("Inabspath directory missing")
    exit(1)

if (c_options.obfuscationtype == None):
    c_options.obfuscationtype = "all"
elif (c_options.obfuscationtype != "all"):
    if (is_valid_obfucation_type(c_options.obfuscationtype) == False):
        logger.error("Please provide valid obfucation type")
        exit(1)

try:
    os.makedirs(c_options.outdir)
except OSError as e:
    if e.errno == errno.EEXIST:
        logger.debug('Directory exists.')
    else:
        pass
except Exception as e:
    logger.error("Exception " + str(e))
    os._exit(1)


index_list_path = os.path.join(c_options.outdir, "index_list")
try:
    index_list_path_fh = open(index_list_path, "w")
except KeyboardInterrupt:
    logger.error("Keyboard interrupt exiting..!!")
    os._exit(SIG_EXIT_CODE)
except Exception as e:
    logger.error("Exception " + str(e))
    os._exit(1)


index_list_path_fh.write("[\n")

with open(c_options.indexfile) as fp:  
    line = fp.readline()
    cnt = 1
    first_flag = False
    failure_ok = False

    if (c_options.donotdelete != None):
        failure_ok = True

    while line:
        line = line.strip()
        logger.info("\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n")
        logger.debug("Line {}: {}".format(cnt, line.strip()))

        if (line[0] == "/"):
            logger.error("Input line(%d):%s \nmust not contain absolute path" % (cnt, line))
            line = fp.readline()
            cnt += 1
            continue

        absinput_file_path   = os.path.join(c_options.inabspath, line)
        absoutput_files_path = os.path.join(c_options.outdir, os.path.dirname(line))

        ret = call_obfuscator(c_options.obfuscationtype, absinput_file_path, absoutput_files_path, failure_ok) 
        if (ret == False):
            logger.error("Failed to obfuscate  line %d  file \"%s\" " % (cnt, line))
            if (c_options.donotdelete == None):
                logger.info("Removing path " + absoutput_files_path)
                shutil.rmtree(absoutput_files_path)

        if (ret):
            logger.info("=========== Processed %s Successfully" % (absinput_file_path))
            shutil.copyfile(absinput_file_path, os.path.join(absoutput_files_path, os.path.basename(absinput_file_path)))
            files_in_dir = ([f for f in os.listdir(absoutput_files_path) if os.path.isfile(os.path.join(absoutput_files_path, f))])

            if (first_flag == False):
                write_string = '[' + '"' + line + '"'
                first_flag = True
            else:
                write_string = ',\n\n[' + '"' + line + '"'

            for each_entry in files_in_dir:
                write_string += (', "' + os.path.join(os.path.dirname(line), each_entry) + '"')
            write_string += ']'
            index_list_path_fh.write(write_string)

        line = fp.readline()
        cnt += 1



index_list_path_fh.write("]\n")

