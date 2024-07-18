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

"""Installation instructions for akima86 inteprpolation routine"""

import os
from os.path import realpath, join, dirname
from numpy.distutils.core import setup, Extension

with open(
    join(dirname(realpath(__file__)), "VERSION"), encoding="utf-8"
) as version_file:
    version = version_file.read().strip()

with open(
    join(dirname(realpath(__file__)), "README.md"), encoding="utf-8"
) as readme_file:
    long_description = readme_file.read()

packages = ["akima86"]
package_dir = {"akima86": "akima86"}

srcs = ["src/uvipia_omp.f90"]
if os.getenv("GEOIPS_FORTRAN_COMPILER") == "ifort":
    os.environ["CC"] = "icc"
    os.environ["F90"] = "ifort"
    os.environ["F77"] = "ifort"
    ext = Extension(
        "uvipia_omp",
        srcs,
        extra_f90_compile_args=["-qopenmp"],
        extra_f77_compile_args=["-qopenmp"],
        extra_compile_args=["-qopenmp"],
        extra_link_args=["-liomp5"],
    )
else:
    ext = Extension(
        "uvipia_omp",
        srcs,
        extra_f90_compile_args=["-fopenmp"],
        extra_f77_compile_args=["-fopenmp"],
        extra_compile_args=["-fopenmp"],
        extra_link_args=["-lgomp"],
    )

setup(
    name="akima86",
    version=version,
    description="Improved Akima 1-D Interpolation Method",
    long_description=long_description,
    long_description_content_type="text/markdown",
    author="Hitoshi Akima (original), David Ryglicki (F2003/OpenMP/PY implementation)",
    author_email="david.ryglicki@gmail.com",
    ext_modules=[ext],
    packages=packages,
    package_dir=package_dir,
    install_requires=["numpy", "matplotlib"],
)
