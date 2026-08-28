{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  pkgsBuildBuild,

  go,

  target ? "syncthing",
}:

assert builtins.elem target [
  "syncthing"
  "stdiscosrv" # syncthing-discovery
  "strelaysrv" # syncthing-relay
];

buildGoModule (finalAttrs: {
  pname = "syncthing";
  version = "2.1.3";

  src = fetchFromGitHub {
    owner = "syncthing";
    repo = "syncthing";
    tag = "v${finalAttrs.version}";
    hash = "sha256-uTjmOAjis2eBm2SnZbyvDDiQXKN8De+DhjNHbFLLbn0=";
  };

  vendorHash = "sha256-ueUf9YEa5z7mG6MofIJ3Xco+PxVPi/85Rdi+1aean6c=";

  doCheck = false;

  env = {
    BUILD_USER = "nix";
    BUILD_HOST = "nix";
  };

  buildPhase = ''
    runHook preBuild
    (
      export GOOS="${pkgsBuildBuild.go.GOOS}" GOARCH="${pkgsBuildBuild.go.GOARCH}" CC=$CC_FOR_BUILD
      go build build.go
      go generate github.com/syncthing/syncthing/lib/api/auto github.com/syncthing/syncthing/cmd/infra/strelaypoolsrv/auto
    )
    ./build -goos ${go.GOOS} -goarch ${go.GOARCH} -no-upgrade -version v${finalAttrs.version} build ${target}
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -Dm755 ${target} $out/bin/${target}
    runHook postInstall
  '';

  postInstall = ''
    # This installs man pages in the correct directory according to the suffix
    # on the filename
    for mf in man/*.[1-9]; do
      mantype="$(echo "$mf" | awk -F"." '{print $NF}')"
      mandir="$out/share/man/man$mantype"
      install -Dm644 "$mf" "$mandir/$(basename "$mf")"
    done

    install -Dm644 etc/linux-desktop/syncthing-ui.desktop $out/share/applications/syncthing-ui.desktop
    install -Dm644 assets/logo-32.png   $out/share/icons/hicolor/32x32/apps/syncthing.png
    install -Dm644 assets/logo-64.png   $out/share/icons/hicolor/64x64/apps/syncthing.png
    install -Dm644 assets/logo-128.png  $out/share/icons/hicolor/128x128/apps/syncthing.png
    install -Dm644 assets/logo-256.png  $out/share/icons/hicolor/256x256/apps/syncthing.png
    install -Dm644 assets/logo-512.png  $out/share/icons/hicolor/512x512/apps/syncthing.png
    install -Dm644 assets/logo-only.svg $out/share/icons/hicolor/scalable/apps/syncthing.svg

  ''
  + lib.optionalString (stdenv.hostPlatform.isLinux) ''
    mkdir -p $out/lib/systemd/{system,user}

    substitute etc/linux-systemd/system/syncthing@.service \
               $out/lib/systemd/system/syncthing@.service \
               --replace-fail /usr/bin/syncthing $out/bin/syncthing

    substitute etc/linux-systemd/user/syncthing.service \
               $out/lib/systemd/user/syncthing.service \
               --replace-fail /usr/bin/syncthing $out/bin/syncthing
  '';

  meta = {
    homepage = "https://syncthing.net/";
    description = "Open Source Continuous File Synchronization";
    donationPage = "https://syncthing.net/donations/";
    changelog = "https://github.com/syncthing/syncthing/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mpl20;
    mainProgram = target;
    platforms = lib.platforms.unix;
  };
})
