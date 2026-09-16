{
  buildPerlPackage,
  fetchurl,
  TextSoundex,
  ConvertASN1,
}:
buildPerlPackage {
  pname = "perl-ldap";
  version = "0.68";
  src = fetchurl {
    url = "mirror://cpan/authors/id/M/MA/MARSCHAP/perl-ldap-0.68.tar.gz";
    hash = "sha256-4vOJ/j56nkthSIaSkZrXI7mPO0ebUoj2ENqownmVs1E=";
  };
  # ldapi socket location should match the one compiled into the openldap package
  postPatch = ''
    for f in lib/Net/LDAPI.pm lib/Net/LDAP/Util.pm lib/Net/LDAP.pod lib/Net/LDAP.pm; do
      sed -i 's:/var/run/ldapi:/run/openldap/ldapi:g' "$f"
    done
  '';
  buildInputs = [ TextSoundex ];
  propagatedBuildInputs = [ ConvertASN1 ];
  meta = {
    description = "LDAP client library";
  };
}
