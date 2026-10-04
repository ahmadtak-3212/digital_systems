import sys, re, numpy as np, matplotlib
matplotlib.use('Agg'); import matplotlib.pyplot as plt
pairs=re.findall(r"5'd\d+:\s*coeff = (-?)10'sd(\d+)", open('fir.sv').read())
c=np.array([int(n)*(-1 if sgn else 1) for sgn,n in pairs])/1024
assert len(c)==31, len(c)
f=np.linspace(1,24000,2000); w=2*np.pi*f/48000
H=np.abs(np.array([np.sum(c*np.exp(-1j*wi*np.arange(len(c)))) for wi in w]))
d=np.loadtxt('resp.txt')
fig,ax=plt.subplots(figsize=(9,4.5),dpi=130)
ax.plot(f/1000,20*np.log10(np.maximum(H,1e-5)),color='#2c5d8f',lw=2,label='ideal response of the 31 coefficients')
ax.plot(d[:,0]/1000,20*np.log10(np.maximum(d[:,1],1e-5)),'o',color='#c0392b',ms=6,label='measured: RTL simulation of fir31 (sine in, peak out)')
ax.axvline(3,color='gray',ls='--',lw=1); ax.text(3.15,-75,'3 kHz cutoff\n(−6 dB)',color='gray',fontsize=9)
ax.set_xlabel('frequency (kHz), 48 kHz sample rate'); ax.set_ylabel('gain (dB)'); ax.set_ylim(-80,5); ax.set_xlim(0,24)
ax.set_title('Lab 5 FIR low-pass: designed vs. hardware (simulated)'); ax.grid(alpha=.3); ax.legend(loc='upper right',fontsize=9)
plt.tight_layout(); plt.savefig(sys.argv[1])
