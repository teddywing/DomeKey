#!/usr/bin/env python3

# Copyright (c) 2018  Teddy Wing
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program. If not, see <https://www.gnu.org/licenses/>.

from hashlib import sha256
from string import Template
import os
import re


def get_version():
    with open(os.path.join(script_dir, '../DomeKey/main.m'), 'r') as f:
        for line in f:
            if 'VERSION' in line:
                version = re.search('"([\d.]+)"', line)[1]
                return version

def archive_sha():
    with open(
        os.path.join(script_dir, '../dome-key_{}.tar.bz2'.format(get_version())),
        'rb'
    ) as f:
        m = sha256()
        m.update(f.read())
        return m.hexdigest()


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
    SHA256=archive_sha(),
    PLIST=plist.rstrip(),
)

print(formula, end='')
