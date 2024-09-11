# # # Distribution Statement A. Approved for public release. Distribution unlimited.
# # #
# # # Author:
# # # Naval Research Laboratory, Marine Meteorology Division
# # #
# # # This program is free software:
# # # you can redistribute it and/or modify it under the terms
# # # of the NRLMMD License included with this program.
# # #
# # # If you did not receive the license, see
# # # https://github.com/U-S-NRL-Marine-Meteorology-Division/
# # # for more information.
# # #
# # # This program is distributed WITHOUT ANY WARRANTY;
# # # without even the implied warranty of MERCHANTABILITY
# # # or FITNESS FOR A PARTICULAR PURPOSE.
# # # See the included license for more details.

"""Installation instructions for akima86 inteprpolation routine."""

from setuptools import setup
from os.path import realpath, join, dirname

with open(
    join(dirname(realpath(__file__)), "VERSION"), encoding="utf-8"
) as version_file:
    version = version_file.read().strip()

setup(
    name="akima86",
    version=version,
    description="Improved Akima 1-D Interpolation Method",
    author="Hitoshi Akima (original), David Ryglicki (F2003/OpenMP/PY implementation)",
    author_email="david.ryglicki@gmail.com",
    packages=["akima86"],
    package_dir={"akima86": "akima86"},
    install_requires=["numpy", "matplotlib"],
    setup_requires=["meson-python"],
    # Use meson as the build backend
    meson_args=["--prefix", "{prefix}"],
)
