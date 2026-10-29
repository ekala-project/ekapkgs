{
  version,
  build-hash,
  data-hash,
  mkVariantPassthru,
  ...
}:

{
  lib,
  stdenv,
  buildEnv,
  fetchurl,
  makeWrapper,
  perl,
  python3,
  pkg-config,
  boost,
  icu,
  libxml2,
  libpng,
  libsodium,
  libjpeg,
  zlib,
  curl,
  libogg,
  libvorbis,
  enet,
  miniupnpc,
  openal,
  mesa-glu,
  libGL,
  xorg,
  nspr,
  sdl2-compat,
  gloox,
  freetype,
  libidn,
  fmt ? null,
  nvidia-texture-tools ? null,
  spidermonkey ? null,
  premake5 ? null,
  cxxtest ? null,
  wxwidgets ? null,

  withEditor ? false,
}:

let
  unwrapped = stdenv.mkDerivation {
    pname = "zeroad-unwrapped";
    inherit version;

    src = fetchurl {
      url = "https://releases.wildfiregames.com/0ad-${version}-unix-build.tar.xz";
      hash = build-hash;
    };

    nativeBuildInputs = [
      python3
      perl
      pkg-config
    ];

    buildInputs = [
      boost
      icu
      libxml2
      libpng
      libjpeg
      zlib
      curl
      libogg
      libvorbis
      enet
      miniupnpc
      openal
      libidn
      mesa-glu
      libGL
      xorg.libX11
      xorg.libXcursor
      xorg.xorgproto
      nspr
      sdl2-compat
      gloox
      libsodium
      freetype
    ]
    ++ lib.optional (fmt != null) fmt
    ++ lib.optional (nvidia-texture-tools != null) nvidia-texture-tools
    ++ lib.optional (spidermonkey != null) spidermonkey
    ++ lib.optional (premake5 != null) premake5
    ++ lib.optional (cxxtest != null) cxxtest
    ++ lib.optional (withEditor && wxwidgets != null) wxwidgets;

    configurePhase = ''
      runHook preConfigure

      rm -rf libraries/source/{cxxtest-4.4,nvtt,premake-core,spidermonkey,spirv-reflect}

      pushd libraries
      ./build-source-libs.sh \
        ${lib.optionalString (cxxtest != null) "--with-system-cxxtest"} \
        ${lib.optionalString (nvidia-texture-tools != null) "--with-system-nvtt"} \
        ${lib.optionalString (spidermonkey != null) "--with-system-mozjs"} \
        ${lib.optionalString (premake5 != null) "--with-system-premake"} \
        -j$NIX_BUILD_CORES
      popd

      pushd build/workspaces
      ./update-workspaces.sh \
        ${lib.optionalString (premake5 != null) "--with-system-premake5"} \
        ${lib.optionalString (cxxtest != null) "--with-system-cxxtest"} \
        ${lib.optionalString (nvidia-texture-tools != null) "--with-system-nvtt"} \
        ${lib.optionalString (spidermonkey != null) "--with-system-mozjs"} \
        ${lib.optionalString (!withEditor) "--without-atlas"} \
        --bindir="$out"/bin \
        --libdir="$out"/lib/0ad \
        --without-tests \
        -j $NIX_BUILD_CORES
      popd

      pushd build/workspaces/gcc

      runHook postConfigure
    '';

    installPhase = ''
      popd

      install -Dm755 binaries/system/pyrogenesis "$out"/bin/0ad
      ${lib.optionalString withEditor ''
        install -Dm755 binaries/system/ActorEditor "$out"/bin/ActorEditor
      ''}

      install -Dm755 -t $out/share/0ad/data/l10n binaries/data/l10n/*
      install -Dm644 -t $out/lib/0ad        binaries/system/*.so
      install -D build/resources/0ad.png     $out/share/icons/hicolor/128x128/apps/0ad.png
      install -D build/resources/0ad.desktop $out/share/applications/0ad.desktop
    '';

    meta = {
      description = "Free, open-source game of ancient warfare (engine)";
      homepage = "https://play0ad.com/";
      license = with lib.licenses; [
        gpl2Plus
        lgpl21
        mit
      ];
      platforms = lib.platforms.linux;
      mainProgram = "0ad";
    };
  };

  data = stdenv.mkDerivation {
    pname = "zeroad-data";
    inherit version;

    src = fetchurl {
      url = "https://releases.wildfiregames.com/0ad-${version}-unix-data.tar.xz";
      hash = data-hash;
    };

    installPhase = ''
      mkdir -p $out/share/0ad
      cp -r binaries/data $out/share/0ad/
    '';

    meta = {
      description = "Free, open-source game of ancient warfare (data files)";
      homepage = "https://play0ad.com/";
      license = lib.licenses.cc-by-sa-30;
      platforms = lib.platforms.linux;
    };
  };
in
buildEnv {
  name = "zeroad-${version}";

  nativeBuildInputs = [ makeWrapper ];

  paths = [
    unwrapped
    data
  ];

  pathsToLink = [
    "/"
    "/bin"
  ];

  postBuild = ''
    for i in $out/bin/*; do
      wrapProgram "$i" \
        --set ZEROAD_ROOTDIR "$out/share/0ad"
    done
  '';

  passthru = {
    inherit unwrapped data;
  }
  // mkVariantPassthru { };

  meta = unwrapped.meta // {
    description = "Free, open-source game of ancient warfare";
    license = with lib.licenses; [
      gpl2Plus
      lgpl21
      mit
      cc-by-sa-30
    ];
  };
}
