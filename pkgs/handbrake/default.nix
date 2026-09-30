# Upstream distributes HandBrake with bundle of according versions of libraries
# and patches to them. This derivation patches HandBrake to use Nix closure
# dependencies.
{
  stdenv,
  lib,
  applyPatches,
  fetchFromGitHub,
  fetchFromGitLab,
  fetchpatch2,
  fetchurl,
  # Main build tools
  pkg-config,
  autoconf,
  automake,
  libtool,
  m4,
  xz,
  python3,
  numactl,
  writeText,
  # Processing, video codecs, containers
  ffmpeg,
  nv-codec-headers,
  libogg,
  x264,
  x265,
  libvpx,
  libtheora,
  dav1d,
  zimg,
  svt-av1,
  # Codecs, audio
  libopus,
  lame,
  libvorbis,
  a52dec,
  speex,
  libsamplerate,
  # Text processing
  libiconv,
  fribidi,
  fontconfig,
  freetype,
  libass,
  jansson,
  libxml2,
  harfbuzz,
  libjpeg_turbo,
  # Optical media
  libdvdread,
  libdvdnav,
  libdvdcss,
  libbluray,
  # GTK
  useGtk ? stdenv.hostPlatform.isLinux,
  appstream,
  desktop-file-utils,
  meson,
  ninja,
  # wrapGAppsHook4 is gtk4.wrapGAppsHook in ekapkgs
  intltool,
  glib,
  gtk4,
  libappindicator,
  libnotify,
  gstreamer,
  dbus-glib,
  udev,
  libgudev,
  hicolor-icon-theme,
  # FDK
  useFdk ? false,
  fdk_aac,
}:

let
  version = "1.11.2";

  src = applyPatches {
    src = fetchFromGitHub {
      owner = "HandBrake";
      repo = "HandBrake";
      # uses version commit for logic in version.txt
      rev = "9eb6c936803e8b071035b1a77662cb0db58441ea";
      hash = "sha256-f4kBFeW1yVFLlXGAimWsZx+9PKlgR6xrXUZG+CBh28A=";
    };

    patches = [
      # Update x265 submodule to v4.2
      (fetchpatch2 {
        url = "https://github.com/HandBrake/HandBrake/commit/432514bf839e7280511e4a7afc35fb4868ef4d0b.patch";
        excludes = [
          "contrib/x265/module.defs"
          "contrib/x265_8bit/module.defs"
          "contrib/x265_10bit/module.defs"
          "contrib/x265_12bit/module.defs"
        ];
        hash = "sha256-xwIY1pO9mKbrQFjQCENuvntIoiZTHeUVg8axrl3zxxo=";
      })
      # Update ffmpeg to v8.1.2
      (fetchpatch2 {
        url = "https://github.com/HandBrake/HandBrake/commit/02b704c5cf2e73d227fbb5be151501b232b0e5f2.patch?full_index=1";
        excludes = [
          "contrib/ffmpeg/module.defs"
        ];
        hash = "sha256-fSfLXH+aRwVv9BrDT1oNBHD2VUbAnN3jVu3CJeoaAKg=";
      })
    ];
  };

  # Handbrake maintains a set of ffmpeg patches. In particular, these
  # patches are required for subtitle timing to work correctly.
  ffmpeg-hb = ffmpeg.v8.overrideAttrs (old: {
    doCheck = false;
    patches = (old.patches or [ ]) ++ [
      "${src}/contrib/ffmpeg/A01-mov-read-name-track-tag-written-by-movenc.patch"
      "${src}/contrib/ffmpeg/A02-movenc-write-3gpp-track-titl-tag.patch"
      "${src}/contrib/ffmpeg/A03-mov-read-3gpp-udta-tags.patch"
      "${src}/contrib/ffmpeg/A04-movenc-write-3gpp-track-names-tags-for-all-available.patch"
      "${src}/contrib/ffmpeg/A05-avformat-mov-add-support-audio-fallback-track-ref.patch"
      "${src}/contrib/ffmpeg/A06-avformat-mov-read-and-write-additional-iTunes-style-.patch"
      "${src}/contrib/ffmpeg/A07-avformat-movenc-write-iTunEXTC-and-iTunMOVI-metadata.patch"
      "${src}/contrib/ffmpeg/A08-dvdsubdec-fix-processing-of-partial-packets.patch"
      "${src}/contrib/ffmpeg/A09-dvdsubdec-return-number-of-bytes-used.patch"
      "${src}/contrib/ffmpeg/A10-dvdsubdec-use-pts-of-initial-packet.patch"
      "${src}/contrib/ffmpeg/A11-dvdsubdec-add-an-option-to-output-subtitles-with-emp.patch"
      "${src}/contrib/ffmpeg/A12-ccaption_dec-fix-pts-in-real_time-mode.patch"
      "${src}/contrib/ffmpeg/A13-avformat-matroskaenc-return-error-if-aac-extradata-c.patch"
      "${src}/contrib/ffmpeg/A14-Expose-the-unmodified-Dolby-Vision-RPU-T35-buffers.patch"
      "${src}/contrib/ffmpeg/A15-lavc-pgssubdec-Add-graphic-plane-and-cropping.patch"
      "${src}/contrib/ffmpeg/A16-libavcodec-qsvenc.c-update-has_b_frames-value-after-.patch"
      "${src}/contrib/ffmpeg/A17-qsv-enable-av1-scc.patch"
      "${src}/contrib/ffmpeg/A18-fixed-BT2020-BT709-conversion-via-VPP.patch"
      "${src}/contrib/ffmpeg/A19-videotoolbox-disable-H.264-10-bit-on-Intel-macOS-it-.patch"
      "${src}/contrib/ffmpeg/A20-videotoolbox-speedup-decoding.patch"
      "${src}/contrib/ffmpeg/A21-Revert-avcodec-amfenc-GPU-driver-version-check.patch"
      "${src}/contrib/ffmpeg/A22-fix-d3d11-static-pool-size-error.patch"
      "${src}/contrib/ffmpeg/A23-movenc-set-the-chapters-track-language-to-the-same-a.patch"
      "${src}/contrib/ffmpeg/A24-movenc-use-version-2-audio-descriptor-for-2-channels.patch"
      "${src}/contrib/ffmpeg/A26-avformat-movenc-fix-mov_create_dvd_sub_decoder_speci.patch"
    ];
  });

  x265-hb = x265.overrideAttrs (old: {
    version = "4.2";
    sourceRoot = "x265_4.2/source";
    src = fetchurl {
      url = "https://bitbucket.org/multicoreware/x265_git/downloads/x265_4.2.tar.gz";
      hash = "sha256-QLHqBFPgMJ8OupNODd9TP49ilZZmeeiJTo8cHI1eEhA=";
    };
    postPatch = (old.postPatch or "") + ''
      pushd ..
        for p in ${src}/contrib/x265/*.patch; do
          patch -p1 < "$p"
        done
      popd
    '';
  });

  svt-av1-hb = svt-av1.overrideAttrs (old: rec {
    version = "4.1.0";
    src = fetchFromGitLab {
      owner = "AOMediaCodec";
      repo = "SVT-AV1";
      tag = "v${version}";
      hash = "sha256-NPJG1SsRlG9kGtUwdJa/uP6DAtF09nCctzeorrvjAhQ=";
    };
    postPatch = (old.postPatch or "") + ''
      pushd ..
        for p in ${src}/contrib/svt-av1/*.patch; do
          patch -p1 < "$p"
        done
      popd
    '';
  });

  versionFile = writeText "version.txt" ''
    URL=${src.meta.homepage}.git
    HASH=${src.rev}
    SHORTHASH=${lib.substring 0 9 src.rev}
    TAG=${version}
    TAG_HASH=${src.rev}
    REV=0
    BRANCH=
    REMOTE=${src.meta.homepage}.git
    DATE=1970-01-01 00:00:01 +0000
  '';

  inherit (lib)
    optional
    optionals
    optionalString
    ;
in
stdenv.mkDerivation rec {
  pname = "handbrake";
  inherit version src;

  postPatch = ''
    install -Dm444 ${versionFile} ${versionFile.name}

    patchShebangs scripts
    patchShebangs gtk/data/

    substituteInPlace libhb/hb.c \
      --replace-fail 'return hb_version;' 'return "${version}";'

    # Force using nixpkgs dependencies
    sed -i '/MODULES += contrib/d' make/include/main.defs
    sed -e 's/^[[:space:]]*\(meson\|ninja\|nasm\)[[:space:]]*= ToolProbe.*$//g' \
        -e '/    ## Additional library and tool checks/,/    ## MinGW specific library and tool checks/d' \
        -i make/configure.py
  ''
  + optionalString useGtk ''
    substituteInPlace gtk/module.rules \
      --replace-fail '$(MESON.exe)' 'meson' \
      --replace-fail '$(NINJA.exe)' 'ninja' \
    # Force using nixpkgs dependencies
    substituteInPlace gtk/meson.build \
      --replace-fail \
        "hb_incdirs = include_directories(hb_dir / 'libhb', hb_dir / 'contrib/include')" \
        "hb_incdirs = include_directories(hb_dir / 'libhb')"
    substituteInPlace gtk/ghb.spec \
      --replace-fail "gtk-update-icon-cache" "gtk4-update-icon-cache"
    substituteInPlace gtk/data/post_install.py \
      --replace-fail "gtk-update-icon-cache" "gtk4-update-icon-cache"
  '';

  nativeBuildInputs = [
    autoconf
    automake
    libtool
    m4
    pkg-config
    python3
  ]
  ++ optionals useGtk [
    appstream
    desktop-file-utils
    intltool
    meson
    meson.configurePhaseHook
    ninja
    gtk4.wrapGAppsHook
  ];

  buildInputs = [
    a52dec
    dav1d
    ffmpeg-hb
    fontconfig
    freetype
    fribidi
    harfbuzz
    jansson
    lame
    libass
    libbluray
    libdvdcss
    libdvdnav
    libdvdread
    libiconv
    libjpeg_turbo
    libogg
    libopus
    libsamplerate
    libtheora
    libvorbis
    libvpx
    libxml2
    speex
    svt-av1-hb
    x264
    x265-hb
    xz
    zimg
  ]
  ++ optional (!stdenv.hostPlatform.isDarwin) numactl
  ++ optionals useGtk [
    dbus-glib
    glib
    gstreamer.libav
    gstreamer.plugins-bad
    gstreamer.plugins-base
    gstreamer.plugins-good
    gstreamer
    gtk4
    hicolor-icon-theme
    libappindicator
    libgudev
    libnotify
    udev
  ]
  ++ optional useFdk fdk_aac
  ++ optional stdenv.hostPlatform.isLinux nv-codec-headers;

  configureFlags = [
    "--disable-df-fetch"
    "--disable-df-verify"
  ]
  ++ optional (!useGtk) "--disable-gtk"
  ++ optional useFdk "--enable-fdk-aac"
  ++ optional stdenv.hostPlatform.isDarwin "--disable-xcode"
  ++ optional stdenv.hostPlatform.isx86 "--harden";

  env.NIX_LDFLAGS = toString [
    "-lx265"
  ];

  # meson/ninja are used only for the subprojects, not the toplevel
  dontUseMesonConfigure = true;
  dontUseMesonInstall = true;
  dontUseNinjaBuild = true;
  dontUseNinjaInstall = true;

  makeFlags = [ "--directory=build" ];

  passthru = {
    inherit ffmpeg-hb x265-hb;
  };

  meta = {
    homepage = "https://handbrake.fr/";
    description = "Tool for converting video files and ripping DVDs";
    longDescription = ''
      Tool for converting and remuxing video files
      into selection of modern and widely supported codecs
      and containers. Very versatile and customizable.
      Package provides:
      CLI - `HandbrakeCLI`
      GTK GUI - `ghb`
    '';
    license = lib.licenses.gpl2Only;
    mainProgram = "HandBrakeCLI";
    platforms = lib.platforms.unix;
  };
}
