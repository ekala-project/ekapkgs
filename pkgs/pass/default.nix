{
  stdenv,
  lib,
  fetchurl,
  bash,
  coreutils,
  findutils,
  gnugrep,
  gnused,
  getopt,
  git,
  tree,
  gnupg,
  openssl,
  which,
  openssh,
  procps,
  qrencode,
  makeWrapper,

  xclip ? null,
  x11Support ? !stdenv.hostPlatform.isDarwin,
}:

assert x11Support -> xclip != null;

stdenv.mkDerivation rec {
  version = "1.7.4";
  pname = "password-store";

  src = fetchurl {
    url = "https://git.zx2c4.com/password-store/snapshot/${pname}-${version}.tar.xz";
    sha256 = "1h4k6w7g8pr169p5w9n6mkdhxl3pw51zphx7www6pvgjb7vgmafg";
  };

  patches = [
    ./set-correct-program-name-for-sleep.patch
    ./extension-dir.patch
  ];

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [ bash ];

  installFlags = [
    "PREFIX=$(out)"
    "WITH_ALLCOMP=yes"
  ];

  wrapperPath = lib.makeBinPath (
    [
      coreutils
      findutils
      getopt
      git
      gnugrep
      gnupg
      gnused
      tree
      which
      openssh
      procps
      qrencode
    ]
    ++ lib.optional stdenv.hostPlatform.isDarwin openssl
    ++ lib.optional x11Support xclip
  );

  postFixup = ''
    # Fix program name in --help
    substituteInPlace $out/bin/pass \
      --replace 'PROGRAM="''${0##*/}"' "PROGRAM=pass"

    # Ensure all dependencies are in PATH
    wrapProgram $out/bin/pass \
      --prefix PATH : "${wrapperPath}"
  '';

  postPatch = ''
    patchShebangs tests

    substituteInPlace src/password-store.sh \
      --replace "@out@" "$out"

    # the turning
    sed -i -e 's@^PASS=.*''$@PASS=$out/bin/pass@' \
           -e 's@^GPGS=.*''$@GPG=${gnupg}/bin/gpg2@' \
           -e '/which gpg/ d' \
      tests/setup.sh
  '';

  doCheck = false;

  doInstallCheck = true;
  nativeInstallCheckInputs = [ git ];
  installCheckTarget = "test";

  meta = {
    description = "Stores, retrieves, generates, and synchronizes passwords securely";
    homepage = "https://www.passwordstore.org/";
    license = lib.licenses.gpl2Plus;
    mainProgram = "pass";
    platforms = lib.platforms.unix;
    longDescription = ''
      pass is a very simple password store that keeps passwords inside gpg2
      encrypted files inside a simple directory tree residing at
      ~/.password-store. The pass utility provides a series of commands for
      manipulating the password store, allowing the user to add, remove, edit,
      synchronize, generate, and manipulate passwords.
    '';
  };
}
