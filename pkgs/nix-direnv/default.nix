{
  lib,
  stdenv,
  fetchFromGitHub,
  nix,
  makeShellWrapper,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nix-direnv";
  version = "3.2.0";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "nix-direnv";
    tag = finalAttrs.version;
    hash = "sha256-dNJeSRuuqA2avtLpTse7mTTmnYdVnC5BxRsofuLXiqE=";
  };

  nativeBuildInputs = [ makeShellWrapper ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    install -Dm444 direnvrc $out/share/nix-direnv/direnvrc
    runHook postInstall
  '';

  meta = {
    description = "Fast, persistent use_nix/use_flake implementation for direnv";
    homepage = "https://github.com/nix-community/nix-direnv";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
})
