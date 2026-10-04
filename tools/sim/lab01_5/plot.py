import sys
from PIL import Image, ImageDraw, ImageFont
rows=[l.split() for l in open(sys.argv[1])]
W,H=95,150; im=Image.new('RGB',(16*W+20,H+50),'#111'); d=ImageDraw.Draw(im)
try: f=ImageFont.truetype('DejaVuSans.ttf',14)
except OSError: f=ImageFont.load_default()
segs={0:((20,15),(65,25)),1:((65,25),(75,70)),2:((65,80),(75,125)),3:((20,125),(65,135)),4:((10,80),(20,125)),5:((10,25),(20,70)),6:((20,70),(65,80))}
for k,(i,bits) in enumerate(rows):
    v=int(bits,2); x0=10+k*W
    for s,((a,b),(c,e)) in segs.items():
        d.rectangle([x0+a,10+b,x0+c,10+e],fill=(255,40,40) if (v>>s)&1 else (45,20,20))
    d.text((x0+18,H+15),f"in {int(i):04b}",fill='#bbb',font=f)
im.save(sys.argv[2])
