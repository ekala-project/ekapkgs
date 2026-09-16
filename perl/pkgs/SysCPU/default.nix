{
  buildPerlPackage,
  fetchurl,
  fetchpatch,
  lib,
  stdenv,
}:
buildPerlPackage {
  pname = "Sys-CPU";
  version = "0.61";
  src = fetchurl {
    url = "mirror://cpan/authors/id/M/MZ/MZSANFORD/Sys-CPU-0.61.tar.gz";
    hash = "sha256-JQqGt5wjEAHErnHS9mQoCSpPuyBwlxrK/UcapJc5yeQ=";
  };
  patches = [
    (fetchpatch {
      url = "https://rt.cpan.org/Ticket/Attachment/1359669/721669/0001-Add-support-for-cpu_type-on-ARM-and-AArch64-Linux-pl.patch";
      hash = "sha256-oIJQX+Fz/CPmJNPuJyHVpJxJB2K5IQibnvaT4dv/qmY=";
    })
    (fetchpatch {
      url = "https://rt.cpan.org/Ticket/Attachment/1388036/737125/0002-cpu_clock-can-be-undefined-on-an-ARM.patch";
      hash = "sha256-nCypGyi6bZDEXqdb7wlGGzk9cFzmYkWGP1slBpXDfHw=";
    })
  ];
  doCheck = !stdenv.hostPlatform.isAarch64;
  meta = {
    description = "Perl extension for getting CPU information";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
