{
  stdenvNoCC,
  fetchzip,
  lib,
  python3,
  rdfind,
  which,
  writeShellScriptBin,
}:
let
  gitStub = writeShellScriptBin "git" ''
    if [ "$1" == "ls-files" ]; then
      find -type f -printf "%P\n"
    else
      echo "Git stub called with unexpected arguments $@" >&2
      exit 1
    fi
  '';
in
stdenvNoCC.mkDerivation rec {
  pname = "linux-firmware";
  version = "20250613";

  src = fetchzip {
    url = "https://cdn.kernel.org/pub/linux/kernel/firmware/linux-firmware-${version}.tar.xz";
    hash = "sha256-qygwQNl99oeHiCksaPqxxeH+H7hqRjbqN++Hf9X+gzs=";
  };

  postUnpack = ''
    patchShebangs .
  '';

  nativeBuildInputs = [
    gitStub
    python3
    rdfind
    which
  ];

  installTargets = [
    "install"
    "dedup"
  ];
  makeFlags = [ "DESTDIR=$(out)" ];

  dontFixup = true;

  meta = {
    description = "Binary firmware collection packaged by kernel.org";
    homepage = "https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git";
    license = lib.licenses.unfreeRedistributableFirmware;
    platforms = lib.platforms.linux;
    priority = 6;
  };
}
