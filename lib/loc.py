import os,pathlib


loc = 0
nof = 0

def count_lines(dir:str):
    print("dir {}".format(dir))
    global loc
    global nof
    os.chdir(dir)
    for fil in os.listdir():
        if os.path.isdir(fil):
            count_lines(fil)
        else:
            nof+=1
            fh = open(fil)
            for line in fh:
                if not (line.startswith('import')) :
                    loc+=1
            fh.close()
    os.chdir('..')
                


count_lines('.')
print('number of lines code: {}'.format(loc) )
print('number of files : {}'.format(nof) )