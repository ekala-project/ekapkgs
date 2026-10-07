{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "zlog";
  version = "1.2.19";

  src = fetchFromGitHub {
    owner = "HardySimpson";
    repo = "zlog";
    tag = finalAttrs.version;
    hash = "sha256-orPxSyqQBTuEKKso5BBlNChqJRSzqs85EgAsoD2sxJc=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];

  # Fix broken .pc file paths: upstream uses ${exec_prefix}/${LIBDIR} but
  # Nix sets LIBDIR to an absolute path, producing double-slash paths.
  # See https://github.com/NixOS/nixpkgs/issues/144170
  postInstall = ''
    substituteInPlace $out/lib/pkgconfig/zlog.pc \
      --replace-fail "\''${exec_prefix}/$out/lib" "$out/lib" \
      --replace-fail "\''${prefix}/$out/include" "$out/include"
  '';

  meta = {
    description = "Reliable, high-performance, thread safe, flexible, clear-model, pure C logging library";
    homepage = "https://hardysimpson.github.io/zlog/";
    license = lib.licenses.asl20;
    mainProgram = "zlog-chk-conf";
    platforms = lib.platforms.unix;
  };
})
