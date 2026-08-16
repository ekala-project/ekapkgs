{
  lib,
  stdenv,
  fetchFromGitLab,
  python3,
  librsync,
  glib,
  ncftp,
  gnupg,
  gnutar,
  par2cmdline,
  util-linux,
  rsync,
  makeWrapper,
  wrapGAppsNoGuiHook,
  gettext,
}:

let
  self = python3.pkgs.buildPythonApplication rec {
    pname = "duplicity";
    version = "3.0.7";
    format = "setuptools";

    src = fetchFromGitLab {
      owner = "duplicity";
      repo = "duplicity";
      rev = "rel.${version}";
      hash = "sha256-t2YFp/AuQ9xKZSPmNA/IuQYNOcnPO0l8xhXyLBKSuqA=";
    };

    patches = [
      ./keep-pythonpath-in-testing.patch
    ];

    postPatch = ''
      patchShebangs duplicity/__main__.py

      # don't try to use gtar on darwin/bsd
      substituteInPlace testing/functional/test_restart.py \
        --replace-fail 'tarcmd = "gtar"' 'tarcmd = "tar"'
    '';

    disabledTests = [
      "test_pylint"
      "test_black"
    ];

    nativeBuildInputs = [
      makeWrapper
      gettext
      python3.pkgs.wrapPython
      wrapGAppsNoGuiHook
      python3.pkgs.setuptools-scm
      python3.pkgs.pycodestyle
      python3.pkgs.pylint
    ];

    buildInputs = [
      librsync
      glib
    ];

    pythonPath = with python3.pkgs; [
      b2sdk
      boto3
      idna
      fasteners
      paramiko
      pexpect
    ];

    nativeCheckInputs = [
      gnupg
      gnutar
      librsync
      par2cmdline
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      util-linux
    ]
    ++ (with python3.pkgs; [
      lockfile
      mock
      pexpect
      pytestCheckHook
      fasteners
    ]);

    # Prevent double wrapping
    dontWrapGApps = true;

    preFixup =
      let
        binPath = lib.makeBinPath [
          gnupg
          ncftp
          rsync
        ];
      in
      ''
        makeWrapperArgsBak=("''${makeWrapperArgs[@]}")
        makeWrapperArgs+=(
          "''${gappsWrapperArgs[@]}"
          --prefix PATH : "${binPath}"
        )
      '';

    postFixup = ''
      # Restore previous value for tests wrapping in preInstallCheck
      makeWrapperArgs=("''${makeWrapperArgsBak[@]}")
    '';

    preCheck = ''
      HOME=$PWD/.home
      wrapPythonProgramsIn "$PWD/testing/overrides/bin" "''${pythonPath[*]}"
    '';

    doCheck = true;

    meta = {
      changelog = "https://gitlab.com/duplicity/duplicity/-/blob/${src.rev}/CHANGELOG.md";
      description = "Encrypted bandwidth-efficient backup using the rsync algorithm";
      homepage = "https://duplicity.gitlab.io/duplicity-web/";
      license = lib.licenses.gpl2Plus;
      mainProgram = "duplicity";
      maintainers = [ ];
    };
  };

in
self
