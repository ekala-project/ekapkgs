{
  stdenv,
  lib,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "0.10.0";
  pname = "reptyr";

  src = fetchFromGitHub {
    owner = "nelhage";
    repo = "reptyr";
    tag = "reptyr-${finalAttrs.version}";
    sha256 = "sha256-jlO/ykrwGJkgKiPxfRQEX4TSksrbPQhkQs+QddwqaQ4=";
  };

  makeFlags = [
    "PREFIX="
    "DESTDIR=$(out)"
  ];

  meta = {
    platforms = [
      "i686-linux"
      "x86_64-linux"
      "armv5tel-linux"
      "armv6l-linux"
      "armv7l-linux"
      "aarch64-linux"
      "riscv64-linux"
    ];
    license = lib.licenses.mit;
    description = "Reparent a running program to a new terminal";
    mainProgram = "reptyr";
    homepage = "https://github.com/nelhage/reptyr";
  };
})
