#!python
from __future__ import print_function

import os, sys


class encodedBytes(bytes):
	def __init__(self, value):
		self.value = self.__class__.strdecode(value)

	def encoded(self, encoding):
		return self.value.encode(encoding)

	@staticmethod
	def strdecode(encoded_bytes):
		for encoding in ('utf-8-sig', 'utf-16'):
			try:
				return encoded_bytes.decode('utf-8-sig')
			except UnicodeDecodeError:
				continue   # some error here is expected, try next encoding

		return encoded_bytes.decode('latin-1')


def encode_file(filename):
	with open(filename, "r+b") as fp:
		data = encodedBytes(fp.read())

	with open(filename, "w+b") as fp:
		data = data.encoded("utf-8")
		print(data)
		fp.write(data)


if __name__ == '__main__':
	for arg in sys.argv[1:]:
		encode_file(arg)