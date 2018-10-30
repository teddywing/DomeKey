#!/usr/bin/env python3

from string import Template
import os


script_dir = os.path.dirname(__file__)

homebrew_template = ''
plist = ''

with open(os.path.join(script_dir, 'dome-key.in.rb'), 'r') as template:
    homebrew_template = template.read()

with open(os.path.join(script_dir, 'com.teddywing.dome-key.plist'), 'r') as f:
    for line in f:
        plist += '    {}'.format(line)

template = Template(homebrew_template)
formula = template.substitute(
    VERSION='test',
    SHA256='unknown',
    PLIST=plist.rstrip(),
)

print(formula, end='')
