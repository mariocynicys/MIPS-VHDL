#!/usr/bin/env python3

from os import listdir, path
from subprocess import run

DIR_NAME = path.abspath(path.dirname(__file__))
GEN_BUF = path.join(DIR_NAME, 'gen_buf.py')

[run([GEN_BUF, tf]) for tf in listdir(DIR_NAME) if tf.endswith((".t",))]
