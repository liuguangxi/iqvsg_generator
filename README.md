# IQVSG File Generator

## Introduction

This generator converts complex baseband I/Q sample data into an `iqvsg` file for use with LitePoint's VSG function.


## File Structure

The `iqvsg` file structure is as follows:
```
--------------------
| ASCII XML Header |
+------------------+
| Binary I/Q Data  |
--------------------
```

The ASCII XML header contains:
```xml
<LPHeader version="0.3">
<General>
<Description>
</Description>
<FileType>LitePoint VSG waveform file</FileType>
<Encoding>False</Encoding>
<DateTime>2016/06/06 12:32:28</DateTime>
<IDN>LitePoint,IQXEL,IQXL01440,1.20.0.167857</IDN>
</General>
<DataInfo>
<SamplingRate>80000000</SamplingRate>
<SampleCount>10000</SampleCount>
</DataInfo>
</LPHeader>
```
The `SamplingRate` parameter can be 40000000, 80000000, etc., depending on the instrument model. The `SampleCount` parameter must be a positive integer.

The format of the binary I/Q data is:
```
I(0): little-endian float32
Q(0): little-endian float32
I(1): little-endian float32
Q(1): little-endian float32
...
```
Each complex sample occupies 8 bytes. Therefore, the total size of the binary I/Q data should be `SampleCount * 8` bytes.


## Codes

The `src` directory contains Python and MATLAB scripts (`write_iqvsg.py` and `write_iqvsg.m`) for generating `iqvsg` files.

Each example script generates a `tone_1MHz.iqvsg` file containing a 1 MHz complex single-tone signal sampled at 80 MHz.

Custom complex baseband signals may require sample-rate conversion and power normalization before waveform files can be generated for the target instrument.


## Verification

Sample `iqvsg` files and files generated from custom signals have been loaded onto an actual LitePoint instrument and verified using loopback transmission and reception.
