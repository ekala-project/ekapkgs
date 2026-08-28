{
  lib,
  fetchFromGitHub,
  buildGoModule,
  libpcap,
}:

buildGoModule (finalAttrs: {
  pname = "ptcpdump";
  version = "0.37.0";

  src = fetchFromGitHub {
    owner = "mozillazg";
    repo = "ptcpdump";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ouH7VFWSCOElbmbSWAkmM4dtNVp545mC/FnoNAFtaEw=";
  };

  vendorHash = null;

  buildInputs = [ libpcap ];

  tags = [ "dynamic" ];

  ldflags = [
    "-X github.com/mozillazg/ptcpdump/internal.Version=v${finalAttrs.version}"
  ];

  checkFlags =
    let
      # Skip tests that require network access
      skippedTests = [
        "Test_loadSpecFromBTFHub"
        "Test_loadSpecFromOpenanolis"
      ];
    in
    [ "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$" ];

  meta = {
    homepage = "https://github.com/mozillazg/ptcpdump/";
    description = "Process-aware, eBPF-based tcpdump";
    mainProgram = "ptcpdump";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
  };
})
