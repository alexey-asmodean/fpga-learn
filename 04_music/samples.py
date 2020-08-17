import math
import wave

LOW_FREQ = 2700
HI_FREQ = 3800
LENGTH = 3300
SAMPLES = [
    ('cd2', LOW_FREQ, LENGTH, 2.8),
    ('f2', LOW_FREQ, LENGTH, 3.5),
    ('a2', LOW_FREQ, LENGTH, 2.4),
    ('cd3', LOW_FREQ, LENGTH, 3.0),
    ('f3', LOW_FREQ, LENGTH, 4.4),
    ('a3', LOW_FREQ, LENGTH, 5.6),
    ('cd4', HI_FREQ, LENGTH, 4.0),
    ('f4', HI_FREQ, LENGTH, 2.4),
    ('a4', HI_FREQ, LENGTH, 2.3),
    ('cd5', HI_FREQ, LENGTH, 4.0),
    ('f5', HI_FREQ, LENGTH, 5.0),
    ('a5', HI_FREQ, LENGTH, 5.0),
]

class SampleEncoder:
    def __init__(self, initial=0, mul=120, down=-120, top=120):
        self._marks = []
        self._content = []
        self._clipped_count = 0
        self._current = 0
        self._filled = 0
        self._last = initial
        self._mul = mul
        self._down = down
        self._top = top

    @property
    def content(self):
        return self._content

    @property
    def marks(self):
        return self._marks

    @property
    def clipped_count(self):
        return self._clipped_count

    def reset(self, name):
        self._last = 0
        self._clipped_count = 0
        self._marks.append((name.upper(), len(self._content)))

    def flush(self):
        self._content.append(self._current & 0xfffff)
        self._filled = max(self._filled - 20, 0)
        self._current = self._current >> 20 

    def append(self, sample):
        intval = int(round(sample * self._mul))
        if intval > self._top:
            clipped = self._top
            self._clipped_count += 1
        elif intval < self._down:
            clipped = self._down
            self._clipped_count += 1
        else:
            clipped = intval

        n = clipped - self._last
        self._last = clipped
        sign = 0
        if (n < 0):
            sign = 1
            n = -(n + 1)
        bits = math.ceil(math.log(n + 5, 2)) - 1
        prefix = (1 << (bits - 2)) - 1
        adjusted = n + 4 - (1 << bits) 
        assert bits <= 8

        encoded = prefix + (sign << (bits - 1)) + (adjusted << bits)
        self._current = self._current + (encoded << self._filled)
        self._filled += bits * 2
        if self._filled > 20:
            self.flush()



def main():
    enc = SampleEncoder()

    for name, rate, length, mul in SAMPLES:
        with wave.open(f'wav/{name}.wav', 'rb') as sound:
            source_rate = sound.getframerate()
            content = sound.readframes(source_rate * 2)

        enc.reset(name)
        loudness = 0
        for i in range(length):
            fo = round(i * source_rate / rate) * 6
            l = int.from_bytes(content[fo:fo + 3], byteorder='little', signed=True)
            r = int.from_bytes(content[fo + 3:fo + 6], byteorder='little', signed=True)
            sample = mul * (l + r) / 0x1000000
            loudness += sample ** 2
            enc.append(mul * (l + r) / 0x1000000)
        enc.flush()
        print('file {}: loudness {:2.1f} clipped count {}'.format(name, 100 * loudness / length, enc.clipped_count))

    assert len(enc.content) <= 12288

    with open('output/samples.txt', 'w') as writer:
        for i, sample in enumerate(enc.content):
            writer.write('{:04x}'.format(sample))
            if i != len(enc.content) - 1:
                writer.write('\n')

    with open('output/samples.v', 'w') as writer:
        writer.write('`define SAMPLES_LENGTH {}\n'.format(len(enc.content)))
        base = 349.228
        writer.write('`define HI_FREQ_DN 16\'d{}\n'.format(round(48000000 * base / (HI_FREQ * 329.628))))
        writer.write('`define HI_FREQ_EQ 16\'d{}\n'.format(round(48000000 / HI_FREQ)))
        writer.write('`define HI_FREQ_UP 16\'d{}\n'.format(round(48000000 * base / (HI_FREQ * 369.994))))
        writer.write('`define HI_FREQ_DU 16\'d{}\n'.format(round(48000000 * base / (HI_FREQ * 391.995))))
        writer.write('`define LO_FREQ_DN 16\'d{}\n'.format(round(48000000 * base / (LOW_FREQ * 329.628))))
        writer.write('`define LO_FREQ_EQ 16\'d{}\n'.format(round(48000000 / LOW_FREQ)))
        writer.write('`define LO_FREQ_UP 16\'d{}\n'.format(round(48000000 * base / (LOW_FREQ * 369.994))))
        writer.write('`define LO_FREQ_DU 16\'d{}\n'.format(round(48000000 * base / (LOW_FREQ * 391.995))))
        for name, offset in enc.marks:
            writer.write('`define SAMPLE_{} 14\'d{}\n'.format(name, offset))

    print('total size: {} bits'.format(len(enc.content) * 20))


if __name__ == "__main__":
    enc = SampleEncoder(128, 1, 0, 255)
    enc.append(129)
    enc.append(144)
    enc.append(1)
    enc.append(254)
    enc.append(8)
    enc.append(17)
    enc.append(0)
    enc.flush()
    for c in enc.content:
        print(bin(c))
    main()