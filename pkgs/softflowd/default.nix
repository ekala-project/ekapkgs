{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  libpcap,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "softflowd";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "irino";
    repo = "softflowd";
    tag = "softflowd-v${finalAttrs.version}";
    hash = "sha256-qWHwkXT1Lw8fe9nELaMB6EzAnNxsDvxiLWH3AacVZeA=";
  };

  nativeBuildInputs = [
    autoreconfHook
  ];

  buildInputs = [
    libpcap
  ];

  nativeInstallCheckInputs = [
  ];

  doInstallCheck = true;
  meta = {
    description = "Flow-based network traffic analyser capable of Cisco NetFlow";
    homepage = "https://github.com/irino/softflowd";
    changelog = "https://github.com/irino/softflowd/releases/tag/spftflowd-v${finalAttrs.version}";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.unix;
  };
})
