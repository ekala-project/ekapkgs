{
  stdenv,
  lib,
  fetchFromGitHub,
  makeWrapper,
  coreutils,
  gawk,
  procps,
  gnused,
  bc,
  findutils,
  xdpyinfo ? null,
  xprop ? null,
  gnugrep,
  ncurses,
  pciutils,
}:

let
  path = lib.makeBinPath [
    coreutils
    gawk
    gnused
    findutils
    gnugrep
    ncurses
    bc
    pciutils
    procps
    xdpyinfo
    xprop
  ];
in
stdenv.mkDerivation (finalAttrs: {
  pname = "screenfetch";
  version = "3.9.9";

  src = fetchFromGitHub {
    owner = "KittyKatt";
    repo = "screenFetch";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-UNZMCLXhH4wDV0/fGWsB+KAi6aJVuPs6zpWXIQAqnjo=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    install -Dm 0755 screenfetch-dev $out/bin/screenfetch
    install -Dm 0644 screenfetch.1 $out/share/man/man1/screenfetch.1
    install -Dm 0644 -t $out/share/doc/screenfetch CHANGELOG COPYING README.mkdn TODO

    patchShebangs $out/bin/screenfetch
    wrapProgram "$out/bin/screenfetch" \
      --prefix PATH : ${path}

    runHook postInstall
  '';

  outputs = [
    "out"
    "doc"
    "man"
  ];

  meta = {
    description = "Fetches system/theme information in terminal for Linux desktop screenshots";
    license = lib.licenses.gpl3;
    homepage = "https://github.com/KittyKatt/screenFetch";
    platforms = lib.platforms.all;
    mainProgram = "screenfetch";
  };
})
