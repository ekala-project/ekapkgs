{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  updateAutotoolsGnuConfigScriptsHook,
  autoreconfHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cdparanoia-iii";
  version = "10.2";

  src = fetchurl {
    url = "https://downloads.xiph.org/releases/cdparanoia/cdparanoia-III-${finalAttrs.version}.src.tgz";
    sha256 = "1pv4zrajm46za0f6lv162iqffih57a8ly4pc69f7y0gfyigb8p80";
  };

  patches = [
    # Has to come after darwin patches and before freebsd patches
    ./fix_private_keyword.patch
    # Order does not matter
    ./configure.patch
    # labs for long
    (fetchpatch {
      url = "https://github.com/macports/macports-ports/raw/f210a6061bc53c746730a37922399c6de6d69cb7/audio/cdparanoia/files/fixing-labs.patch";
      hash = "sha256-BMMQ5bbPP3eevuwWUVjQCtRBiWbkAHD+O0C0fp+BPaw=";
    })
    # use "%s" for passing a buffer to fprintf
    (fetchpatch {
      url = "https://github.com/macports/macports-ports/raw/f210a6061bc53c746730a37922399c6de6d69cb7/audio/cdparanoia/files/fixing-fprintf.patch";
      hash = "sha256-2dJl16p+f5l3wxVOJhsuLiQ9a4prq7jsRZP8/ygEae4=";
    })
    # add support for IDE4-9
    (fetchpatch {
      url = "https://salsa.debian.org/optical-media-team/cdparanoia/-/raw/bbf353721834b3784ccc0fd54a36a6b25181f5a4/debian/patches/02-ide-devices.patch";
      hash = "sha256-S6OzftUIPPq9JHsoAE2K51ltsI1WkVaQrpgCjgm5AG4=";
    })
    # check buffer is non-null before dereferencing
    (fetchpatch {
      url = "https://salsa.debian.org/optical-media-team/cdparanoia/-/raw/f7bab3024c5576da1fdb7497abbd6abc8959a98c/debian/patches/04-endian.patch";
      hash = "sha256-krfprwls0L3hsNfoj2j69J5k1RTKEQtzE0fLYG9EJKo=";
    })
  ];

  nativeBuildInputs = [
    updateAutotoolsGnuConfigScriptsHook
    autoreconfHook
  ];

  env = {
    BSD_INSTALL_PROGRAM = "install";
    BSD_INSTALL_LIB = "install";
  };

  # Build system reuses the same object file names for shared and static
  # library. Occasionally fails in the middle.
  enableParallelBuilding = false;

  meta = {
    homepage = "https://xiph.org/paranoia";
    description = "Tool and library for reading digital audio from CDs";
    license = with lib.licenses; [
      gpl2Plus
      lgpl21Plus
    ];
    platforms = lib.platforms.unix;
    mainProgram = "cdparanoia";
  };
})
