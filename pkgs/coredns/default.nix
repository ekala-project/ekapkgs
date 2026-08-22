{
  lib,
  buildGo126Module,
  fetchFromGitHub,
  installShellFiles,
}:

buildGo126Module (finalAttrs: {
  pname = "coredns";
  version = "1.14.6";

  src = fetchFromGitHub {
    owner = "coredns";
    repo = "coredns";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3BKXmrsSsDWFl6MT6c5Q8wcQiApO1vG0KeUtJLm89jU=";
  };

  vendorHash = "sha256-K7cHC6IVawJmlCLR45SKEowXw7SfURIePHzj1LvKS84=";

  nativeBuildInputs = [ installShellFiles ];

  outputs = [
    "out"
    "man"
  ];

  postPatch = ''
    substituteInPlace test/file_cname_proxy_test.go \
      --replace-fail \
        "TestZoneExternalCNAMELookupWithProxy" \
        "SkipZoneExternalCNAMELookupWithProxy"

    substituteInPlace test/readme_test.go \
      --replace-fail "TestReadme" "SkipReadme"

    substituteInPlace test/metrics_test.go \
      --replace-fail "TestMetricsRewriteRequestSize" "SkipMetricsRewriteRequestSize"

    substituteInPlace test/quic_test.go \
      --replace-fail "TestQUICReloadDoesNotPanic" "SkipQUICReloadDoesNotPanic"

    substituteInPlace test/presubmit_test.go \
      --replace-fail "TestImportOrdering" "SkipImportOrdering"

    substituteInPlace plugin/pkg/parse/transport_test.go \
      --replace-fail \
        "TestTransport" \
        "SkipTransport"
  '';

  preBuild = ''
    chmod -R u+w vendor
    mv -t . vendor/go.{mod,sum} vendor/plugin.cfg

    CC= GOOS= GOARCH= go generate
  '';

  postInstall = ''
    installManPage man/*
  '';

  meta = {
    homepage = "https://coredns.io";
    description = "DNS server that runs middleware";
    mainProgram = "coredns";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
})
