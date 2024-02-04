#!/usr/bin/env python3

import sys

def getOnlyBitfile():
    mypath= "."
    from os import listdir
    from os.path import isfile, join
    onlyfiles = [f for f in listdir(mypath) if isfile(join(mypath, f)) and f.endswith(".lvbitx")]
    if len(onlyfiles) > 0:
        return onlyfiles[0]
    return None

def getBitstream(lvbitxFile):
    import xml.etree.ElementTree as ET
    tree = ET.parse(lvbitxFile)
    root = tree.getroot()

    md5 = root.find('BitstreamMD5').text
    uu64 = root.find('Bitstream').text

    import base64
    data = base64.b64decode(uu64)

    return [md5, data]

def saveToBinFile(fileName, binData):
    binDataArray = bytearray(binData)
    with open(fileName, "wb") as fout:
        fout.write(binDataArray)

def saveToTxtFile(fileName, txtData):
    with open(fileName, "wt") as fout:
        fout.write(txtData)

import argparse
parser = argparse.ArgumentParser(description='Unpack .bin file from LabVIEW lvbitx file')
parser.add_argument('lvbitx', default=None, nargs='?', help="Full path to LabVIEW lvbitx file")
args = parser.parse_args()

if args.lvbitx:
    print("Extracting .bin file from {0}".format(args.lvbitx))
    lvbitx = args.lvbitx
else:
    print("No .lvbitx specified, checking current directory for one")
    lvbitx = getOnlyBitfile()
    if lvbitx:
        print("Found a lvbitx file in the current directory: {}".format(lvbitx))
    else:
        print("No lxbitx file found in current directory, exiting")
        sys.exit(0)

print("Bitfile detected: {}".format(lvbitx))

[md5, bitstream] = getBitstream(lvbitx)
newFile = lvbitx.split(".")[0] + ".bin"

print("Saving .bin file to: {}".format(newFile))
saveToBinFile(newFile, bitstream)

print("Saving MD5 to file: {}".format(newFile + ".md5"))
saveToTxtFile(newFile + ".md5", md5)

