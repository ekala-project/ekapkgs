{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  rename ? null,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "ubuntu-sans";
  version = "1.006";

  src = fetchFromGitHub {
    owner = "canonical";
    repo = "Ubuntu-Sans-fonts";
    rev = "v${finalAttrs.version}";
    hash = "sha256-PvDNQaOgJUb3/ubhqVSUMfinxfbhuQ0BnqYs3xshrhc=";
  };

  installPhase = ''
    runHook preInstall

    install -m444 -Dt $out/share/fonts/truetype/ubuntu-sans fonts/variable/*
    ${rename}/bin/rename 's/\[.*\]//' $out/share/fonts/truetype/ubuntu-sans/*

    runHook postInstall
  '';

  meta = {
    description = "Ubuntu Font Family";
    homepage = "https://design.ubuntu.com/font";
    changelog = "https://github.com/canonical/Ubuntu-Sans-fonts/blob/${finalAttrs.src.rev}/FONTLOG.txt";
    license = lib.licenses.ufl;
    platforms = lib.platforms.all;
    maintainers = [ ];
  };
})
