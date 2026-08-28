{
  stdenv,
  lib,
  fetchFromGitHub,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "massdns";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "blechschmidt";
    repo = "massdns";
    rev = "v${finalAttrs.version}";
    hash = "sha256-hrnAg5ErPt93RV4zobRGVtcKt4aM2tC52r08T7+vRGc=";
  };

  makeFlags = [
    "PREFIX=$(out)"
    "PROJECT_FLAGS=-DMASSDNS_REVISION='\"v${finalAttrs.version}\"'"
  ];
  buildFlags = if stdenv.hostPlatform.isLinux then "all" else "nolinux";
  meta = {
    description = "Resolve large amounts of domain names";
    homepage = "https://github.com/blechschmidt/massdns";
    changelog = "https://github.com/blechschmidt/massdns/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    mainProgram = "massdns";
    platforms = lib.platforms.all;
    # error: use of undeclared identifier 'MSG_NOSIGNAL'
    badPlatforms = lib.platforms.darwin;
  };
})
