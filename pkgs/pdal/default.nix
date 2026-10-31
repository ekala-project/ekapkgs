{
  lib,
  stdenv,
  fetchFromGitHub,

  enableE57 ? true,

  cmake,
  curl,
  gdal,
  gtest,
  hdf5-cpp,
  laszip,
  libe57format,
  libgeotiff,
  libpq,
  libtiff,
  libxml2,
  openscenegraph,
  pkg-config,
  proj,
  sqlite,
  zlib,
  zstd,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pdal";
  version = "2.10.2";

  src = fetchFromGitHub {
    owner = "PDAL";
    repo = "PDAL";
    tag = finalAttrs.version;
    hash = "sha256-VxELHAiiFMKjsvgBK4Cm6YJSrs/4QhhF1haZv4/FlZg=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    curl
    gdal
    gtest
    hdf5-cpp
    laszip
    libgeotiff
    libpq
    libtiff
    libxml2
    openscenegraph
    proj
    sqlite
    zlib
    zstd
  ]
  ++ lib.optionals enableE57 [
    libe57format
  ];

  strictDeps = true;

  cmakeFlags = [
    "-DBUILD_PLUGIN_E57=${if enableE57 then "ON" else "OFF"}"
    "-DBUILD_PLUGIN_HDF=ON"
    "-DBUILD_PLUGIN_PGPOINTCLOUD=ON"
    "-DWITH_COMPLETION=ON"
    "-DWITH_TESTS=ON"
    "-DBUILD_PGPOINTCLOUD_TESTS=OFF"

    "-DBUILD_PLUGIN_CPD=OFF"
    "-DBUILD_PLUGIN_FBX=OFF"
    "-DBUILD_PLUGIN_GEOWAVE=OFF"
    "-DBUILD_PLUGIN_I3S=OFF"
    "-DBUILD_PLUGIN_ICEBRIDGE=OFF"
    "-DBUILD_PLUGIN_MATLAB=OFF"
    "-DBUILD_PLUGIN_MBIO=OFF"
    "-DBUILD_PLUGIN_MRSID=OFF"
    "-DBUILD_PLUGIN_NITF=OFF"
    "-DBUILD_PLUGIN_OCI=OFF"
    "-DBUILD_PLUGIN_RDBLIB=OFF"
    "-DBUILD_PLUGIN_RIVLIB=OFF"
    "-DBUILD_PLUGIN_TILEDB=OFF"
  ];

  doCheck = true;
  enableParallelChecking = false;

  postInstall = ''
    patchShebangs --update --build $out/bin/pdal-config
  '';

  meta = {
    description = "Point Data Abstraction Library. GDAL for point cloud data";
    homepage = "https://pdal.io";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.all;
  };
})
