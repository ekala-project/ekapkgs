{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  meson,
  ninja,
  xxd,
  gettext,
  intltool,
  gtk3,
  lcms2,
  exiv2,
  libchamplain_libsoup3 ? null,
  clutter-gtk ? null,
  ffmpegthumbnailer,
  fbida ? null,
  libarchive,
  djvulibre,
  libheif,
  openjpeg,
  libjxl,
  libraw,
  lua5_3 ? null,
  poppler,
  gspell,
  libtiff,
  libwebp,
  gphoto2,
  imagemagick,
  yad,
  exiftool,
  zenity,
  libnotify,
  wrapGAppsHook3,
  doxygen,
  openexr ? null,
  cfitsio ? null,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "geeqie";
  version = "2.9";

  src = fetchFromGitHub {
    owner = "BestImageViewer";
    repo = "geeqie";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6g1aBeQUy9+WMlikAqvlb0NcCT7h0qgBRSsCOdRiZ/E=";
  };

  postPatch = ''
    patchShebangs .
  '';

  nativeBuildInputs = [
    pkg-config
    gettext
    intltool
    wrapGAppsHook3
    doxygen
    meson
    meson.configurePhaseHook
    ninja
    xxd
  ];

  buildInputs = [
    gtk3
    lcms2
    exiv2
    ffmpegthumbnailer
    libarchive
    djvulibre
    libheif
    openjpeg
    libjxl
    libraw
    poppler
    gspell
    libtiff
    libwebp
  ]
  ++ lib.optional (libchamplain_libsoup3 != null) libchamplain_libsoup3
  ++ lib.optional (clutter-gtk != null) clutter-gtk
  ++ lib.optional (lua5_3 != null) lua5_3
  ++ lib.optional (openexr != null) openexr
  ++ lib.optional (cfitsio != null) cfitsio;

  postInstall = ''
    # Install bash completions in correct location
    sed -i $out/lib/geeqie/geeqie-rotate \
        -e '1 a export PATH=${
          lib.makeBinPath [
            exiv2
          ]
        }:$PATH'
    sed -i $out/lib/geeqie/geeqie-resize-image \
        -e '1 a export PATH=${
          lib.makeBinPath [
            imagemagick
            yad
          ]
        }:$PATH'
    sed -i $out/lib/geeqie/geeqie-image-crop \
        -e '1 a export PATH=${
          lib.makeBinPath [
            imagemagick
            exiv2
            exiftool
            zenity
          ]
        }:$PATH'
    sed -i $out/lib/geeqie/geeqie-tethered-photography \
        -e '1 a export PATH=${
          lib.makeBinPath [
            gphoto2
            zenity
            libnotify
          ]
        }:$PATH'
    sed -i $out/lib/geeqie/geeqie-camera-import \
        -e '1 a export PATH=${
          lib.makeBinPath [
            gphoto2
            zenity
          ]
        }:$PATH'
    sed -i $out/lib/geeqie/geeqie-export-jpeg \
        -e '1 a export PATH=${
          lib.makeBinPath [
            zenity
            exiv2
            exiftool
            lcms2
          ]
        }:$PATH'
  '';

  enableParallelBuilding = true;

  meta = {
    description = "Lightweight GTK based image viewer";
    mainProgram = "geeqie";

    longDescription = ''
      Geeqie is a lightweight GTK based image viewer for Unix like
      operating systems.  It features: EXIF, IPTC and XMP metadata
      browsing and editing interoperability; easy integration with other
      software; geeqie works on files and directories, there is no need to
      import images; fast preview for many raw image formats; tools for
      image comparison, sorting and managing photo collection.  Geeqie was
      initially based on GQview.
    '';

    license = lib.licenses.gpl2Plus;

    homepage = "https://www.geeqie.org/";
    changelog = "https://github.com/BestImageViewer/geeqie/blob/${finalAttrs.src.tag}/NEWS";

    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
