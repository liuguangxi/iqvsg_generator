"""Create a 1 MHz tone at 80 MS/s with 100,000 complex samples."""

import numpy as np
from write_iqvsg import write_iqvsg

fs = 80_000_000
count = 100_000
f_tone = 1_000_000
n = np.arange(count)
iq = np.exp(1j * 2 * np.pi * f_tone * n / fs)

write_iqvsg('tone_1MHz.iqvsg', iq, fs)
print('Created tone_1MHz.iqvsg')
