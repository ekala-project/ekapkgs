{
  stdenv,
  lib,
  fetchFromGitHub,
  autoconf,
  automake,
  pkg-config,
  sdl2-compat,
  gtk3,
  mpfr,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "basiliskii";
  version = "2.5_20200525";

  # This src is also used to build pkgs/os-specific/linux/sheep-net
  # Therefore changes to it may effect the sheep-net package
  src = fetchFromGitHub {
    owner = "kanjitalk755";
    repo = "macemu";
    rev = "${finalAttrs.version}";
    sha256 = "sha256-4z59pwEXDZGawhOZp+aXqU8yrUR/RsecHFFxHDfzkBI=";
  };

  sourceRoot = "${finalAttrs.src.name}/BasiliskII/src/Unix";

  patches = [ ./remove-redhat-6-workaround-for-scsi-sg.h.patch ];

  nativeBuildInputs = [
    autoconf
    automake
    pkg-config
    gtk3 # for glib-compile-resources
  ];

  buildInputs = [
    sdl2-compat
    gtk3
    mpfr
  ];

  preConfigure = ''
    NO_CONFIGURE=1 ./autogen.sh
  '';

  configureFlags = [
    "--enable-sdl-video"
    "--enable-sdl-audio"
    "--with-bincue"
  ];

  meta = {
    description = "68k Macintosh emulator";
    homepage = "https://basilisk.cebix.net/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    mainProgram = "BasiliskII";
  };
})
