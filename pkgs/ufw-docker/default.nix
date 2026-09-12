{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  makeWrapper,
  coreutils,
  gawk,
  gnugrep,
  gnused,
  util-linux,
}:

stdenvNoCC.mkDerivation rec {
  pname = "ufw-docker";
  version = "251123";

  src = fetchFromGitHub {
    owner = "chaifeng";
    repo = "ufw-docker";
    rev = version;
    hash = "sha256-02qcqJjvN2d+ljcsUjlXd97Dydh72wsvJ3lNFBjA6b4=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    install -Dm755 ufw-docker $out/bin/ufw-docker
    wrapProgram $out/bin/ufw-docker \
      --prefix PATH : ${lib.makeBinPath [ coreutils gawk gnugrep gnused util-linux ]}

    runHook postInstall
  '';

  meta = {
    description = "Fix the Docker and UFW security flaw without disabling iptables";
    homepage = "https://github.com/chaifeng/ufw-docker";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    mainProgram = "ufw-docker";
  };
}
