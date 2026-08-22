{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  bash,
  makeWrapper,
  pciutils,
}:

stdenvNoCC.mkDerivation {
  pname = "neofetch";
  version = "unstable-2021-12-10";

  src = fetchFromGitHub {
    owner = "dylanaraps";
    repo = "neofetch";
    rev = "ccd5d9f52609bbdcd5d8fa78c4fdb0f12954125f";
    sha256 = "sha256-9MoX6ykqvd2iB0VrZCfhSyhtztMpBTukeKejfAWYW1w=";
  };

  strictDeps = true;
  buildInputs = [ bash ];
  nativeBuildInputs = [ makeWrapper ];
  postPatch = ''
    patchShebangs --host neofetch
  '';

  postInstall = ''
    wrapProgram $out/bin/neofetch \
      --prefix PATH : ${lib.makeBinPath [ pciutils ]}
  '';

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "SYSCONFDIR=${placeholder "out"}/etc"
  ];

  meta = {
    description = "Fast, highly customizable system info script";
    homepage = "https://github.com/dylanaraps/neofetch";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = [ ];
    mainProgram = "neofetch";
  };
}
