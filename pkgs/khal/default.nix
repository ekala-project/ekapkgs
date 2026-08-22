{
  lib,
  stdenv,
  fetchFromGitHub,
  glibcLocales,
  installShellFiles,
  python3Packages,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "khal";
  version = "0.14.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pimutils";
    repo = "khal";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ltb2c9p/kD0PtYnLxRIm/SNlg+W+Vca6JSA7BahZ9uQ=";
  };

  build-system = with python3Packages; [
    setuptools
    setuptools-scm
  ];

  nativeBuildInputs = [
    glibcLocales
    installShellFiles
  ];

  dependencies = with python3Packages; [
    click
    click-log
    configobj
    freezegun
    icalendar
    lxml
    pkginfo
    python-dateutil
    pytz
    pyxdg
    requests-toolbelt
    tzlocal
    urwid
  ];

  doCheck = false;

  postInstall = ''
    # shell completions
    installShellCompletion --cmd khal \
      --bash <(_KHAL_COMPLETE=bash_source $out/bin/khal) \
      --zsh <(_KHAL_COMPLETE=zsh_source $out/bin/khal) \
      --fish <(_KHAL_COMPLETE=fish_source $out/bin/khal)

    # .desktop file
    install -Dm755 misc/khal.desktop -t $out/share/applications
  '';

  env.LC_ALL = "en_US.UTF-8";

  meta = {
    description = "CLI calendar application";
    homepage = "https://lostpackets.de/khal/";
    changelog = "https://github.com/pimutils/khal/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
