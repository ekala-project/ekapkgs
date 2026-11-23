{
  lib,
  stdenv,
  fetchFromGitHub,
  udev,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libudev0-shim";
  version = "2";

  src = fetchFromGitHub {
    owner = "archlinux";
    repo = "libudev0-shim";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-P0ht5IuhkaTZeWbxqGTREnQGkIQVyFA89RnT612xRWY=";
  };

  buildInputs = [ udev ];

  installPhase = ''
    name="$(echo libudev.so.*)"
    install -Dm755 "$name" "$out/lib/$name"
    ln -s "$name" "$out/lib/libudev.so.0"
  '';

  meta = {
    description = "Shim to preserve libudev.so.0 compatibility";
    homepage = "https://github.com/archlinux/libudev0-shim";
    platforms = lib.platforms.linux;
    license = lib.licenses.lgpl21;
  };
})
