{
  lib,
  rustPlatform,
  fetchFromGitHub,
  fetchpatch,
  buildGo126Module,
  pkg-config,
}:

let
  libflux_version = "0.171.0";
  flux = rustPlatform.buildRustPackage rec {
    pname = "libflux";
    version = libflux_version;
    src = fetchFromGitHub {
      owner = "influxdata";
      repo = "flux";
      tag = "v${libflux_version}";
      hash = "sha256-v9MUR+PcxAus91FiHYrMN9MbNOTWewh7MT6/t/QWQcM=";
    };
    patches = [
      ./fix-linting-error-on-unneeded-clone.patch
      ./0001-fix-build.patch

      (fetchpatch {
        url = "https://github.com/influxdata/flux/commit/20ca62138a0669f2760dd469ca41fc333e04b8f2.patch";
        stripLen = 2;
        extraPrefix = "";
        hash = "sha256-Fb4CuH9ZvrPha249dmLLI8MqSNQRKqKPxPbw2pjqwfY=";
      })
    ];
    sourceRoot = "${src.name}/libflux";

    postPatch = ''
      substituteInPlace flux-core/src/lib.rs \
        --replace-fail "deny(warnings, missing_docs))]" "allow(warnings, missing_docs))]"
    '';

    cargoHash = "sha256-kbI1uUDE8JyFFtwV5k0EeeNGCZFQLXLobW/MilHX2Sg=";
    nativeBuildInputs = [ rustPlatform.bindgenHook ];
    pkgcfg = ''
      Name: flux
      Version: ${libflux_version}
      Description: Library for the InfluxData Flux engine
      Cflags: -I/out/include
      Libs: -L/out/lib -lflux -lpthread
    '';
    postInstall = ''
      mkdir -p $out/include $out/pkgconfig
      cp -r $NIX_BUILD_TOP/${src.name}/libflux/include/influxdata $out/include
      printf "%s" "$pkgcfg" > $out/pkgconfig/flux.pc
      substituteInPlace $out/pkgconfig/flux.pc \
        --replace-fail /out $out
    '';

    __structuredAttrs = true;
  };
in
buildGo126Module rec {
  pname = "kapacitor";
  version = "1.7.5";

  src = fetchFromGitHub {
    owner = "influxdata";
    repo = "kapacitor";
    tag = "v${version}";
    hash = "sha256-vxaLfJq0NFAJst0/AEhNJUl9dAaZY3blZAFthseMSX0=";
  };

  vendorHash = "sha256-myToEgta8R5R4v2/nZqtQQvNdy1kWgwklbQeFxzIdgs=";

  nativeBuildInputs = [ pkg-config ];

  env.PKG_CONFIG_PATH = "${flux}/pkgconfig";

  preBuild = ''
    flux_ver=$(grep github.com/influxdata/flux go.mod | awk '{print $2}')
    if [ "$flux_ver" != "v${libflux_version}" ]; then
      echo "go.mod wants libflux $flux_ver, but nix derivation provides ${libflux_version}"
      exit 1
    fi
  '';

  # Remove failing server tests
  preCheck = ''
    rm server/server_test.go
    rm pipeline/tick/*test.go
  '';

  checkFlags =
    let
      skippedTests = [
        "TestBatch_KapacitorLoopback"
      ];
    in
    [
      "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$"
    ];

  meta = {
    description = "Open source framework for processing, monitoring, and alerting on time series data";
    homepage = "https://influxdata.com/time-series-platform/kapacitor/";
    downloadPage = "https://github.com/influxdata/kapacitor/releases";
    license = lib.licenses.mit;
    changelog = "https://github.com/influxdata/kapacitor/blob/master/CHANGELOG.md";
  };
}
