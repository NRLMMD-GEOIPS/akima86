    # # # This source code is subject to the license referenced at
    # # # https://github.com/NRLMMD-GEOIPS.

# Installation Guide

Installation requires Python 3.8 or greater.

## Installing from PyPI
For many linux platforms, simply run `pip install akima86`.

For other platforms, `pip install akima86` should still work but a working installation
of gfortran must be present. This may be installed at a system level or via `conda`
using `conda install -c conda-forge gfortran`.

## Installing from Source
Installing from source requires:
- Python >= 3.8
- gfortran

To install from source:
- Clone the repository and change directories into the repository directory.
- Run `pip install .`

### Testing your source installation
From the cloned repository run:
```
python test/test_akima.py
```

# Citation

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
