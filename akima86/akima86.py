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

# Author:
#    Naval Research Laboratory, Marine Meteorology Division
#
# This program is free software: you can redistribute it and/or modify it under
# the terms of the NRLMMD License included with this program.  If you did not
# receive the license, see http://www.nrlmry.navy.mil/<LICENSE_INFO> for more
# information.
# This program is distributed WITHOUT ANY WARRANTY; without even the implied
# warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# included license for more details.
#!/usr/bin/env python3

import numpy as np
from uvipia_omp import uvipia

def interpolate(xd, yd, xi, degree=3):
  '''
  Python wrapper for the Improved Akima method from Akima (1986).

  Parameters
  ----------
  xd : Numpy ndarry
      Numpy array of input x coordinates. Must be monotonically
      increasing. Fails in Fortran.
  yd : Numpy ndarray
      Numpy array of input y coordinates. Must be monotonically
      increasing. Fails in Fortran.
  xi : Numpy ndarray
      Numpy array of output x coordinates. Can be in any order.
      Will be more efficient if monotonic.
  degree : Integer
      Polynomial order. Default: 3.

  Returns
  -------
  yi : Numpy ndarray
      Numpy array of output y coordinates, same length as xi.

  NOTES
  -----
  - In the UVIPIA Fortran code, any polynomial orders less than 3
    are automatically set to 3.
  - Technically, Akima's code only has the accuracy of a third-order
    polynomial, so while one can use higher-order polynomials, the 
    internal logic is not designed to take advantage of that.
  - All internal calls to UVIPIA are up-rezzed to double precision.
  - Since this is directly calling the Fortran, for date/times, they
    probably need to be converted to seconds-from-initial.
  '''
  if not isinstance(xd,(np.ndarray)):
    raise Exception('xd must be a numpy array.')

  if not isinstance(yd,(np.ndarray)):
    raise Exception('yd must be a numpy array.')

  if not isinstance(xi,(np.ndarray)):
    raise Exception('xi must be a numpy array.')

  if len(xd) != len(yd):
    raise Exception('xd and yd must be the same length.')

  if not isinstance(degree, (int, np.int8, np.int16, np.int32, np.int64)):
    degree = degree.astype(int, copy=False)

  if xd.dtype != np.float64:
    xd = xd.astype(np.float64, copy=False)

  if yd.dtype != np.float64:
    yd = yd.astype(np.float64, copy=False)

  if xi.dtype != np.float64:
    xi = xi.astype(np.float64, copy=False)

  yi = np.empty(len(xi))
  yi.fill(np.nan)

  yi = uvipia(degree, xd, yd, xi)

  return yi

def main():
  import matplotlib as mpl
  mpl.use('Agg')
  import matplotlib.pyplot as plt
  
# xd = np.linspace(0.,10.,11)
# yd = xd*xd*xd*np.exp(-xd)

  xd = np.array( [1.0,2.0,4.0,6.5,8.0,10.0,10.5,11.0,13.0,14.0] )
  yd = np.array( [0.0,0.0,0.0,0.0,0.1, 1.0, 4.5, 8.0,10.0,15.0] )
  xi = np.linspace(-1.0,15.,100)

  ndeg = 3
  yi = interpolate(xd,yd,xi,degree=ndeg)

  ndeg = 6
  yi2 = interpolate(xd,yd,xi,degree=ndeg)

  fig = plt.figure(figsize=(5,4))
  ax = fig.add_subplot(1,1,1)
  ax.plot(xd,yd,'ro',label='Original')
  ax.plot(xi,yi,'b-',label='Akima86, 3')
  ax.plot(xi,yi2,'g-',label='Akima86, 6')
  ax.legend()
  ax.grid(True,linestyle=':')
  fig.savefig('akima_example.png',dpi=200,bbox_inches='tight')

if __name__ == '__main__':
  main()
