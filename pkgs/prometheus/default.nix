{
  stdenv,
  lib,
  go,
  buildGoModule,
  fetchFromGitHub,
  enableAWS ? true,
  enableAzure ? true,
  enableConsul ? true,
  enableDigitalOcean ? true,
  enableDNS ? true,
  enableEureka ? true,
  enableGCE ? true,
  enableHetzner ? true,
  enableIONOS ? true,
  enableKubernetes ? true,
  enableLinode ? true,
  enableMarathon ? true,
  enableMoby ? true,
  enableNomad ? true,
  enableOpenstack ? true,
  enableOVHCloud ? true,
  enablePuppetDB ? true,
  enableScaleway ? true,
  enableSTACKIT ? true,
  enableTriton ? true,
  enableUyuni ? true,
  enableVultr ? true,
  enableXDS ? true,
  enableZookeeper ? true,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "prometheus";
  version = "3.14.0";

  src = fetchFromGitHub {
    owner = "prometheus";
    repo = "prometheus";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7PSfh+KWUpmL3BZ7INa1DOZ/ysaXXdWG9n/F+H0cGYo=";
  };

  vendorHash = "sha256-sCgxO2/w3Bi6Ncs/Q+JVZVtQC448FEx3llYxe/UxWEE=";

  proxyVendor = true;

  outputs = [
    "out"
    "doc"
    "cli"
  ];

  excludedPackages = [
    "documentation/prometheus-mixin"
    "internal/tools"
    "web/ui/mantine-ui/src/promql/tools"
  ];

  postPatch = ''
    # Create minimal static assets directory so Go embed directive succeeds
    mkdir -p web/ui/static
    touch web/ui/static/.keep
    gzip -f9 web/ui/static/.keep

    patchShebangs scripts

    # Enable only select service discovery to shrink binaries.
    (
      true # prevent bash syntax error when all plugins are disabled
    ${lib.optionalString enableAWS "echo - github.com/prometheus/prometheus/discovery/aws"}
    ${lib.optionalString enableAzure "echo - github.com/prometheus/prometheus/discovery/azure"}
    ${lib.optionalString enableConsul "echo - github.com/prometheus/prometheus/discovery/consul"}
    ${lib.optionalString enableDigitalOcean "echo - github.com/prometheus/prometheus/discovery/digitalocean"}
    ${lib.optionalString enableDNS "echo - github.com/prometheus/prometheus/discovery/dns"}
    ${lib.optionalString enableEureka "echo - github.com/prometheus/prometheus/discovery/eureka"}
    ${lib.optionalString enableGCE "echo - github.com/prometheus/prometheus/discovery/gce"}
    ${lib.optionalString enableHetzner "echo - github.com/prometheus/prometheus/discovery/hetzner"}
    ${lib.optionalString enableIONOS "echo - github.com/prometheus/prometheus/discovery/ionos"}
    ${lib.optionalString enableKubernetes "echo - github.com/prometheus/prometheus/discovery/kubernetes"}
    ${lib.optionalString enableLinode "echo - github.com/prometheus/prometheus/discovery/linode"}
    ${lib.optionalString enableMarathon "echo - github.com/prometheus/prometheus/discovery/marathon"}
    ${lib.optionalString enableMoby "echo - github.com/prometheus/prometheus/discovery/moby"}
    ${lib.optionalString enableNomad "echo - github.com/prometheus/prometheus/discovery/nomad"}
    ${lib.optionalString enableOpenstack "echo - github.com/prometheus/prometheus/discovery/openstack"}
    ${lib.optionalString enableOVHCloud "echo - github.com/prometheus/prometheus/discovery/ovhcloud"}
    ${lib.optionalString enablePuppetDB "echo - github.com/prometheus/prometheus/discovery/puppetdb"}
    ${lib.optionalString enableScaleway "echo - github.com/prometheus/prometheus/discovery/scaleway"}
    ${lib.optionalString enableSTACKIT "echo - github.com/prometheus/prometheus/discovery/stackit"}
    ${lib.optionalString enableTriton "echo - github.com/prometheus/prometheus/discovery/triton"}
    ${lib.optionalString enableUyuni "echo - github.com/prometheus/prometheus/discovery/uyuni"}
    ${lib.optionalString enableVultr "echo - github.com/prometheus/prometheus/discovery/vultr"}
    ${lib.optionalString enableXDS "echo - github.com/prometheus/prometheus/discovery/xds"}
    ${lib.optionalString enableZookeeper "echo - github.com/prometheus/prometheus/discovery/zookeeper"}
    ) > plugins.yml
  '';

  preBuild = ''
    # CC and LD required to fix cross-compilation
    if [[ -d vendor ]]; then GOARCH= CC="$CC_FOR_BUILD" LD="$CC_FOR_BUILD" make -o assets plugins; fi

    # Recreate the `make assets-compress` target here - workaround permissions
    # errors
    cp web/ui/embed.go.tmpl web/ui/embed.go

    find web/ui/static -type f -name '*.gz' -print0 | sort -z | xargs -0 echo //go:embed >> web/ui/embed.go

    echo 'var EmbedFS embed.FS' >> web/ui/embed.go

    # EmbedFS requires relative paths
    substituteInPlace web/ui/embed.go --replace-fail "web/ui/" ""
  '';

  tags = [ "builtinassets" ];

  ldflags =
    let
      t = "github.com/prometheus/common/version";
    in
    [
      "-s"
      "-X ${t}.Version=${finalAttrs.version}"
      "-X ${t}.Revision=unknown"
      "-X ${t}.Branch=unknown"
      "-X ${t}.BuildUser=nix@nixpkgs"
      "-X ${t}.BuildDate=unknown"
      "-X ${t}.GoVersion=${lib.getVersion go}"
    ];

  preInstall = ''
    mkdir -p "$out/share/doc/prometheus" "$out/etc/prometheus"
    cp -a $src/documentation/* $out/share/doc/prometheus
  '';

  postInstall = ''
    moveToOutput bin/promtool $cli
  '';

  # Many TSDB tests fail with "no space left on device" in sandboxed builds
  doCheck = false;

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  meta = {
    description = "Service monitoring system and time series database";
    homepage = "https://prometheus.io";
    license = lib.licenses.asl20;
    changelog = "https://github.com/prometheus/prometheus/blob/v${finalAttrs.version}/CHANGELOG.md";
    mainProgram = "prometheus";
  };
})
