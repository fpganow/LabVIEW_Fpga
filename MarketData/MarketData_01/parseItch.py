#!/usr/bin/python3

import struct

class ItchMessage:

    def __init__(self, rawMessage):
        self.rawMessage = rawMessage
        self.messageType = self.rawMessage[0]

    def dumpMessage(self):
        print("---------------")
        print("Dumping message")
        print("---------------")
        print("MessageType: {0} ({1})".format(chr(self.messageType),
                                                hex(self.messageType)))
        if self.getMessageType() == 'T':
            self.timestamp = struct.unpack("!I", self.rawMessage[1:5])[0]
            print("Timestamp(Seconds): {0}".format(time))
        elif self.getMessageType() == 'C':
            (self.timestamp, self.orderRefNum, self.shares, self.match,
            self.printable, self.price) = struct.unpack("!IQIQcI", self.rawMessage[1:])
            print("Timestamp(Nanoseconds): {0}".format(self.timestamp))            
            print("Price: {0}".format(self.price))            
            print("Shares: {0}".format(self.shares))            

    def getMessageType(self):
        return chr(self.messageType)

    def dumpRaw(self):
        rawMessageDump = ""
        line = ""
        count = 0
        for byte in self.rawMessage:
            line += "0x%02x " % (byte)
            count += 1
            if count == 8:
                rawMessageDump += line + "\n\t"
                line = ""
                count = 0
        rawMessageDump += line + "\n"
        print("Raw bytes:\n\t{0}".format(rawMessageDump))

    def appendToFile(self, fileName=None):
        self.saveToFile('ab', fileName)

    def saveToFile(self, openMode='ab', fileName=None):
        if fileName is None:
            fileName = self.type + ".itch"
            print("Setting file name to: {0}".format(fileName))
        print("Saving to file: {0}".format(fileName))
        dataLen = len(self.rawMessage)
        rawArray = bytearray(self.rawMessage)
        print("Data length: {0}".format(dataLen))

        fileOut = open(fileName, openMode)
        fileOut.write(struct.pack(">H", dataLen))
        fileOut.write(rawArray)
        fileOut.close()

messageTypes = {
    'T':"Timestamp - Seconds",
    'C':"Order Executed - With Price"
}

def getMessageType(msgType):
    if msgType in messageTypes:
        return "{0}:{1}".format(msgType, messageTypes[msgType])
    else:
        return "Unknown:{0}".format(msgType)

def extractMessages(fileName, numberOfMessagesToSave, saveMessageTypes, outFileName):
    messageCounts = { }
    for saveMessageType in saveMessageTypes:
        messageCounts[saveMessageType] = 0

    print("Parsing ITCH 4.1 File:", fileName)
    print("Saving the first {0} messages of type: {1}".format(numberOfMessagesToSave, saveMessageType))

    cacheSize = 1024
    fin = open(fileName, "rb")
    messageCounter = 0

    buffer = fin.read(cacheSize)
    bufferLen = len(buffer)
    ptr = 0
    haveData = True
    while haveData:
        byte = buffer[ptr:ptr+1]
        ptr += 1
        if ptr == bufferLen:
            ptr = 0
            buffer = fin.read(cacheSize)
        bufferLen = len(buffer)
        if len(byte) == 0:
            break
        if byte == b'\x00':
            length = ord(buffer[ptr:ptr+1])
            ptr += 1
            if (ptr+length) > bufferLen:
                temp = buffer[ptr:bufferLen]
                buffer = temp + fin.read(cacheSize)
                bufferLen = len(buffer)
                ptr = 0
            message = buffer[ptr:ptr+length]
            messageType = chr(buffer[ptr])#
            ptr += length
            itchMessage = ItchMessage(message)

            if itchMessage.getMessageType() in saveMessageTypes:
                messageCounts[itchMessage.getMessageType()] += 1

                itchMessage.dumpMessage()
                itchMessage.dumpRaw()
                itchMessage.appendToFile(outFileName)

                exitLoop = True
                for saveMessageType in messageCounts.keys():
                    if messageCounts[saveMessageType] < numberOfMessagesToSave:
                        exitLoop = False
                        break
                if exitLoop:
                    break
            if ptr == bufferLen:
                ptr = 0
                buffer = fin.read(cacheSize)
                bufferLen = len(buffer)
    fin.close()


#### Parameters for Execution
# Download from here: ftp://emi.nasdaq.com/ITCH/11092013.NASDAQ_ITCH41.gz
fileName = "11092013.NASDAQ_ITCH41"
outputFile = "Itch.dat"
saveMessageTypes = [ 'T' ]
numberOfMessagesToSave = 2

extractMessages(fileName, numberOfMessagesToSave, saveMessageTypes, outputFile)

