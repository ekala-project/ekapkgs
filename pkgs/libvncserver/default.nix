{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  libjpeg,
  openssl,
  zlib,
  libgcrypt,
  libpng,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libvncserver";
  version = "0.9.15";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "LibVNC";
    repo = "libvncserver";
    tag = "LibVNCServer-${finalAttrs.version}";
    hash = "sha256-a3acEjJM+ZA9jaB6qZ/czjIfx/L3j71VjJ6mtlqYcSw=";
  };

  patches = [
    ./pkgconfig.patch

    (fetchpatch {
      name = "libvncserver-fix-cmake-4.patch";
      url = "https://github.com/LibVNC/libvncserver/commit/e64fa928170f22a2e21b5bbd6d46c8f8e7dd7a96.patch";
      hash = "sha256-AAZ3H34+nLqQggb/sNSx2gIGK96m4zatHX3wpyjNLOA=";
    })
  ];

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];

  cmakeFlags = [
    (lib.cmakeBool "WITH_SYSTEMD" false)
    (lib.cmakeBool "BUILD_SHARED_LIBS" true)
    (lib.cmakeBool "WITH_EXAMPLES" false)
    (lib.cmakeBool "WITH_TESTS" false)
  ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail 'add_test(NAME includetest COMMAND' '# add_test(NAME includetest COMMAND'
  '';

  buildInputs = [
    libjpeg
    openssl
    libgcrypt
    libpng
  ];

  propagatedBuildInputs = [
    zlib
  ];

  meta = {
    description = "VNC server library";
    homepage = "https://libvnc.github.io/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
  };
})
