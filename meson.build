# cspell:ignore akima, cpython, fopenmp, lgomp, uvipia
project('akima86', 'fortran')

py = import('python').find_installation(pure: false)
py_exec = py.full_path()

env = environment()
env.set('LDFLAGS', '-fopenmp -lgomp')
env.set('FFLAGS', '-fopenmp')
env.set('OPT', '-fopenmp')

# Set up variables
module_name = 'uvipia_omp'
src_file = 'src/uvipia_omp.f90'
pyf_file = 'uvipia_omp.pyf'
# This will collect the appropriate extension suffix for the current Python version
# platform, and architecture.
ext_suffix = run_command(
    py_exec,
    '-c',
    'import sysconfig; print(sysconfig.get_config_var("EXT_SUFFIX"))',
    check: true
).stdout().strip()
so_file = module_name + ext_suffix

# Generate .pyf signature file from Fortran source
generate_pyf = custom_target(
    'generate_pyf',
    input: src_file,
    output: pyf_file,  # Output will automatically go to @PRIVATE_DIR@ without specifying
    command: [
        py_exec, '-m', 'numpy.f2py', '@INPUT@',
        '-m', module_name, '-h', '@OUTPUT@', '--overwrite-signature'
    ],
    install: false
)

# Build the extension module (shared object) from .pyf and .f90
build_ext = custom_target(
    'build_extension',
    input: [generate_pyf, src_file],
    output: so_file,
    command: [
        py_exec, '-m', 'numpy.f2py', '-c',
        '@INPUT@', '-m', module_name
    ],
    install: true,
    install_dir: join_paths(py.get_install_dir(), meson.project_name()),
    env: env
)

py.install_sources(
  [meson.project_name() + '/__init__.py', meson.project_name() + '/akima86.py'],
  subdir: meson.project_name()
)