"""Write complex IQ samples to the specified LitePoint IQVSG format."""

import numpy as np


def write_iqvsg(filename, iq, fs, normalize=True):
    """Write interleaved little-endian float32 IQ with an ASCII header."""
    if not np.isscalar(fs) or not np.isfinite(fs) or fs <= 0 or fs != int(fs):
        raise ValueError("fs must be a positive integer in Hz")

    iq = np.asarray(iq, dtype=np.complex128)
    if iq.ndim != 1 or iq.size == 0 or not np.all(np.isfinite(iq)):
        raise ValueError("iq must be a nonempty, finite 1-D array")

    if normalize:
        power = np.mean(np.abs(iq) ** 2)
        if not np.isfinite(power) or power == 0:
            raise ValueError("IQ average power must be finite and nonzero")
        iq = iq / np.sqrt(power)

    header = f'''<LPHeader version="0.3">
<General>
<Description>
</Description>
<FileType>LitePoint VSG waveform file</FileType>
<Encoding>False</Encoding>
<DateTime>2016/06/06 12:32:28</DateTime>
<IDN>LitePoint,IQXEL,IQXL01440,1.20.0.167857</IDN>
</General>
<DataInfo>
<SamplingRate>{int(fs)}</SamplingRate>
<SampleCount>{iq.size}</SampleCount>
</DataInfo>
</LPHeader>'''

    # Store I0, Q0, I1, Q1, ... as float32 little-endian.
    data = np.empty(2 * iq.size, dtype='<f4')
    data[0::2] = iq.real
    data[1::2] = iq.imag

    with open(filename, 'wb') as f:
        f.write(header.encode('ascii'))
        f.write(data.tobytes())
