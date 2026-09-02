{
  lib,
  stdenv,
  fetchFromGitHub,
  buildGoModule,
  makeBinaryWrapper,
  installShellFiles,
  pkg-config,
  go-md2man,
  go,
  containerd,
  runc,
  tini,
  libtool,
  sqlite,
  iproute2,
  docker-compose,
  iptables,
  nftables,
  e2fsprogs,
  xz,
  xfsprogs,
  gitMinimal,
  procps,
  rootlesskit,
  slirp4netns,
  fuse-overlayfs,
  glibc,
  util-linux,
  symlinkJoin,
  systemd,
  btrfs-progs,
  lvm2,
  libseccomp,
  withSystemd ? true,
  withBtrfs ? true,
  withLvm ? true,
  withSeccomp ? true,
  clientOnly ? false,
}:

let
  version = "29.7.2";

  cliRev = "v${version}";
  cliHash = "sha256-ZYXRX4IQfUbb21yk/NodO5NH5OeX/KFDL9UdFS1e5ng=";

  mobyRev = "docker-v${version}";
  mobyHash = "sha256-k28c4cwt+ASVj8FTvM8dgIOL3yqR5wbI21r3LtrVamU=";

  runcRev = "v1.4.3";
  runcHash = "sha256-I9DruagoSWjrEBB4n+w5rzali5wvD/q3tVQFWPDnLAI=";

  containerdRev = "v2.3.3";
  containerdHash = "sha256-wa9Pixaq5RRrJucWibbBe4n6s53Pdj+mr5gLoFmDgLU=";

  tiniRev = "369448a167e8b3da4ca5bca0b3307500c3371828";
  tiniHash = "sha256-jCBNfoJAjmcTJBx08kHs+FmbaU82CbQcf0IVjd56Nuw=";

  docker-runc = runc.overrideAttrs {
    pname = "docker-runc";
    inherit version;

    src = fetchFromGitHub {
      owner = "opencontainers";
      repo = "runc";
      tag = runcRev;
      hash = runcHash;
    };

    preBuild = ''
      substituteInPlace Makefile --replace-warn "/bin/bash" "${stdenv.shell}"
    '';

    patches = [ ];
  };

  docker-containerd = containerd.overrideAttrs (oldAttrs: {
    pname = "docker-containerd";
    inherit version;

    outputs = [ "out" ];

    src = fetchFromGitHub {
      owner = "containerd";
      repo = "containerd";
      tag = containerdRev;
      hash = containerdHash;
    };

    buildInputs = oldAttrs.buildInputs ++ lib.optionals withSeccomp [ libseccomp ];

    installTargets = "install";
  });

  docker-tini = tini.overrideAttrs {
    pname = "docker-tini";
    inherit version;

    src = fetchFromGitHub {
      owner = "krallin";
      repo = "tini";
      rev = tiniRev;
      hash = tiniHash;
    };

    patches = [ ];

    postPatch = "";

    buildInputs = [
      glibc
      glibc.static
    ];

    env.NIX_CFLAGS_COMPILE = "-DMINIMAL=ON";
  };

  moby-src = fetchFromGitHub {
    owner = "moby";
    repo = "moby";
    tag = mobyRev;
    hash = mobyHash;
  };

  extraMobyPath = lib.makeBinPath [
    iproute2
    iptables
    e2fsprogs
    xz
    xfsprogs
    procps
    util-linux
    gitMinimal
  ];

  extraMobyUserPath = lib.optionalString (!clientOnly) (
    lib.makeBinPath [
      rootlesskit
      slirp4netns
      fuse-overlayfs
    ]
  );

  moby = buildGoModule {
    pname = "moby";
    inherit version;

    src = moby-src;

    vendorHash = null;

    nativeBuildInputs = [
      makeBinaryWrapper
      pkg-config
      go-md2man
      go
      libtool
      installShellFiles
    ];

    buildInputs = [
      sqlite
      nftables
    ]
    ++ lib.optionals withLvm [ lvm2 ]
    ++ lib.optionals withBtrfs [ btrfs-progs ]
    ++ lib.optionals withSystemd [ systemd ]
    ++ lib.optionals withSeccomp [ libseccomp ];

    postPatch = ''
      patchShebangs hack/make.sh hack/make/
    '';

    buildPhase = ''
      runHook preBuild

      export GOCACHE="$TMPDIR/go-cache"
      export AUTO_GOPATH=1
      export DOCKER_GITCOMMIT="${cliRev}"
      export VERSION="${version}"
      ./hack/make.sh dynbinary

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      install -Dm755 ./bundles/dynbinary-daemon/dockerd $out/libexec/docker/dockerd
      install -Dm755 ./bundles/dynbinary-daemon/docker-proxy $out/libexec/docker/docker-proxy

      makeWrapper $out/libexec/docker/dockerd $out/bin/dockerd \
        --prefix PATH : "$out/libexec/docker:${extraMobyPath}"

      ln -s ${docker-containerd}/bin/containerd $out/libexec/docker/containerd
      ln -s ${docker-containerd}/bin/containerd-shim-runc-v2 $out/libexec/docker/containerd-shim-runc-v2
      ln -s ${docker-runc}/bin/runc $out/libexec/docker/runc
      ln -s ${docker-tini}/bin/tini-static $out/libexec/docker/docker-init

      # systemd
      install -Dm644 ./contrib/init/systemd/docker.service $out/etc/systemd/system/docker.service
      substituteInPlace $out/etc/systemd/system/docker.service --replace-fail /usr/bin/dockerd $out/bin/dockerd
      install -Dm644 ./contrib/init/systemd/docker.socket $out/etc/systemd/system/docker.socket

      # rootless Docker
      install -Dm755 ./contrib/dockerd-rootless.sh $out/libexec/docker/dockerd-rootless.sh
      makeWrapper $out/libexec/docker/dockerd-rootless.sh $out/bin/dockerd-rootless \
        --prefix PATH : "$out/libexec/docker:${extraMobyPath}${
          lib.optionalString (extraMobyUserPath != "") ":${extraMobyUserPath}"
        }"

      runHook postInstall
    '';

    env.DOCKER_BUILDTAGS = toString (
      lib.optionals withSystemd [ "journald" ]
      ++ lib.optionals (!withBtrfs) [ "exclude_graphdriver_btrfs" ]
      ++ lib.optionals (!withLvm) [ "exclude_graphdriver_devicemapper" ]
      ++ lib.optionals withSeccomp [ "seccomp" ]
    );

    meta = {
      homepage = "https://mobyproject.org/";
      description = "Collaborative project for the container ecosystem to assemble container-based systems";
      license = lib.licenses.asl20;
      platforms = lib.platforms.linux;
    };
  };

  plugins = lib.optionals (docker-compose != null) [ docker-compose ];

  dockerCliPluginsDirs = lib.strings.concatStringsSep ":" (
    map (p: "${p}/libexec/docker/cli-plugins") plugins
  );
in
buildGoModule (
  {
    pname = "docker";
    inherit version;

    src = fetchFromGitHub {
      owner = "docker";
      repo = "cli";
      rev = cliRev;
      hash = cliHash;
    };

    patches = [
      ./cli-system-plugin-dir-from-env.patch
    ];

    vendorHash = null;

    nativeBuildInputs = [
      makeBinaryWrapper
      pkg-config
      go-md2man
      go
      libtool
      installShellFiles
    ];

    buildInputs = plugins ++ [
      glibc
      glibc.static
    ];

    postPatch = ''
      patchShebangs man scripts/build/
      substituteInPlace ./scripts/build/.variables --replace-fail "set -eu" ""
    '';

    buildPhase = ''
      runHook preBuild

      export GOCACHE="$TMPDIR/go-cache"

      mkdir -p .gopath/src/github.com/docker/
      ln -sf $PWD .gopath/src/github.com/docker/cli
      export GOPATH="$PWD/.gopath:$GOPATH"
      export GITCOMMIT="${cliRev}"
      export VERSION="${version}"
      export BUILDTIME="1970-01-01T00:00:00Z"
      make dynbinary

      runHook postBuild
    '';

    outputs = [ "out" ];

    installPhase = ''
      runHook preInstall

      install -Dm755 ./build/docker $out/libexec/docker/docker

      makeWrapper $out/libexec/docker/docker $out/bin/docker \
        --prefix PATH : "$out/libexec/docker" \
        --prefix DOCKER_CLI_PLUGIN_DIRS : "${dockerCliPluginsDirs}"
    ''
    + lib.optionalString (!clientOnly) ''
      ln -s ${moby}/bin/dockerd $out/bin/dockerd
      ln -s ${moby}/bin/dockerd-rootless $out/bin/dockerd-rootless

      mkdir -p $out/etc/systemd/system
      ln -s ${moby}/etc/systemd/system/docker.service $out/etc/systemd/system/docker.service
      ln -s ${moby}/etc/systemd/system/docker.socket $out/etc/systemd/system/docker.socket
    ''
    + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
      installShellCompletion --cmd docker \
        --bash <($out/bin/docker completion bash) \
        --fish <($out/bin/docker completion fish) \
        --zsh <($out/bin/docker completion zsh)
    ''
    + ''
      runHook postInstall
    '';

    passthru = {
      inherit moby-src;
    };

    meta = {
      homepage = "https://www.docker.com/";
      description = "Open source project to pack, ship and run any application as a lightweight container";
      license = lib.licenses.asl20;
      platforms = lib.platforms.linux;
      mainProgram = "docker";
    };
  }
  // lib.optionalAttrs (!clientOnly) {
    inherit
      docker-runc
      docker-containerd
      docker-tini
      moby
      ;
  }
)
