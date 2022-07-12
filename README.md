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


Installation Guide
==================

This installation guide has installation steps specific to installing the akima86 package into a standard location.


System Requirements
---------------------

* Python >= 3.8
* Numpy and a Fortran compiler supported by f2py and OpenMP;
* Matplotlib for tests


Citation
---------------

Akima, H., 1986: A method of univariate interpolation that has
    the accuracy of a third-degree polynomial. NTIA Report 86-208. 76 pp.

    Permission to use, copy, modify, and distribute this software and its
    documentation for any purpose and without fee is hereby granted,
    provided that the above copyright notice appear in all copies and that
    both that copyright notice and this permission notice appear in
    supporting documentation. For published articles, please cite the
    "Citation" listed above.
    THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE,
    INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS. IN NO
    EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, INDIRECT OR
    CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF
    USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR
    OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
    PERFORMANCE OF THIS SOFTWARE.

                       -- David Ryglicki


Setup System Environment Variables
----------------------------------

```bash
    # These steps will need to be copied and pasted into your shell any time you want to run the 
    # setup commands within this README.
    
    # Typical users do not have to make any modifications to the commands
    # within this README, and can copy and paste directly.

    # REPO_URL should point to the base URL for git clone commands
    export REPO_URL=https://github.com/NRLMMD-GeoIPS

    # BASEDIR will contain all source, output, and external dependencies
    # Ensure this is consistently set for all installation / setup steps below
    export BASEDIR=$HOME/geoproc

```

Clone akima86 git repositories required for setup scripts
-------------------------------------------------------------
```bash
    mkdir -p $BASEDIR/packages/

    git clone $REPO_URL/akima86.git $BASEDIR/packages/akima86
    git -C $BASEDIR/packages/akima86 pull
    git -C $BASEDIR/packages/akima86 checkout -t origin/dev
    git -C $BASEDIR/packages/akima86 checkout dev
    git -C $BASEDIR/packages/akima86 pull
```

Install akima86 package
-------------------------
```bash
    # (to change default fortran compiler you can use e.g.
    #    python setup.py build config_fc --fcompiler=g95)
    $BASEDIR/packages/akima86/setup.sh install
```

Test akima86 installation - these test scripts provide you with the full command line calls
---------------------------------------------------------------------------------------------
```
    python $BASEDIR/packages/akima86/test/test_akima.py
```
