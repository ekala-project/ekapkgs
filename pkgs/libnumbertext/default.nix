{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libnumbertext";
  version = "1.0.11";

  src = fetchFromGitHub {
    owner = "Numbertext";
    repo = "libnumbertext";
    tag = "${finalAttrs.version}";
    hash = "sha256-LlRp9h/8GOHJJ29fmO+gsxiHD0FBeIn1Sm5TXcTPMds=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  meta = {
    description = "Number to number name and money text conversion library";
    homepage = "https://github.com/Numbertext/libnumbertext";
    license = with lib.licenses; [
      lgpl3Plus
      bsd3
    ];
    platforms = lib.platforms.unix;
  };
})
