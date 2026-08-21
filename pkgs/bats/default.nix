{
  lib,
  stdenv,
  fetchFromGitHub,
  bash,
  coreutils,
  gnugrep,
  ncurses,
  findutils,
  hostname,
  parallel,
  util-linux,
  procps,
  makeWrapper,
}:

stdenv.mkDerivation rec {
  pname = "bats";
  version = "1.11.1";

  src = fetchFromGitHub {
    owner = "bats-core";
    repo = "bats-core";
    rev = "v${version}";
    hash = "sha256-+qmCeLixfLak09XxgSe6ONcH1IoHGl5Au0s9JyNm95g=";
  };

  nativeBuildInputs = [ makeWrapper ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    bash ./install.sh "$out"
    runHook postInstall
  '';

  postInstall = ''
    wrapProgram "$out/bin/bats" \
      --prefix PATH : ${
        lib.makeBinPath [
          bash
          coreutils
          gnugrep
          ncurses
          findutils
          hostname
          parallel
          util-linux
          procps
        ]
      }
  '';

  meta = with lib; {
    description = "Bash Automated Testing System";
    homepage = "https://github.com/bats-core/bats-core";
    license = licenses.mit;
    platforms = platforms.unix;
    mainProgram = "bats";
    maintainers = [ ];
  };
}
