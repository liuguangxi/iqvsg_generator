function write_iqvsg(filename, iq, fs, normalize)
% Write a LitePoint IQVSG file with interleaved float32 little-endian IQ.

if nargin < 4
    normalize = true;
end
if ~isscalar(fs) || ~isfinite(fs) || fs <= 0 || fs ~= fix(fs)
    error('fs must be a positive integer in Hz');
end
if ~isvector(iq) || isempty(iq) || any(~isfinite(iq(:)))
    error('iq must be a nonempty, finite vector');
end
iq = double(iq(:));

if normalize
    power = mean(abs(iq).^2);
    if ~isfinite(power) || power == 0
        error('IQ average power must be finite and nonzero');
    end
    iq = iq / sqrt(power);
end

header = sprintf([ ...
    '<LPHeader version="0.3">\n' ...
    '<General>\n' ...
    '<Description>\n' ...
    '</Description>\n' ...
    '<FileType>LitePoint VSG waveform file</FileType>\n' ...
    '<Encoding>False</Encoding>\n' ...
    '<DateTime>2016/06/06 12:32:28</DateTime>\n' ...
    '<IDN>LitePoint,IQXEL,IQXL01440,1.20.0.167857</IDN>\n' ...
    '</General>\n' ...
    '<DataInfo>\n' ...
    '<SamplingRate>%.0f</SamplingRate>\n' ...
    '<SampleCount>%.0f</SampleCount>\n' ...
    '</DataInfo>\n' ...
    '</LPHeader>'], fs, numel(iq));

% Interleave I and Q before writing float32 data.
data = zeros(2 * numel(iq), 1, 'single');
data(1:2:end) = single(real(iq));
data(2:2:end) = single(imag(iq));

fid = fopen(filename, 'wb', 'ieee-le');
if fid == -1
    error('Cannot open output file: %s', filename);
end
cleanup = onCleanup(@() fclose(fid));
fwrite(fid, uint8(header), 'uint8');
fwrite(fid, data, 'float32');
end
