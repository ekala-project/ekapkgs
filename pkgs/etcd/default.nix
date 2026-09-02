{
  lib,
  buildGo124Module,
  fetchFromGitHub,
  symlinkJoin,
}:

let
  version = "3.5.21";
  etcdSrcHash = "sha256-0L/lA9/9SNKMz74R6UPF1I7gj03/e91EpNr4LxKoisw=";
  etcdServerVendorHash = "sha256-JMxkcDibRcXhU+T7BQMAz95O7xDKefu1YPZK0GU7osk=";
  etcdUtlVendorHash = "sha256-901QcnEQ8PWnkliqwL4CrbCD+0ja8vJlDke0P4ya8cA=";
  etcdCtlVendorHash = "sha256-BJ924wRPQTqbqtNtXL3l/OSdQv1UmU1y6Zqu//EWTHI=";

  src = fetchFromGitHub {
    owner = "etcd-io";
    repo = "etcd";
    rev = "v${version}";
    hash = etcdSrcHash;
  };

  env = {
    CGO_ENABLED = 0;
  };

  meta = with lib; {
    description = "Distributed reliable key-value store for the most critical data of a distributed system";
    license = licenses.asl20;
    homepage = "https://etcd.io/";
    platforms = platforms.darwin ++ platforms.linux;
  };

  etcdserver = buildGo124Module {
    pname = "etcdserver";

    inherit
      env
      meta
      src
      version
      ;

    vendorHash = etcdServerVendorHash;

    modRoot = "./server";

    preInstall = ''
      mv $GOPATH/bin/{server,etcd}
    '';

    ldflags = [ "-X go.etcd.io/etcd/api/v3/version.GitSHA=GitNotFound" ];

    doCheck = false;
  };

  etcdutl = buildGo124Module rec {
    pname = "etcdutl";

    inherit
      env
      meta
      src
      version
      ;

    vendorHash = etcdUtlVendorHash;

    modRoot = "./etcdutl";
  };

  etcdctl = buildGo124Module rec {
    pname = "etcdctl";

    inherit
      env
      meta
      src
      version
      ;

    vendorHash = etcdCtlVendorHash;

    modRoot = "./etcdctl";
  };
in
symlinkJoin {
  name = "etcd-${version}";

  inherit meta version;

  paths = [
    etcdserver
    etcdutl
    etcdctl
  ];
}
