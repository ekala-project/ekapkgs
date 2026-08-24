{ lib
, stdenvNoCC
, fetchFromGitHub
, rename ? null
,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "ubuntu-sans-mono";
  version = "1.100";

  src = fetchFromGitHub {
    owner = "canonical";
    repo = "Ubuntu-Sans-Mono-fonts";
    rev = "v${finalAttrs.version}";
    hash = "sha256-3vHf1e1bHaFCPTYMDldoUPYQvMAW6//MiNiqlCjd7HQ=";
  };

  installPhase = ''
    runHook preInstall

    install -m444 -Dt $out/share/fonts/truetype/ubuntu-sans fonts/variable/*
    ${rename}/bin/rename 's/\[.*\]//' $out/share/fonts/truetype/ubuntu-sans/*

    runHook postInstall
  '';

  meta = {
    description = "Ubuntu Font Family (Mono)";
    homepage = "https://design.ubuntu.com/font";
    changelog = "https://github.com/canonical/Ubuntu-Sans-Mono-fonts/blob/${finalAttrs.src.rev}/FONTLOG.txt";
    license = lib.licenses.ufl;
    platforms = lib.platforms.all;
    maintainers = [ ];
  };
})
