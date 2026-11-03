{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  bash,
  cabextract,
  coreutils,
  curl,
  gawk,
  grep,
  sed,
  tar,
  gzip,
  p7zip,
  perl,
  unzip,
  which,
  zenity,
  unrar-free,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "winetricks";
  version = "20250530";

  src = fetchFromGitHub {
    owner = "Winetricks";
    repo = "winetricks";
    tag = finalAttrs.version;
    hash = "sha256-Lbz+OFBfF8fCVf7RRxn6+aMVr4q0DFWOfNDzpXeKlbk=";
  };

  buildInputs = [
    perl
    which
    makeWrapper
  ];

  makeFlags = [ "PREFIX=$(out)" ];

  doCheck = false;

  postPatch = ''
    patchShebangs src/winetricks
    substituteInPlace src/winetricks \
      --replace-fail 'command -v unrar' 'command -v unrar-free' \
      --replace-fail 'w_try unrar' 'w_try unrar-free'
  '';

  postInstall =
    let
      runtimeDependencies = [
        bash
        cabextract
        coreutils
        curl
        gawk
        grep
        sed
        tar
        gzip
        p7zip
        perl
        unrar-free
        unzip
        which
        zenity
      ];
    in
    ''
      wrapProgram $out/bin/winetricks \
        --prefix PATH : "${lib.makeBinPath runtimeDependencies}" \
        --set WINETRICKS_LATEST_VERSION_CHECK "disabled"
    '';

  meta = {
    description = "Script to install DLLs needed to work around problems in Wine";
    mainProgram = "winetricks";
    license = lib.licenses.lgpl21;
    homepage = "https://github.com/Winetricks/winetricks";
    platforms = lib.platforms.linux;
    broken = true; # source download returns 404
  };
})
