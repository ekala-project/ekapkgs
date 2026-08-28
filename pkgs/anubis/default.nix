{
  lib,
  buildGo126Module,
  fetchFromGitHub,
  fetchNpmDeps ? null,
  stdenv,
  npmHooks ? null,
  nodejs,
  esbuild,
  brotli,
  zstd,
}:

let
  hasNpm = fetchNpmDeps != null && npmHooks != null;
in

buildGo126Module (finalAttrs: {
  pname = "anubis";
  version = "1.26.2";

  src = fetchFromGitHub {
    owner = "TecharoHQ";
    repo = "anubis";
    tag = "v${finalAttrs.version}";
    hash = "sha256-yY8dwWyQy/N3A32MYtxLWAJCmR9rtSyzaYUHBNXRm/0=";
  };

  vendorHash = "sha256-+NPwL4p0p/s74m1Ld0z2GEcsWk5FqhcLbHrTNP3yEzk=";

  npmDeps =
    if hasNpm then
      fetchNpmDeps {
        name = "anubis-npm-deps";
        inherit (finalAttrs) src;
        hash = "sha256-SPoI66jy2XS4FM6BaJPt18dV1QM12nIOdeD5sAMaOzQ=";
      }
    else
      null;

  nativeBuildInputs = [
    esbuild
    brotli
    zstd
    nodejs
  ]
  ++ lib.optionals hasNpm [ npmHooks.npmConfigHook ];

  subPackages = [ "cmd/anubis" ];

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/TecharoHQ/anubis.Version=v${finalAttrs.version}"
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ "-extldflags=-static" ];

  prePatch = ''
    # we must forcefully disable the hook when creating the go vendor archive
    if [[ $name =~ go-modules ]]; then
      npmConfigHook() { true; }
    fi
  '';

  postPatch = ''
    patchShebangs \
      ./web/build.sh \
      ./lib/challenge/preact/build.sh \
      ./lib/challenge/proofofwork/build.sh
  '';

  preBuild = ''
    # do not run when creating go vendor archive
    if [[ ! $name =~ go-modules ]]; then
      # https://github.com/TecharoHQ/anubis/blob/main/xess/build.sh
      npx postcss ./xess/xess.css -o xess/xess.min.css
      go generate ./...
      ./web/build.sh
    fi
  '';

  preCheck = ''
    export DONT_USE_NETWORK=1
  '';

  meta = {
    description = "Weighs the soul of incoming HTTP requests using proof-of-work to stop AI crawlers";
    homepage = "https://anubis.techaro.lol/";
    downloadPage = "https://github.com/TecharoHQ/anubis";
    changelog = "https://github.com/TecharoHQ/anubis/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "anubis";
  };
})
