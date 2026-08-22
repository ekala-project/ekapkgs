{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchFromSourcehut,
  coreutils,
  curl,
  libarchive,
  libpkgconf ? pkgconf.dev,
  pkgconf,
  pkg-config,
  samurai,
  zlib,
  embedSamurai ? false,
  buildDocs ? true,
  scdoc ? null,
  python3,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "muon" + lib.optionalString embedSamurai "-embedded-samurai";
  version = "0.5.0";

  srcs = builtins.attrValues (lib.filterAttrs (_: v: v.use or true) finalAttrs.passthru.srcsAttrs);

  sourceRoot = "muon-src";

  outputs = [ "out" ] ++ lib.optionals buildDocs [ "man" ];

  nativeBuildInputs = [
    pkgconf
    pkg-config
  ]
  ++ lib.optionals (!embedSamurai) [ samurai ]
  ++ lib.optionals buildDocs [
    scdoc
  ]
  ++ lib.optionals buildDocs [
    (python3.withPackages (ps: [ ps.pyyaml ]))
  ];

  buildInputs = [
    curl
    libarchive
    zlib
  ]
  ++ [ libpkgconf ];

  strictDeps = true;

  postUnpack = ''
    for src in $srcs; do
      name=$(stripHash $src)

      # skip the main project, only move subprojects
      [ "$name" == "$sourceRoot" ] && continue

      cp -r "$name" "$sourceRoot/subprojects/$name"
      chmod +w -R "$sourceRoot/subprojects/$name"
      rm "$sourceRoot/subprojects/$name.wrap"
    done
  '';

  postPatch = ''
    find subprojects -name "*.py" -exec chmod +x {} \;
    patchShebangs subprojects
  '';

  enableParallelBuilding = true;

  buildPhase =
    let
      muonBool = lib.mesonBool;
      muonEnable = lib.mesonEnable;
      muonOption = lib.mesonOption;

      bootstrapFlags = lib.optionalString (!embedSamurai) "CFLAGS=\"$CFLAGS -DBOOTSTRAP_NO_SAMU\"";
      cmdlineForMuon = lib.concatStringsSep " " [
        (muonOption "prefix" (placeholder "out"))
        (muonEnable "auto_features" true)
        (muonOption "buildtype" "plain")
        (muonOption "optimization" "plain")
        (muonOption "wrap_mode" "nodownload")
        (muonBool "static" stdenv.targetPlatform.isStatic)
        (muonEnable "man-pages" buildDocs)
        (muonEnable "meson-docs" buildDocs)
        (muonEnable "meson-tests" false)
        (muonEnable "samurai" embedSamurai)
        (muonEnable "tracy" false)
        (muonEnable "website" false)
      ];
      cmdlineForSamu = "-j$NIX_BUILD_CORES";
    in
    ''
      runHook preBuild

      ${bootstrapFlags} ./bootstrap.sh stage-1
      ./stage-1/muon-bootstrap setup ${cmdlineForMuon} stage-2
      ${lib.optionalString embedSamurai "./stage-1/muon-bootstrap"} samu ${cmdlineForSamu} -C stage-2

      runHook postBuild
    '';

  doCheck = false;

  installPhase = ''
    runHook preInstall

    stage-2/muon -C stage-2 install

    runHook postInstall
  '';

  passthru.srcsAttrs = {
    muon-src = fetchFromSourcehut {
      name = "muon-src";
      owner = "~lattis";
      repo = "muon";
      tag = finalAttrs.version;
      hash = "sha256-bWEYWUD+GK8R3yVnDTnzFWmm4KAuVPI+1yMfCXWcG/A=";
    };
    meson-docs = fetchFromGitHub {
      name = "meson-docs";
      repo = "meson-docs";
      owner = "muon-build";
      rev = "1017b3413601044fb41ad04977445e68a80e8181";
      hash = "sha256-aFpyJFIqybLNKhm/kyfCjYylj7DE6muI1+OUh4Cq4WY=";
      passthru.use = buildDocs;
    };
    meson-tests = fetchFromGitHub {
      name = "meson-tests";
      repo = "meson-tests";
      owner = "muon-build";
      rev = "db92588773a24f67cda2f331b945825ca3a63fa7";
      hash = "sha256-z4Fc1lr/m2MwIwhXJwoFWpzeNg+udzMxuw5Q/zVvpSM=";
      passthru.use = false;
    };
  };

  meta = {
    homepage = "https://muon.build";
    description = "Implementation of the meson build system in C99";
    license = lib.licenses.gpl3Only;
    maintainers = [ ];
    platforms = lib.platforms.unix;
    mainProgram = "muon";
  };
})
