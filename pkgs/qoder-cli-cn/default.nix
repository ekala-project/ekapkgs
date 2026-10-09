{
  stdenv,
  fetchurl,
  qoder-cli,
}:

let
  version = "1.1.65";

  platforms = {
    x86_64-linux = {
      url = "https://static.qoder.com.cn/qoder-cli-cn/releases/${version}/qoderclicn-linux-x64.tar.gz";
      hash = "sha256-oxa2Vt3uhPwWFUCsWu7vWykvAb47dz8k0+Ei8lEHnXk=";
    };
    aarch64-linux = {
      url = "https://static.qoder.com.cn/qoder-cli-cn/releases/${version}/qoderclicn-linux-arm64.tar.gz";
      hash = "sha256-wIybl2OYTN+uWsDgj4M6jyhW6q68vQLe8h02ygSGEKU=";
    };
    aarch64-darwin = {
      url = "https://static.qoder.com.cn/qoder-cli-cn/releases/${version}/qoderclicn-darwin-arm64.tar.gz";
      hash = "sha256-BPztsVrL1ZV39ZU3erOBdsbELjT0+eag3Z3N6liKJvg=";
    };
  };

  system = stdenv.hostPlatform.system;
  source = platforms.${system} or (throw "qoder-cli-cn: unsupported system ${system}");
in
# Same bun-compiled binary as qoder-cli, but built for the mainland China
# service: separate release channel/CDN, binary name and account backend.
qoder-cli.overrideAttrs (old: {
  pname = "qoder-cli-cn";
  inherit version;

  src = fetchurl {
    inherit (source) url hash;
  };

  installPhase = ''
    runHook preInstall
    install -Dm755 qoderclicn $out/bin/qoderclicn
    runHook postInstall
  '';

  meta = old.meta // {
    description = "Qoder CLI (mainland China edition) - terminal-based AI coding assistant";
    homepage = "https://qoder.cn";
    mainProgram = "qoderclicn";
  };
})
