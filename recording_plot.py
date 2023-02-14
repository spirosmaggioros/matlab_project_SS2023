import matplotlib.pyplot as plt
import numpy as np
import wave
import sys

spf = wave.open("spiros.wav" , "r")

#με άφηνε εως 24000 , γιατί τόσο είχε και το σήμα , το plot σε .wav files δουλευει και
#μονο του ομως εγω το έβαλα γιατί το χρησιμοποιούμε και στην python
t = np.linspace(0,3,24000)
signal = spf.readframes(-1)
signal = np.fromstring(signal , "int16")
plt.figure(1)
plt.title("Audio recording Graph")
plt.plot(t , signal)
plt.show()
