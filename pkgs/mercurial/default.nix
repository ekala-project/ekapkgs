{
  lib,
  stdenv,
  fetchurl,
  python3Packages,
  makeWrapper,
  gettext,
  installShellFiles,
  re2Support ? true,
  rustSupport ? stdenv.hostPlatform.isLinux,
  cargo,
  rustPlatform,
  rustc,
}:

let
  inherit (python3Packages)
    docutils
    python
    google-re2
    pygments
    setuptools
    setuptools-scm
    pip
    ;
in
python3Packages.buildPythonApplication rec {
  pname = "mercurial";
  version = "7.2.2";

  src = fetchurl {
    url = "https://mercurial-scm.org/release/mercurial-${version}.tar.gz";
    hash = "sha256-8uyOfu7wUAWRcG03RVXwzrEYgiBo51+jsyvgfdIYT2w=";
  };

  pyproject = false;

  cargoDeps =
    if rustSupport then
      rustPlatform.fetchCargoVendor {
        inherit src;
        name = "mercurial-${version}";
        hash = "sha256-OGsHK3Bh47V4n+7HYpVp/jymCz1QY45rkWlAW0Hob7g=";
        sourceRoot = "mercurial-${version}/rust";
      }
    else
      null;
  cargoRoot = if rustSupport then "rust" else null;

  env.PYO3_USE_ABI3_FORWARD_COMPATIBILITY = 1;

  propagatedBuildInputs =
    lib.optional re2Support google-re2
    ++ [ pygments ];
  nativeBuildInputs =
    [
      makeWrapper
      gettext
      installShellFiles
      setuptools
      setuptools-scm
      pip
    ]
    ++ lib.optionals rustSupport [
      rustPlatform.cargoSetupHook
      cargo
      rustc
    ];
  buildInputs = [ docutils ];

  makeFlags = [ "PREFIX=$(out)" ] ++ lib.optional rustSupport "PURE=--rust";

  postInstall = ''
    for i in $(cd $out/bin && ls); do
      wrapProgram $out/bin/$i
    done

    mkdir -p $out/share/cgi-bin
    cp -v hgweb.cgi contrib/hgweb.wsgi $out/share/cgi-bin
    chmod u+x $out/share/cgi-bin/hgweb.cgi

    installShellCompletion --cmd hg \
      --bash contrib/bash_completion \
      --zsh contrib/zsh_completion
  '';

  meta = {
    description = "Fast, lightweight SCM system for very large distributed projects";
    homepage = "https://www.mercurial-scm.org";
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
    platforms = lib.platforms.unix;
    mainProgram = "hg";
  };
}
