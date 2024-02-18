#!/usr/bin/env python3
from setuptools import setup, find_packages

setup(
    name='sneksbot',
    version='1.0',
    packages=find_packages(where='src'),
    package_dir={'': 'src'},
    entry_points={
        'console_scripts': [
            'sneksbot = sneksbot:main',
        ],
    },
)
