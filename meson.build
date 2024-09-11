project('akima86', 'fortran')

# Detect the Fortran compiler and set compiler flags
if get_option('fortran_link_args').contains('-liomp5')
  openmp = '-qopenmp'
  omp_lib = '-liomp5'
else
  openmp = '-fopenmp'
  omp_lib = '-lgomp'
endif

# Define the source files for the Fortran extension
srcs = ['src/uvipia_omp.f90']

# Create a shared library (Python extension module)
my_extension = shared_module('uvipia_omp',
                             srcs,
                             fortran_args : [openmp],
                             link_args : [omp_lib],
                             install: true)