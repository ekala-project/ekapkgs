{
  buildPerlPackage,
  fetchurl,
  fetchpatch,
  lib,
  pkg-config,
  dbus,
  TestPod,
  TestPodCoverage,
  XMLTwig,
}:
buildPerlPackage {
  pname = "Net-DBus";
  version = "1.2.0";

  src = fetchurl {
    url = "mirror://cpan/authors/id/D/DA/DANBERR/Net-DBus-1.2.0.tar.gz";
    hash = "sha256-56GsnvShI1s/29WIj4bDRxgjBkZ715q8mwdWpktEHLw=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    dbus
    TestPod
    TestPodCoverage
  ];

  propagatedBuildInputs = [ XMLTwig ];

  patches = fetchpatch {
    url = "https://gitlab.com/berrange/perl-net-dbus/-/commit/6bac8f188fb06e5e5edd27aee672d66b7c28caa4.patch";
    hash = "sha256-68kyUxM3E7w99rM2AZWZQMpGcaQxfSWaBs3DnmwnzqY=";
  };

  postPatch = ''
    substituteInPlace Makefile.PL --replace pkg-config $PKG_CONFIG
  '';

  meta = {
    description = "Extension for the DBus bindings";
    homepage = "https://www.freedesktop.org/wiki/Software/dbus";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
