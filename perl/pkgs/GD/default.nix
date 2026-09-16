{
  buildPerlPackage,
  fetchurl,
  lib,
  pkg-config,
  gd,
  libjpeg,
  zlib,
  freetype,
  libpng,
  fontconfig,
  libxpm,
  ExtUtilsPkgConfig,
  FileWhich,
  TestFork,
  TestNoWarnings,
}:
buildPerlPackage {
  pname = "GD";
  version = "2.86";
  src = fetchurl {
    url = "mirror://cpan/authors/id/R/RU/RURBAN/GD-2.86.tar.gz";
    hash = "sha256-bWTTvhQpzB606IqPICL+yRDqPgeS2k/ljT7fdpXEbKI=";
  };
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    gd
    libjpeg
    zlib
    freetype
    libpng
    fontconfig
    libxpm
    ExtUtilsPkgConfig
    FileWhich
    TestFork
    TestNoWarnings
  ];
  # otherwise "cc1: error: -Wformat-security ignored without -Wformat [-Werror=format-security]"
  hardeningDisable = [ "format" ];
  makeMakerFlags = [
    "--lib_png_path=${libpng.out}"
    "--lib_jpeg_path=${libjpeg.out}"
    "--lib_zlib_path=${zlib.out}"
    "--lib_ft_path=${freetype.out}"
    "--lib_fontconfig_path=${fontconfig.lib}"
    "--lib_xpm_path=${libxpm.out}"
  ];
  meta = {
    description = "Perl interface to the gd2 graphics library";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
