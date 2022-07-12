#### # # Distribution Statement A. Approved for public release. Distribution unlimited.
#### # # 
#### # # Author:
#### # # Naval Research Laboratory, Marine Meteorology Division
#### # # 
#### # # This program is free software:
#### # # you can redistribute it and/or modify it under the terms
#### # # of the NRLMMD License included with this program.
#### # # 
#### # # If you did not receive the license, see
#### # # https://github.com/U-S-NRL-Marine-Meteorology-Division/
#### # # for more information.
#### # # 
#### # # This program is distributed WITHOUT ANY WARRANTY;
#### # # without even the implied warranty of MERCHANTABILITY
#### # # or FITNESS FOR A PARTICULAR PURPOSE.
#### # # See the included license for more details.


# v0.1.1: 2022-06-09, add intel compiler support

### Improvements
* **Installation**
    * Update setup\_akima86.sh install\_akima86 -> setup.sh install
    * Add support for intel compiler in setup.py (requires GEOIPS\_FORTRAN\_COMPILER=intelem)

### Documentation Updates
* **Add standard README.md**
    * NRL github installation steps
    * Direct python test script call
    * Does NOT include full GeoIPS installation

###  1.5.0post1 Post Release Patch (2022-06-10)

#### Documentation Updates
* Add system requirements section, noting system requirements beyond what is listed in installation steps directly
    * Fortran compiler supported by f2py, for akima86 build
    * git > 2.19.1, for git -C


# v0.1.0: 2021-04-16, Initial implementation

### Major New Functionality
* **uvipia**
    * Univariate Interpolation (improved Akima metod)
        * Original code by H. Akima, 1986
        * Modified for modern Fortran by D. Ryglicki, Monterey, CA, 2020.
