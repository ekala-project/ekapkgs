{
  lib,
  fetchFromGitHub,
  rustPlatform,
  installShellFiles,
  lld,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "bear";
  version = "4.2.2";

  src = fetchFromGitHub {
    owner = "rizsotto";
    repo = "bear";
    rev = finalAttrs.version;
    hash = "sha256-gbDRK4M13jRBCIYWn8so4bKHqCjL2YOF15CqIB2HqIQ=";
  };

  cargoHash = "sha256-BZaydfkYyYtQWvM16VwBbeIz/vyfYSa/jSIulnWBNg8=";

  nativeBuildInputs = [
    installShellFiles
    lld
  ];

  postInstall = ''
        # Arrange binaries into the expected layout:
        # bear-driver finds bear-wrapper as a sibling in the same dir,
        # and libexec.so at ../lib/libexec.so relative to its location.
        install -d $out/libexec/bear/bin
        install -d $out/libexec/bear/lib
        mv $out/bin/bear-driver $out/libexec/bear/bin/bear-driver
        mv $out/bin/bear-wrapper $out/libexec/bear/bin/bear-wrapper
        mv $out/lib/libexec.so $out/libexec/bear/lib/libexec.so

        # Create the bear wrapper script
        rm -f $out/bin/bear
        cat > $out/bin/bear <<EOF
    #!/bin/sh
    exec $out/libexec/bear/bin/bear-driver "\$@"
    EOF
        chmod 755 $out/bin/bear

        # Remove the completions generator binary
        rm -f $out/bin/generate-completions

        installManPage man/bear.1
  '';

  meta = {
    description = "Tool that generates a compilation database for clang tooling";
    mainProgram = "bear";
    homepage = "https://github.com/rizsotto/Bear";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.unix;
  };
})
