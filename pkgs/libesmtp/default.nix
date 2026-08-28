{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  openssl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libESMTP";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "libesmtp";
    repo = "libESMTP";
    rev = "v${finalAttrs.version}";
    sha256 = "1bhh8hlsl9597x0bnfl563k2c09b61qnkb9mfyqcmzlq63m1zw5y";
  };

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
  ];

  buildInputs = [ openssl ];

  mesonFlags = lib.optional (stdenv.hostPlatform.libc == "glibc") "-Dc_args=-D_DEFAULT_SOURCE";

  meta = {
    description = "Library for Posting Electronic Mail";
    homepage = "https://libesmtp.github.io/";
    license = lib.licenses.lgpl21Plus;
  };
})
