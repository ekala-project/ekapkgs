{
  buildPerlPackage,
  fetchurl,
  openssl,
  openssh,
}:
buildPerlPackage {
  pname = "Net-SFTP-Foreign";
  version = "1.93";
  src = fetchurl {
    url = "mirror://cpan/authors/id/S/SA/SALVA/Net-SFTP-Foreign-1.93.tar.gz";
    hash = "sha256-bH1kJQh2hz2kNIAOUGCovvekZFHYH4F+N+Q8/aUaD3o=";
  };
  propagatedBuildInputs = [ openssl ];
  patchPhase = ''
    sed -i "s|$ssh_cmd = 'ssh'|$ssh_cmd = '${openssh}/bin/ssh'|" lib/Net/SFTP/Foreign/Backend/Unix.pm
  '';
  meta = {
    description = "Secure File Transfer Protocol client";
  };
}
