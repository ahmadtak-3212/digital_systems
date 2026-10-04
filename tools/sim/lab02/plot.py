import sys, numpy as np, matplotlib
matplotlib.use('Agg'); import matplotlib.pyplot as plt
out=sys.argv[1]
t,tr,d=np.loadtxt('tx.txt',unpack=True); t=t/1000; t0=t[np.argmax(tr>0)]; t=t-t0
m=(t>-15)&(t<105); t,tr,d=t[m],tr[m],d[m]
s=t[np.argmax((t>0)&(d==0))]
fig,ax=plt.subplots(figsize=(10,3.2),dpi=130)
ax.step(t,d,where='post',color='#2c5d8f',lw=2); ax.step(t,tr*0.6+1.6,where='post',color='#c0392b',lw=1.5)
ax.text(-14,1.75,'trigger (button edge)',color='#c0392b',fontsize=9); ax.text(-14,1.08,'data_out (UART TX)',color='#2c5d8f',fontsize=9)
bit=8.68
for i,l in enumerate(['start']+[f'b{i}={(0x41>>i)&1}' for i in range(8)]+['stop']):
    ax.text(s+bit*i+bit/2,-0.35,l,ha='center',fontsize=8); ax.axvline(s+bit*i,color='gray',lw=0.5,ls=':')
ax.set_ylim(-0.6,2.4); ax.set_yticks([]); ax.set_xlim(-15,105)
ax.set_xlabel('time after button press (µs)   ·   one bit = 868 clocks at 100 MHz = 8.68 µs → 115 200 baud')
ax.set_title("Lab 2.5 serial_tx sending 0x41 ('A'): simulated output, 8N1, LSB first")
plt.tight_layout(); plt.savefig(f'{out}/lab02_5_uart_tx_wave.png')
t,b,c=np.loadtxt('db.txt',unpack=True); t=t/1e6
fig,ax=plt.subplots(figsize=(10,3),dpi=130)
ax.step(t,b+1.5,where='post',color='#c0392b',lw=1.2); ax.step(t,c,where='post',color='#2c5d8f',lw=2)
ax.text(t[0],2.65,'bouncey_in (button)',color='#c0392b',fontsize=9); ax.text(t[0],1.15,'clean_out',color='#2c5d8f',fontsize=9)
ax.set_yticks([]); ax.set_ylim(-0.3,3); ax.set_xlabel('time (ms)'); ax.set_title('Lab 2 debounce: output changes only after the input is stable for 10 ms (1,000,000 clocks)')
plt.tight_layout(); plt.savefig(f'{out}/lab02_debounce_wave.png')
