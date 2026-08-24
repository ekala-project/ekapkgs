{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "prodigal";
  version = "2.60";

  src = fetchFromGitHub {
    repo = "Prodigal";
    owner = "hyattpd";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-9fiM357S52QNM8tt7aAyWRyja9zzdek1KpFtlw9g4Ic=";
  };

  makeFlags = [
    "CC=${stdenv.cc.targetPrefix}cc"
  ];

  installPhase = ''
    runHook preInstall
    install -Dm755 prodigal -t $out/bin
    runHook postInstall
  '';

  meta = {
    description = "Fast, reliable protein-coding gene prediction for prokaryotic genomes";
    mainProgram = "prodigal";
    homepage = "https://github.com/hyattpd/Prodigal";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.all;
    maintainers = [ ];
  };
})
