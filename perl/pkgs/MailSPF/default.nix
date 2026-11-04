{
  buildPerlPackage,
  fetchurl,
  lib,
  perl,
  ModuleBuild,
  NetDNSResolverProgrammable,
  Error,
  NetAddrIP,
  NetDNS,
  URI,
}:
buildPerlPackage {
  pname = "Mail-SPF";
  version = "2.9.0";
  src = fetchurl {
    url = "mirror://cpan/authors/id/J/JM/JMEHNLE/mail-spf/Mail-SPF-v2.9.0.tar.gz";
    hash = "sha256-YctZFfHHrMepMf/Bv8EpG9+sVV4qRusjkbmV6p7LYWI=";
  };
  buildInputs = [
    ModuleBuild
    NetDNSResolverProgrammable
  ];
  propagatedBuildInputs = [
    Error
    NetAddrIP
    NetDNS
    URI
  ];
  buildPhase = "perl Build.PL --install_base=$out --install_path=\"sbin=$out/bin\" --install_path=\"lib=$out/${perl.libPrefix}\"; ./Build build ";
  meta = {
    description = "Object-oriented implementation of Sender Policy Framework";
    license = lib.licenses.bsd3;
    mainProgram = "spfquery";
  };
}
