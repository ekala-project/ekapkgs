{
  lib,
  buildGo126Module,
  fetchFromGitLab ? null,
  installShellFiles,
}:

buildGo126Module (finalAttrs: {
  pname = "xmpp-dns";
  version = "0.6.4";

  src = fetchFromGitLab {
    domain = "salsa.debian.org";
    owner = "mdosch";
    repo = "xmpp-dns";
    tag = "v${finalAttrs.version}";
    hash = "sha256-aqj6RpTuZxb5GdRoNTX2eSz9LwjNB+M/po5ZQKJv2A0=";
  };
  vendorHash = "sha256-vKhzDtY5zeZT2AcqdSMP/KdTIiXCFuGGLdb5VvlWXbM=";

  nativeBuildInputs = [ installShellFiles ];
  postInstall = "installManPage man/xmpp-dns.1";

  meta = {
    description = "CLI tool to check XMPP SRV records";
    homepage = "https://salsa.debian.org/mdosch/xmpp-dns";
    license = lib.licenses.bsd2;
    maintainers = [ ];
    mainProgram = "xmpp-dns";
  };
})
