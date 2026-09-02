{
  lib,
  buildGo126Module,
  fetchFromGitHub,
}:

buildGo126Module (finalAttrs: {
  pname = "jid";
  version = "1.1.3";

  src = fetchFromGitHub {
    owner = "simeji";
    repo = "jid";
    rev = "v${finalAttrs.version}";
    hash = "sha256-5Bi9nPOASxuZoxVxt6i3AQxvyWfe1B3JDSjXyuOPUHk=";
  };

  vendorHash = "sha256-ZqnIBmziPX45wqiEzD9mq4jLLW69mgGYhDSOTj20auQ=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Command-line tool to incrementally drill down JSON";
    mainProgram = "jid";
    homepage = "https://github.com/simeji/jid";
    license = lib.licenses.mit;
  };
})
