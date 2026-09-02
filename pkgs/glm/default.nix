{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "glm";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "g-truc";
    repo = "glm";
    tag = finalAttrs.version;
    hash = "sha256-6WnVvFiTe1/OYj/oTGpCjZKNFurR9MxJ4zf0nDg0Alk=";
  };

  outputs = [
    "out"
    "doc"
  ];

  patches = lib.optionals stdenv.hostPlatform.isLinux [
    ./1001-glm-Fix-packing-on-BE.patch
  ];

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];

  env.NIX_CFLAGS_COMPILE =
    if (stdenv.cc.isGNU && lib.versionAtLeast stdenv.cc.version "11") then
      "-fno-ipa-modref"
    else if (stdenv.cc.isClang) then
      "-Wno-error"
    else
      "";

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED_LIBS" false)
    (lib.cmakeBool "BUILD_STATIC_LIBS" false)
    (lib.cmakeBool "GLM_TEST_ENABLE" finalAttrs.doCheck)
  ];

  doCheck = true;

  postInstall = ''
    mkdir -p $out/lib/pkgconfig
    substituteAll ${./glm.pc.in} $out/lib/pkgconfig/glm.pc

    mkdir -p $doc/share/doc/glm
    cp -rv ../doc/api $doc/share/doc/glm/html
    cp -v ../doc/manual.pdf $doc/share/doc/glm
  '';

  meta = {
    description = "OpenGL Mathematics library for C++";
    homepage = "https://github.com/g-truc/glm";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    broken = !stdenv.hostPlatform.isLittleEndian && !stdenv.hostPlatform.isLinux;
  };
})
