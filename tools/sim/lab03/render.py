import sys, glob
from PIL import Image
out=sys.argv[1]
px=lambda p:(((p>>8)&15)*17,((p>>4)&15)*17,(p&15)*17)
v=[int(x,16) for x in open('frame.txt').read().split()]
im=Image.new('RGB',(1024,768)); im.putdata([px(p) for p in v[:1024*768]]); im.save(f'{out}/lab03_pong_frame.png')
fr=[]
for f in sorted(glob.glob('frames/*.txt')):
    v=[int(x,16) for x in open(f).read().split()]
    if len(v)<256*192: continue
    im=Image.new('RGB',(256,192)); im.putdata([px(p) for p in v[:256*192]]); fr.append(im.resize((512,384),Image.NEAREST))
fr[0].save(f'{out}/lab03_pong.gif',save_all=True,append_images=fr[1:],duration=60,loop=0,optimize=True)
