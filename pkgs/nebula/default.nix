{
  lib,
  buildGo126Module,
  fetchFromGitHub,
  withPkcs11 ? true,
}:

buildGo126Module (finalAttrs: {
  pname = "nebula";
  version = "1.11.1";

  src = fetchFromGitHub {
    owner = "slackhq";
    repo = "nebula";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3YxOq9kxNShkIbFZ6P9kCkNl8nraICMlp2jSCBnlSP4=";
  };

  vendorHash = "sha256-I0pV4nosm1j7FqGmgkQWe24umRzBnMb2gvEiZr0uTFo=";

  subPackages = [
    "cmd/nebula"
    "cmd/nebula-cert"
  ];

  tags = lib.optional withPkcs11 "pkcs11";

  ldflags = [ "-X main.Build=${finalAttrs.version}" ];

  checkFlags = [
    "-v"
  ]
  ++ lib.optionals withPkcs11 [
    "-tags"
    "pkcs11"
  ];

  env = lib.optionalAttrs (!withPkcs11) {
    CGO_ENABLED = 0;
  };

  meta = {
    description = "Overlay networking tool with a focus on performance, simplicity and security";
    longDescription = ''
      Nebula is a scalable overlay networking tool with a focus on performance,
      simplicity and security. It lets you seamlessly connect computers
      anywhere in the world. Nebula is portable, and runs on Linux, OSX, and
      Windows. (Also: keep this quiet, but we have an early prototype running
      on iOS). It can be used to connect a small number of computers, but is
      also able to connect tens of thousands of computers.

      Nebula incorporates a number of existing concepts like encryption,
      security groups, certificates, and tunneling, and each of those
      individual pieces existed before Nebula in various forms. What makes
      Nebula different to existing offerings is that it brings all of these
      ideas together, resulting in a sum that is greater than its individual
      parts.
    '';
    homepage = "https://github.com/slackhq/nebula";
    changelog = "https://github.com/slackhq/nebula/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
