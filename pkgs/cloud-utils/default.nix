{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  gawk,
  gnused,
  util-linux,
  file,
  wget,
  python3,
  qemu-utils,
  e2fsprogs,
  cdrkit,
  gptfdisk,
}:
let
  guestDeps = [
    e2fsprogs
    gptfdisk
    gawk
    gnused
    util-linux
  ];
  binDeps = guestDeps ++ [
    wget
    file
    qemu-utils
    cdrkit
  ];
in
stdenv.mkDerivation (finalAttrs: {
  pname = "cloud-utils";
  version = "0.33";

  src = fetchFromGitHub {
    owner = "canonical";
    repo = "cloud-utils";
    tag = finalAttrs.version;
    hash = "sha256-YqfkmYclPZu6Mc2bFYxtiuH7uvfa3V4YlD0aHuKn1hw=";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ python3 ];

  installFlags = [
    "LIBDIR=$(out)/lib"
    "BINDIR=$(out)/bin"
    "MANDIR=$(out)/man/man1"
    "DOCDIR=$(out)/doc"
  ];

  outputs = [
    "out"
    "guest"
  ];

  postFixup = ''
    moveToOutput bin/ec2metadata $guest
    moveToOutput bin/growpart $guest
    moveToOutput bin/vcs-run $guest

    for i in $out/bin/*; do
      wrapProgram $i --prefix PATH : "${lib.makeBinPath binDeps}:$out/bin"
    done

    for i in $guest/bin/*; do
      wrapProgram $i --prefix PATH : "${lib.makeBinPath guestDeps}:$guest/bin"
      ln -s $i $out/bin
    done
  '';

  dontBuild = true;

  meta = {
    description = "Useful set of utilities for interacting with a cloud";
    homepage = "https://github.com/canonical/cloud-utils";
    platforms = lib.platforms.unix;
    license = lib.licenses.gpl3;
    maintainers = [ ];
  };
})
