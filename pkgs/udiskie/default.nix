{
  lib,
  stdenv,
  asciidoc,
  fetchFromGitHub,
  gobject-introspection,
  gtk3,
  installShellFiles,
  keyutils,
  libappindicator,
  libnotify,
  librsvg,
  python3Packages,
  udisks,
  wrapGAppsHook3,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "udiskie";
  version = "2.7.0";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "coldfix";
    repo = "udiskie";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6vlh1Ggfk4Ehwcmqr0a1YtBjTfCqQqdctkXqdS1BSis=";
  };

  patches = [
    ./locale-path.patch
  ];

  postPatch = ''
    substituteInPlace udiskie/locale.py --subst-var out

    substituteInPlace udiskie/keyutils.py \
      --replace-fail 'ctypes.util.find_library("keyutils")' '"${lib.getLib keyutils}/lib/libkeyutils${stdenv.hostPlatform.extensions.sharedLibrary}"'
  '';

  nativeBuildInputs = [
    asciidoc
    gobject-introspection
    installShellFiles
    wrapGAppsHook3
  ];

  build-system = with python3Packages; [
    setuptools
  ];

  dontWrapGApps = true;

  buildInputs = [
    gtk3
    libappindicator
    libnotify
    librsvg
    udisks
  ];

  dependencies = with python3Packages; [
    docopt
    pygobject3
    pyyaml
  ];

  # TODO(ekapkgs): restore man page generation when a2x (asciidoc) is available
  postInstall = ''
    installShellCompletion \
      --bash completions/bash/* \
      --zsh completions/zsh/*
  '';

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  meta = {
    homepage = "https://github.com/coldfix/udiskie";
    description = "Removable disk automounter for udisks";
    license = lib.licenses.mit;
    mainProgram = "udiskie";
  };
})
