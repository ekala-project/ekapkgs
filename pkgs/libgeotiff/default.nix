{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  libjpeg,
  libtiff,
  proj,
  zlib,
}:

stdenv.mkDerivation rec {
  version = "1.7.4";
  pname = "libgeotiff";

  src = fetchFromGitHub {
    owner = "OSGeo";
    repo = "libgeotiff";
    rev = version;
    hash = "sha256-oiuooLejCRI1DFTjhgYoePtKS+OAGnW6OBzgITcY500=";
  };

  outputs = [
    "out"
    "dev"
  ];

  sourceRoot = "${src.name}/libgeotiff";

  configureFlags = [
    "--with-jpeg=${libjpeg.dev}"
    "--with-zlib=${zlib.dev}"
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    libtiff
    proj
    zlib
  ];

  meta = {
    description = "Library implementing attempt to create a tiff based interchange format for georeferenced raster imagery";
    homepage = "https://github.com/OSGeo/libgeotiff";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
  };
}
