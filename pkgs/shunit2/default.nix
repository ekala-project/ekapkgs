{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  bash,
  coreutils,
  gnused,
  gnugrep,
  findutils,
  ncurses,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "shunit2";
  version = "2.1.8";

  src = fetchFromGitHub {
    owner = "kward";
    repo = "shunit2";
    rev = "v${finalAttrs.version}";
    hash = "sha256-IZHkgkVqzeh+eEKCDJ87sqNhSA+DU6kBCNDdQaUEeiM=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin/
    cp ./shunit2 $out/bin/shunit2
    chmod +x $out/bin/shunit2
    patchShebangs $out/bin/shunit2

    wrapProgram $out/bin/shunit2 \
      --prefix PATH : ${
        lib.makeBinPath [
          coreutils
          gnused
          gnugrep
          findutils
          ncurses
        ]
      }

    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/kward/shunit2";
    description = "XUnit based unit test framework for Bourne based shell scripts";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    mainProgram = "shunit2";
  };
})
