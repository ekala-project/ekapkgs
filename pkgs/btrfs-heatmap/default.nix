{
  stdenv,
  lib,
  fetchFromGitHub,
  python3,
  installShellFiles,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "btrfs-heatmap";
  version = "9-1";

  src = fetchFromGitHub {
    owner = "knorrie";
    repo = "btrfs-heatmap";
    tag = "debian/${finalAttrs.version}";
    sha256 = "sha256-nyVT3bd4WSvv6SRL59/uEL8wQs+XQo7iPPqIDeluHik=";
  };

  buildInputs = [ python3 ];

  nativeBuildInputs = [
    python3.pkgs.wrapPython
    installShellFiles
  ];

  outputs = [
    "out"
    "man"
  ];

  installPhase = ''
    runHook preInstall

    install -Dm 0755 btrfs-heatmap $out/sbin/btrfs-heatmap
    installManPage man/btrfs-heatmap.1

    buildPythonPath ${python3.pkgs.btrfs}
    patchPythonScript $out/sbin/btrfs-heatmap

    runHook postInstall
  '';

  strictDeps = true;

  meta = {
    description = "Visualize the layout of a mounted btrfs";
    mainProgram = "btrfs-heatmap";
    homepage = "https://github.com/knorrie/btrfs-heatmap";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
  };
})
