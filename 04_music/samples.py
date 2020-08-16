import math

SAMPLES = [
    ('cd4', 5.0),
    ('f4', 5.0),
    ('a4', 5.0),
    ('cd5', 5.0),
    ('f5', 5.0),
    ('a5', 5.0)
]

class SampleEncoder:
    def __init__(self):
        self._marks = []
        self._content = []
        self._clipped_count = 0

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
        self._clipped_count = 0
        self._marks.append((name.upper(), len(self._content)))

    def flush(self):
        pass

    def append(self, sample):
        intval = 127 + int(round(sample * 127))
        if intval > 255:
            clipped = 255
            self._clipped_count += 1
        elif intval < 0:
            clipped = 0
            self._clipped_count += 1
        else:
            clipped = intval
        self.content.append(clipped & 0xff)


def main():
    enc = SampleEncoder()

    for name, mul in SAMPLES:
        with open('samples/{}.raw'.format(name), "rb") as reader:
            enc.reset(name)
            for _ in range(4000):
                sample = reader.read(2) # skip
                sample = reader.read(2)
                value = int.from_bytes(sample, byteorder='little', signed=True)
                enc.append(mul * value / 32768.0)
            enc.flush()
            print('file {} clipped count {}'.format(name, enc.clipped_count))

    with open('output/samples.txt', 'w') as writer:
        for i, sample in enumerate(enc.content):
            writer.write('{:02x}'.format(sample))
            if i != len(enc.content) - 1:
                writer.write('\n')

    with open('output/samples.v', 'w') as writer:
        writer.write('`define SAMPLES_LENGTH {}\n'.format(len(enc.content)))
        for name, offset in enc.marks:
            writer.write('`define SAMPLE_{} 15\'d{}\n'.format(name, offset))

    print('total size: {} bits'.format(len(enc.content) * 8))


if __name__ == "__main__":
    main()