{
  lib,
  stdenv,
  fetchFromGitHub,
  buildGo126Module,
  coreutils,
  pcsclite,
  pkg-config,
  hsmSupport ? true,
}:

buildGo126Module rec {
  pname = "step-ca";
  version = "0.30.2";

  src = fetchFromGitHub {
    owner = "smallstep";
    repo = "certificates";
    tag = "v${version}";
    forceFetchGit = true;
    hash = "sha256-4cvrjAVvMDHlNhY/lbfgl6ZvX5LJGnPx0Km2BjPX8iU=";
  };

  vendorHash = "sha256-FBkQXKNtstQ+F7jvKUj6oCbsri+SjGKy0tG59TtUHPQ=";

  ldflags = [
    "-w"
    "-X main.Version=${version}"
  ];

  nativeBuildInputs = lib.optionals hsmSupport [ pkg-config ];

  buildInputs = lib.optionals (hsmSupport && stdenv.hostPlatform.isLinux) [ pcsclite ];

  postPatch = ''
    substituteInPlace authority/http_client_test.go --replace-fail 't.Run("SystemCertPool", func(t *testing.T) {' 't.Skip("SystemCertPool", func(t *testing.T) {'
    substituteInPlace systemd/step-ca.service --replace "/bin/kill" "${coreutils}/bin/kill"
  '';

  preBuild = ''
    ${lib.optionalString (!hsmSupport) "export CGO_ENABLED=0"}
  '';

  postInstall = ''
    install -Dm444 -t $out/lib/systemd/system systemd/step-ca.service
  '';

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  # Tests need to run in a reproducible order
  checkFlags = [ "-p 1" ];

  meta = {
    description = "Private certificate authority (X.509 & SSH) & ACME server for secure automated certificate management";
    homepage = "https://smallstep.com/certificates/";
    changelog = "https://github.com/smallstep/certificates/releases/tag/v${version}";
    license = lib.licenses.asl20;
    mainProgram = "step-ca";
    maintainers = [ ];
  };
}
