{
  lib,
  buildGo126Module,
  fetchFromGitHub,
  pkg-config,
  libpostal ? null,
}:

buildGo126Module (finalAttrs: {
  pname = "amass";
  version = "5.1.1";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = lib.optionals (libpostal != null) [ libpostal ];

  src = fetchFromGitHub {
    owner = "owasp-amass";
    repo = "Amass";
    tag = "v${finalAttrs.version}";
    hash = "sha256-d4zy64W5cIseOVAaekN5Q4I5WuLz+M/cP7FXQ3CQ+mk=";
  };

  vendorHash = "sha256-3MpE61ixMps4IRIZkqjzG225zk4fsERkssoNoItUXbQ=";

  doCheck = false;

  meta = {
    description = "In-Depth DNS Enumeration and Network Mapping";
    homepage = "https://owasp.org/www-project-amass/";
    license = lib.licenses.asl20;
    mainProgram = "amass";
  };
})
