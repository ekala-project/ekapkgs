{
  buildPerlModule,
  fetchFromGitLab,
  lib,
  pkg-config,
  libvirt,
  CPANChanges,
  TestPod,
  TestPodCoverage,
  XMLXPath,
}:
buildPerlModule rec {
  pname = "Sys-Virt";
  version = "12.7.0";

  src = fetchFromGitLab {
    owner = "libvirt";
    repo = "libvirt-perl";
    tag = "v${version}";
    hash = "sha256-iGTS/0G5VG8iidwNclpJ/b93Rt2DxrRJxZZH8Fucz8M=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    libvirt
    CPANChanges
    TestPod
    TestPodCoverage
    XMLXPath
  ];

  meta = {
    description = "Libvirt Perl API";
    homepage = "https://libvirt.org";
    license = with lib.licenses; [
      gpl2Plus
      artistic1
    ];
  };
}
