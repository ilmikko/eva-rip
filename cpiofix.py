#!env python
# 
# cpiofix.py
# This python script fixes the cpio output produced by the GNU cpio compiler.
# Further explanation can be found on the blog.
#
from time import sleep;
from struct import unpack;
import sys;
import __main__;

trailer = b'TRAILER!!!\x00'
inodeoffset = 0x000493e0-2 # Don't ask me

# New ASCII Format

ASCIIChunks = {
        'magic':6,     # 0
        'ino':8,       # 1
        'mode':8,      # 2
        'uid':8,       # 3
        'gid':8,       # 4
        'nlink':8,     # 5
        'mtime':8,     # 6
        'filesize':8,  # 7
        'devmajor':8,  # 8
        'devminor':8,  # 9
        'rdevmajor':8, # 10
        'rdevminor':8, # 11
        'namesize':8,  # 12
        'check':8      # 13
};

chunkPos = 0

def printSummary(info):
    # One line summary of the file
    stra=[];
    for key in info:
        if (key=='data'):
            continue;
        stra.append(key+':'+str(info[key]))

    print(''.join(stra));

def printFixedSummary(info):
    info['mode']=info['mode'].lower()
    # One line summary of the file
    printSummary(info)

def fixino(chunk):
    global inodeoffset
    inodeoffset+=1
    return str.encode('{:08x}'.format(inodeoffset))

def fixuid(chunk):
    return str.encode('{:08x}'.format(0));

def fixgid(chunk):
    return str.encode('{:08x}'.format(0));

def fixmode(chunk):
    chunk=chunk.lower();
    if chunk==b'0000a1ff':
        chunk=b'0000a1e8';
    return chunk;

def fixdevmajor(chunk):
    return str.encode('{:08x}'.format(0));

def fixdevminor(chunk):
    return str.encode('{:08x}'.format(0));

def fixmtime(chunk):
    return str.encode('{:08x}'.format(0));

def fixnlink(chunk):
    return str.encode('{:08x}'.format(1));

def getHeader(binary,writebinary):
    chunks = {};

    headerSize = 0;

    for chunk in ASCIIChunks:
        chunkSize=ASCIIChunks[chunk];
        #print("%s, %s" % (chunk,chunkSize))
        chunks[chunk]=binary.read(chunkSize);

        # fix chunk
        if 'fix'+chunk in dir(__main__):
            oldchunk=chunks[chunk];
            chunks[chunk]=getattr(__main__,'fix'+chunk)(chunks[chunk])
            fixedchunk=chunks[chunk];
            print('Fix %s: %s -> %s' % (chunk,oldchunk,fixedchunk));
        
        writebinary.write(chunks[chunk]);

        headerSize+=chunkSize;

    if chunks['magic'] != b'070701':
        raise Exception("Wah wah waah, magic number mismatch: %s" % chunks['magic']);

    chunks['filesize']=int(chunks['filesize'],16);
    chunks['namesize']=int(chunks['namesize'],16);

    headerSize+=chunks['namesize'];

    chunks['headerSize']=headerSize;

    chunks['filename']=binary.read(chunks['namesize']);

    writebinary.write(chunks['filename']);

    return chunks;

def fix(filename):
    print('Inode offset: %s' % inodeoffset);

    # open binary stream for reading
    with open(filename+'.fixed','wb') as writebinary:
        with open(filename,'rb') as binary:
            while True:
                #print("Header size: %s" % headerSize);
                info = getHeader(binary,writebinary);

                magic = info['magic'];
                filesize = info['filesize'];
                namesize = info['namesize'];

                #print("File size: %s" % (filesize));
                #print("Name size: %s" % (namesize));
                headerSize=info['headerSize'];

                #print('File name: %s' % (filename))


                # pad the header
                if (headerSize%4>0):
                    padding=4-headerSize%4;
                    #print('Padding header by %s (%s)' % (padding,headerSize+padding));
                    writebinary.write(binary.read(padding));

                # print file data
                #print('Data: %s' % (binary[chunkPos:chunkPos+filesize]));

                # read filename?
                #print('chunk: %s, name: %s' % (chunkPos,namesize));
                #print('file size: %s' % filesize);
                
                info['data']=binary.read(filesize);
                writebinary.write(info['data']);
                #print('data: %s' % data);

                # pad the file data
                if (filesize%4>0):
                    padding=4-filesize%4;
                    #print('Padding file data by %s (%s)' % (padding,filesize+padding));
                    writebinary.write(binary.read(padding));

                if info['filename']==trailer:
                    print('Done! :D');
                    print('Written '+filename+'.fixed');
                    return;

def help():
    print('Usage:');
    print('%s [filename]' % sys.argv[0]);

if len(sys.argv)==1:
    help();
else:
    filename = sys.argv[1];
    fix(filename);
