{
  buildPerlPackage,
  fetchurl,
  lib,
  NumberCompare,
  TextGlob,
}:
buildPerlPackage {
  pname = "File-Find-Rule";
  version = "0.34";
  src = fetchurl {
    url = "mirror://cpan/authors/id/R/RC/RCLAMP/File-Find-Rule-0.34.tar.gz";
    hash = "sha256-fm8WzDPrHyn/Jb7lHVE/S4qElHu/oY7bLTzECi1kyv4=";
  };
  patches = [ ./CVE-2011-10007.patch ];
  propagatedBuildInputs = [
    NumberCompare
    TextGlob
  ];
  meta = {
    description = "File::Find::Rule is a friendlier interface to File::Find";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
