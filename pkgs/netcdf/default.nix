{
  lib,
  stdenv,
  fetchurl,
  unzip,
  hdf5,
  bzip2,
  libzip,
  zstd,
  libaec,
  libxml2,
  m4,
  curl,
  removeReferencesTo,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "netcdf";
  version = "4.9.3";

  src = fetchurl {
    url = "https://downloads.unidata.ucar.edu/netcdf-c/${finalAttrs.version}/netcdf-c-${finalAttrs.version}.tar.gz";
    hash = "sha256-pHQUmETmFEVmZz+s8Jf+olPchDw3vAp9PeBH3Irdpd0=";
  };

  postPatch = ''
    patchShebangs .

    for a in ncdap_test/Makefile.am ncdap_test/Makefile.in; do
      substituteInPlace $a --replace testurl.sh " "
    done

    substituteInPlace nczarr_test/Makefile.in \
      --replace '#!/bin/bash' '${stdenv.shell}'
  '';

  nativeBuildInputs = [
    m4
    removeReferencesTo
    libxml2
  ];

  buildInputs = [
    curl
    hdf5
    libxml2
    bzip2
    libzip
    zstd
    libaec
  ];

  strictDeps = true;

  configureFlags = [
    "--enable-netcdf-4"
    "--enable-dap"
    "--enable-shared"
    "--disable-dap-remote-tests"
    "--with-plugin-dir=${placeholder "out"}/lib/hdf5-plugins"
  ];

  enableParallelBuilding = true;

  disallowedReferences = [ stdenv.cc ];

  postFixup = ''
    remove-references-to -t ${stdenv.cc} "$(readlink -f $out/lib/libnetcdf.settings)"
  '';

  doCheck = false;

  meta = {
    description = "Libraries for the Unidata network Common Data Format";
    homepage = "https://www.unidata.ucar.edu/software/netcdf/";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
  };
})
