#!/usr/bin/env python3

from string import Template
import os
import re


def get_version():
    with open(os.path.join(script_dir, '../DomeKey/main.m'), 'r') as f:
        for line in f:
            if 'VERSION' in line:
                version = re.search('"([\d.]+)"', line)[1]
                return version


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
    VERSION=get_version(),
    SHA256='unknown',
    PLIST=plist.rstrip(),
)

print(formula, end='')
