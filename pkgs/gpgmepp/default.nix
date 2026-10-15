{
  lib,
  stdenv,
  fetchurl,
  cmake,
  gpgme,
  libgpg-error,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gpgmepp";
  version = "2.2.0";

  src = fetchurl {
    url = "mirror://gnupg/gpgmepp/gpgmepp-${finalAttrs.version}.tar.xz";
    hash = "sha256-ZlHF9/gBVD1bZ2cZ35/sgFOwpvWrpAuYyg0r7hETbzA=";
  };

  postPatch = ''
    # remove -unknown suffix from pkgconfig version
    substituteInPlace cmake/modules/G10GetFullVersion.cmake \
      --replace-fail '"''${version}-unknown"' '"''${version}"'
  '';

  outputs = [
    "out"
    "dev"
  ];

  patches = [
    ./0001-Fix-handling-of-absolute-install-dirs-in-.pc-install.patch
    ./0001-Don-t-hardcode-include-as-includedir.patch
  ];

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];

  propagatedBuildInputs = [
    gpgme
    libgpg-error
  ];

  meta = {
    description = "C++ bindings/wrapper for GPGME";
    homepage = "https://dev.gnupg.org/source/gpgmepp";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.unix;
  };
})
