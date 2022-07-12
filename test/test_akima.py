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

from akima86 import akima86
import numpy as np
try:
  import matplotlib as mpl
  mpl.use('Agg')
  import matplotlib.pyplot as plt
  plotfig = True
except:
  plotfig = False

def trunc(values, decs=0):
    return np.trunc(values*10**decs)/(10**decs)

def test_threshold(norm, goal):
    if np.isclose(norm,goal):
        print(f"SUCCESS {norm}")
    else:
        print(f"FAILURE {norm}")
#
# Test data comes directly from Akima (1986)
# If both diff arrays are close to zero (3rd decimal point), then it works
#
xd = np.array( [1.0,2.0,4.0,6.5,8.0,10.0,10.5,11.0,13.0,14.0] )
yd = np.array( [0.0,0.0,0.0,0.0,0.1, 1.0, 4.5, 8.0,10.0,15.0] )
xi = np.linspace(0.0,15.0,31)

ytrue3 = np.array( [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
                    0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.015, 0.052,
                    0.100, 0.036, -0.045, 0.172, 1.000, 4.500, 8.000,10.075,
                    10.705, 10.483, 10.000, 11.204, 15.000, 19.767, 24.533] )

ytrue6 = np.array( [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
                    0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.020, 0.057,
                    0.100, 0.134, 0.166, 0.314, 1.000, 4.500, 8.000, 9.689,
                    10.101, 10.180, 10.000, 11.663, 15.000, 19.767, 24.533] )

ndeg = 3
yi = akima86.interpolate(xd,yd,xi,degree=ndeg)

ndeg = 6
yi2 = akima86.interpolate(xd,yd,xi,degree=ndeg)

# Since the Akima source data is only out to three decimal points,
# we should only be concerned if the differences propagate up to
# the third decimal point.

diff3 = np.linalg.norm(yi[:].round(decimals=3)-ytrue3[:],ord=np.inf)
diff6 = np.linalg.norm(yi2[:].round(decimals=3)-ytrue6[:],ord=np.inf)

print("Degree 3")
test_threshold(diff3,0.0)
print("Degree 6")
test_threshold(diff6,0.0)

if plotfig:
  fig = plt.figure(figsize=(5,4))
  ax = fig.add_subplot(1,1,1)
  ax.plot(xd,yd,'kx',label='Original')
  ax.plot(xi,yi,'r-',label='Akima86, 3')
  ax.plot(xi,yi2,'g-',label='Akima86, 6')
  ax.legend()
  ax.grid(True,linestyle=':')
  fig.savefig('akima86_test.png',dpi=200,bbox_inches='tight')
