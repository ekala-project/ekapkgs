{
  lib,
  stdenv,
  fetchurl,
  cmake,
  pkg-config,
  util-linux,
  libselinux,
  libsepol,
  lerc,
  libthai,
  libdatrie,
  libxkbcommon,
  libepoxy,
  libxtst,
  wrapGAppsHook3,
  pixman,
  libpthread-stubs,
  gtkmm3,
  libxau,
  libxdmcp,
  lcms2,
  libiptcdata,
  fftwSinglePrec,
  expat,
  pcre2,
  libsigcxx,
  lensfun,
  librsvg,
  libcanberra-gtk3 ? null,
  exiv2,
  libraw,
  enableJxl ? false,
  libjxl ? null,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rawtherapee";
  version = "5.12";

  src = fetchurl {
    # The developers ask not to use the tarball from GitHub releases, see
    # https://www.rawtherapee.com/downloads/5.12/#news-relevant-to-package-maintainers
    url = "https://rawtherapee.com/shared/source/rawtherapee-${finalAttrs.version}.tar.xz";
    hash = "sha256-2abBBTfWSihbxGVnX+WaqpTOMiOCPfvs8K4slZkILVc=";
  };

  postPatch = ''
    # https://github.com/NixOS/nixpkgs/issues/475835
    # https://github.com/RawTherapee/RawTherapee/issues/7443#issuecomment-3014132156
    # remove for 5.13
    substituteInPlace rtengine/procparams.cc --replace \
      'outputProfile(options.rtSettings.srgb),' \
      'outputProfile("RTv4_sRGB"),'

    cat <<EOF > ReleaseInfo.cmake
    set(GIT_DESCRIBE ${finalAttrs.version})
    set(GIT_BRANCH ${finalAttrs.version})
    set(GIT_VERSION ${finalAttrs.version})
    # Missing GIT_COMMIT and GIT_COMMIT_DATE, which are not easy to obtain.
    set(GIT_COMMITS_SINCE_TAG 0)
    set(GIT_COMMITS_SINCE_BRANCH 0)
    set(GIT_VERSION_NUMERIC_BS ${finalAttrs.version})
    EOF
  '';

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    util-linux
    libselinux
    libsepol
    lerc
    libthai
    libdatrie
    libxkbcommon
    libepoxy
    libxtst
    pixman
    libpthread-stubs
    gtkmm3
    libxau
    libxdmcp
    lcms2
    libiptcdata
    fftwSinglePrec
    expat
    pcre2
    libsigcxx
    lensfun
    librsvg
    exiv2
    libraw
  ]
  ++ lib.optionals enableJxl [
    libjxl
  ]
  ++ lib.optionals (libcanberra-gtk3 != null) [
    libcanberra-gtk3
  ];

  cmakeFlags = [
    "-DPROC_TARGET_NUMBER=2"
    "-DCACHE_NAME_SUFFIX=\"\""
    "-DWITH_SYSTEM_LIBRAW=\"ON\""
    (lib.cmakeBool "WITH_JXL" enableJxl)
    (lib.cmakeBool "USE_LIBCANBERRA" (libcanberra-gtk3 != null))
  ];

  env = {
    CMAKE_CXX_FLAGS = toString [
      "-std=c++11"
      "-Wno-deprecated-declarations"
      "-Wno-unused-result"
    ];
    # needed at least with gcc13 on aarch64-linux
    CXXFLAGS = toString [
      "-include"
      "cstdint"
    ];
  };

  meta = {
    description = "RAW converter and digital photo processing software";
    homepage = "http://www.rawtherapee.com/";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.unix;
  };
})
