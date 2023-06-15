# Note that this script can accept some limited command-line arguments, run
# `julia build_tarballs.jl --help` to see a usage message.
using BinaryBuilder, Pkg

name = "Mutationjl"
version = v"1.0.5"

# Collection of sources required to complete build
sources = [
    GitSource("https://github.com/mutationpp/Mutationpp.git", "4cb6e3a05c15f49ffd346dc9f185ccc3459728b0")
]

# Bash recipe for building across all platforms
script = raw"""
cd $WORKSPACE/srcdir/Mutationpp/
mkdir build && cd build
cmake .. \
    -DCMAKE_INSTALL_PREFIX=${prefix} \
    -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TARGET_TOOLCHAIN} \
    -DCMAKE_BUILD_TYPE=Release
make -j${nproc}
make install
"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = supported_platforms()


# The products that we will ensure are always built
products = [
    LibraryProduct("libmutation++", :libmutationpp),
    ExecutableProduct("mppshock", :mppshock),
    ExecutableProduct("checkmix", :checkmix),
    ExecutableProduct("mppequil", :mppequil),
    ExecutableProduct("bprime", :bprime)
]

# Dependencies that must be installed before this package can be built
dependencies = Dependency[
]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, name, version, sources, script, platforms, products, dependencies; julia_compat="1.6", preferred_gcc_version = v"10.2.0")
