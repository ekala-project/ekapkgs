{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  glib,
  icu,
  libxml2,
  ninja,
  perl,
  pkg-config,
  python3,
  tzdata,
  withIntrospection ? true,
  gobject-introspection,
  vala,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libical";
  version = "3.0.20";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "libical";
    repo = "libical";
    tag = "v${finalAttrs.version}";
    hash = "sha256-KIMqZ6QAh+fTcKEYrcLlxgip91CLAwL9rwjUdKzBsQk=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    icu
    ninja
    perl
    pkg-config
  ]
  ++ lib.optionals withIntrospection [
    gobject-introspection
    vala
  ];

  # TODO: pygobject3 not available in ekapkgs python packages
  # nativeInstallCheckInputs = [
  #   (python3.pythonOnBuildForHost.withPackages (
  #     pkgs: with pkgs; [
  #       pygobject3
  #     ]
  #   ))
  # ];

  buildInputs = [
    glib
    libxml2
    icu
  ];

  cmakeFlags = [
    "-DENABLE_GTK_DOC=False"
    "-DLIBICAL_BUILD_EXAMPLES=False"
    "-DGOBJECT_INTROSPECTION=${if withIntrospection then "True" else "False"}"
    "-DICAL_GLIB_VAPI=${if withIntrospection then "True" else "False"}"
    "-DSTATIC_ONLY=${if stdenv.hostPlatform.isStatic then "True" else "False"}"
  ];

  patches = [
    # Will appear in 3.1.0
    # https://github.com/libical/libical/issues/350
    ./respect-env-tzdir.patch

    ./static.patch
  ];

  # TODO: re-enable when pygobject3 is available
  doInstallCheck = false;
  enableParallelChecking = false;
  installCheckPhase = ''
    runHook preInstallCheck

    export TZDIR=${tzdata}/share/zoneinfo
    ctest --output-on-failure

    runHook postInstallCheck
  '';

  meta = {
    homepage = "https://github.com/libical/libical";
    description = "Open Source implementation of the iCalendar protocols";
    changelog = "https://github.com/libical/libical/raw/v${finalAttrs.version}/ReleaseNotes.txt";
    license = lib.licenses.mpl20;
    platforms = lib.platforms.linux;
    maintainers = [ ];
  };
})
