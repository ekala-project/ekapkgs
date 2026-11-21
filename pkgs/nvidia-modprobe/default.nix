{
  stdenv,
  lib,
  fetchFromGitHub,
  m4,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "nvidia-modprobe";
  version = "620.73.04";

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "nvidia-modprobe";
    tag = finalAttrs.version;
    hash = "sha256-wJLKJLcZYFQSI5Jnj97Dbou2X0AE/xGJNVqjD2FnaHc=";
  };

  nativeBuildInputs = [ m4 ];

  postPatch = ''
    substituteInPlace utils.mk --replace-fail "/usr/local" "$out"
  '';

  meta = {
    description = "Load the NVIDIA kernel module and create NVIDIA character device files";
    homepage = "https://github.com/NVIDIA/nvidia-modprobe";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
  };
})
