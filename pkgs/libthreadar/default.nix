{
  lib,
  stdenv,
  fetchurl,
  gcc-unwrapped,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "1.6.1";
  pname = "libthreadar";

  src = fetchurl {
    url = "mirror://sourceforge/libthreadar/libthreadar-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-RncJMgxUIVrIgp70joVtiQyqT2p4MWM9OZLgtTWfONg=";
  };

  outputs = [
    "out"
    "dev"
  ];

  buildInputs = [ gcc-unwrapped ];

  env.CXXFLAGS = toString [ "-std=c++14" ];

  configureFlags = [
    "--disable-build-html"
  ];

  postInstall = ''
    # Disable html help
    rm -r "$out"/share
  '';

  meta = {
    homepage = "https://libthreadar.sourceforge.net/";
    description = "C++ library that provides several classes to manipulate threads";
    longDescription = ''
      Libthreadar is a C++ library providing a small set of C++ classes to manipulate
      threads in a very simple and efficient way from your C++ code.
    '';
    license = lib.licenses.lgpl3;
    platforms = lib.platforms.unix;
  };
})
