{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  gettext,
  perl,
  pkg-config,
  libxml2,
  pango,
  cairo,
  groff,
}:

perl.pkgs.toPerlModule (
  stdenv.mkDerivation rec {
    pname = "rrdtool";
    version = "1.11.0";

    src = fetchFromGitHub {
      owner = "oetiker";
      repo = "rrdtool-1.x";
      rev = "v${version}";
      hash = "sha256-EMnIh8Ug0LkbdER+Tpk0QUKns/dvX8413iQUS79QrVA=";
    };

    nativeBuildInputs = [
      pkg-config
      autoreconfHook
    ];

    buildInputs = [
      gettext
      perl
      libxml2
      pango
      cairo
      groff
    ];

    postInstall = ''
      mkdir -p $out/${perl.libPrefix}
      mv $out/lib/perl/5* $out/${perl.libPrefix}
    '';

    meta = {
      homepage = "https://oss.oetiker.ch/rrdtool/";
      description = "High performance logging in Round Robin Databases";
      license = lib.licenses.gpl2Only;
      maintainers = [ ];
      platforms = lib.platforms.linux;
    };
  }
)
