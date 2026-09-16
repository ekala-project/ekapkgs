{
  buildPerlModule,
  fetchurl,
  fetchpatch2,
  lib,
  stdenv,
  iana-etc,
  libredirect,
  CryptDES,
  CryptRijndael,
  DigestHMAC,
}:
buildPerlModule {
  pname = "Net-SNMP";
  version = "6.0.1";
  src = fetchurl {
    url = "mirror://cpan/authors/id/D/DT/DTOWN/Net-SNMP-v6.0.1.tar.gz";
    hash = "sha256-FMN7wcuz883H1sE+DyeoWfFM3P1epUoEZ6iLwlmwt0E=";
  };
  patches = [
    (fetchpatch2 {
      url = "https://src.fedoraproject.org/rpms/perl-Net-SNMP/raw/6e1d3e8ff2b9bd38dab48301a9d8b5d81ef3b7fe/f/Net-SNMP-v6.0.1-Switch_from_Socket6_to_Socket.patch";
      hash = "sha256-IpVhqI+dXqzauTkLF0Doulg5U33FxHUhqFTp0jeMtMY=";
    })
    (fetchpatch2 {
      url = "https://src.fedoraproject.org/rpms/perl-Net-SNMP/raw/6e1d3e8ff2b9bd38dab48301a9d8b5d81ef3b7fe/f/Net-SNMP-v6.0.1-Simple_rewrite_to_Digest-HMAC-helpers.patch";
      hash = "sha256-ZXo9w2YLtPmM1SJLvIiLWefw7SwrTFyTo4eX6DG1yfA=";
    })
    (fetchpatch2 {
      url = "https://src.fedoraproject.org/rpms/perl-Net-SNMP/raw/6e1d3e8ff2b9bd38dab48301a9d8b5d81ef3b7fe/f/Net-SNMP-v6.0.1-Split_usm.t_to_two_parts.patch";
      hash = "sha256-A2gsD6DIX1aFSVLbSL/1zKSM1xiM6hWBadJJH7f5E8o=";
    })
    (fetchpatch2 {
      url = "https://src.fedoraproject.org/rpms/perl-Net-SNMP/raw/6e1d3e8ff2b9bd38dab48301a9d8b5d81ef3b7fe/f/Net-SNMP-v6.0.1-Add_tests_for_another_usm_scenarios.patch";
      hash = "sha256-U7nNuL35l/zdSzx1jgjp1PmLQn3xzzDw9DGnyeydi2E=";
    })
    (fetchpatch2 {
      url = "https://src.fedoraproject.org/rpms/perl-Net-SNMP/raw/6e1d3e8ff2b9bd38dab48301a9d8b5d81ef3b7fe/f/Net-SNMP-v6.0.1-Rewrite_from_Digest-SHA1-to_Digest-SHA.patch";
      hash = "sha256-dznhj1Fcy0iBBl92p825InjkNZixR2MURVQ/b9bVjtc=";
    })
    ./net-snmp-add-sha-algorithms.patch
  ];
  preCheck = lib.optionalString stdenv.hostPlatform.isLinux ''
    export NIX_REDIRECTS=/etc/protocols=${iana-etc}/etc/protocols
  '';
  nativeCheckInputs = lib.optionals stdenv.hostPlatform.isLinux [ libredirect.hook ];
  propagatedBuildInputs = [
    CryptDES
    CryptRijndael
    DigestHMAC
  ];
  meta = {
    description = "Object oriented interface to SNMP";
  };
}
