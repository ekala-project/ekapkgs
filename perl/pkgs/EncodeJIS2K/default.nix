{ buildPerlPackage, fetchurl }:
buildPerlPackage {
  pname = "Encode-JIS2K";
  version = "0.03";
  src = fetchurl {
    url = "mirror://cpan/authors/id/D/DA/DANKOGAI/Encode-JIS2K-0.03.tar.gz";
    hash = "sha256-HshNcts53rTa1vypWs/MIQM/RaJNNHwg+aGmlolsNcw=";
  };
  outputs = [ "out" ];
}
