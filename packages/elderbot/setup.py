#!/usr/bin/env python
from setuptools import setup, find_packages

setup(
    name='elderbot',
    version='1.0',
    packages=find_packages(where='src'),
    package_dir={'':'src'},
    include_package_data=True,
    entry_points={
        'console_scripts': [
            'elderbot = elderbot:main',
        ],
    },
)
