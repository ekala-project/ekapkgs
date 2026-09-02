{
  enabledProviders ? null,

  bluez ? null,
  buildGo126Module,
  fd,
  fetchFromGitHub,
  imagemagick,
  lib,
  libqalculate ? null,
  makeWrapper,
  protobuf,
  protoc-gen-go,
  wl-clipboard,
}:
let
  providerEnabled = provider: (enabledProviders == null) || lib.elem provider enabledProviders;

  runtimeDeps =
    lib.optionals (providerEnabled "files") [ fd ]
    ++ lib.optionals (providerEnabled "bluetooth" && bluez != null) [ bluez ]
    ++ lib.optionals (providerEnabled "calc" && libqalculate != null) [ libqalculate ]
    ++ lib.optionals (providerEnabled "clipboard") [
      wl-clipboard
      imagemagick
    ];

in
buildGo126Module (finalAttrs: {
  pname = "elephant";
  version = "2.22.0";

  src = fetchFromGitHub {
    owner = "abenz1267";
    repo = "elephant";
    rev = "v${finalAttrs.version}";
    hash = "sha256-frlaSpCf/e94OqO5Glp1NW96bemc+BhrKoPu+4X1FyI=";
  };

  vendorHash = "sha256-ssX+ZQ6v+XcwC/RuIZ+rO/9zZwZnotudj8bvZNM7M3g=";

  buildInputs = [ protobuf ];
  nativeBuildInputs = [
    makeWrapper
    protoc-gen-go
  ];

  subPackages = [ "cmd/elephant" ];

  postBuild =
    (
      if enabledProviders == null then
        ''
          PROVIDERS=()
          for x in internal/providers/*/; do
            PROVIDERS+=("$(basename "$x")")
          done
        ''
      else
        ''
          PROVIDERS=(${lib.escapeShellArgs enabledProviders})
        ''
    )
    + ''
      echo "Installing providers"
      mkdir -p $out/lib/elephant/providers
      for provider in "''${PROVIDERS[@]}"; do
        [ -z "$provider" ] && continue
        if [ -d "internal/providers/$provider" ]; then
          echo "Building provider: $provider"
          go build -buildmode=plugin -o "$out/lib/elephant/providers/$provider.so" ./internal/providers/"$provider" || exit 1
        fi
      done
    '';

  postInstall = ''
    wrapProgram $out/bin/elephant \
      --prefix PATH : ${lib.makeBinPath runtimeDeps} \
      --set ELEPHANT_PROVIDER_DIR "$out/lib/elephant/providers"
  '';

  meta = {
    description = "Data provider service and backend for building custom application launchers";
    changelog = "https://github.com/abenz1267/elephant/releases/tag/v${finalAttrs.version}";
    homepage = "https://github.com/abenz1267/elephant";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    mainProgram = "elephant";
  };
})
