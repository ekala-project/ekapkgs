{
  stdenv,
  lib,
  fetchFromGitHub,
  autoconf-archive,
  autoreconfHook,
  makeWrapper,
  pkg-config,
  dbus,
  systemd,
  pcsclite,
  wget,
  coreutils,
  perlPackages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pcsc-tools";
  version = "1.7.5";

  src = fetchFromGitHub {
    owner = "LudovicRousseau";
    repo = "pcsc-tools";
    tag = finalAttrs.version;
    hash = "sha256-xakJwBzsZfqSLZ2wwwQoWtNIC82zOwOtm5CEVx4d+q4=";
  };

  configureFlags = [
    "--datarootdir=${placeholder "out"}/share"
  ];

  buildInputs = [
    dbus
    perlPackages.perl
    pcsclite
    systemd
  ];

  nativeBuildInputs = [
    autoconf-archive
    autoreconfHook
    makeWrapper
    pkg-config
  ];

  postInstall = ''
    wrapProgram $out/bin/scriptor \
      --set PERL5LIB "${
        with perlPackages;
        makePerlPath [
          ChipcardPCSC
          libintl-perl
        ]
      }"

    wrapProgram $out/bin/ATR_analysis \
      --set PERL5LIB "${
        with perlPackages;
        makePerlPath [
          ChipcardPCSC
          libintl-perl
        ]
      }"

    wrapProgram $out/bin/pcsc_scan \
      --prefix PATH : "$out/bin:${
        lib.makeBinPath [
          coreutils
          wget
        ]
      }"

    install -Dm444 -t $out/share/pcsc smartcard_list.txt
  '';

  meta = {
    description = "Tools used to test a PC/SC driver, card or reader";
    homepage = "https://pcsc-tools.apdu.fr/";
    license = lib.licenses.gpl2Plus;
    mainProgram = "pcsc_scan";
    platforms = lib.platforms.unix;
  };
})
