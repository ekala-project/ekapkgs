{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  perl,
  zlib,
  libxml2,
  eigen,
  python3,
  cairo,
  pkg-config,
  swig,
  rapidjson,
  boost,
}:

stdenv.mkDerivation rec {
  pname = "openbabel";
  version = "unstable-06-12-23";

  src = fetchFromGitHub {
    owner = "openbabel";
    repo = pname;
    rev = "32cf131444c1555c749b356dab44fb9fe275271f";
    hash = "sha256-V0wrZVrojCZ9Knc5H6cPzPoYWVosRZ6Sn4PX+UFEfHY=";
  };

  postPatch = ''
    sed '1i#include <ctime>' -i include/openbabel/obutil.h
  '';

  buildInputs = [
    perl
    zlib
    libxml2
    eigen
    python3
    cairo
    rapidjson
    boost
  ];

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    swig
    pkg-config
  ];

  cmakeFlags = [
    "-DRUN_SWIG=ON"
    "-DPYTHON_BINDINGS=ON"
    "-DPYTHON_INSTDIR=${placeholder "out"}/${python3.sitePackages}"
    "-DWITH_MAEPARSER=OFF"
    "-DWITH_COORDGEN=OFF"
  ];

  postFixup = ''
    cat << EOF > $out/${python3.sitePackages}/setup.py
    from setuptools import setup

    setup(
        name = 'pyopenbabel',
        version = '3.2b1',
        packages = ['openbabel'],
        package_data = {'openbabel' : ['_openbabel.so']}
    )
    EOF
  '';

  meta = {
    description = "Toolbox designed to speak the many languages of chemical data";
    homepage = "http://openbabel.org";
    platforms = lib.platforms.all;
    license = lib.licenses.gpl2Plus;
  };
}
