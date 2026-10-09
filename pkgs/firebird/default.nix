{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchDebianPatch,
  libedit,
  autoreconfHook,
  zlib,
  unzip,
  libtommath,
  libtomcrypt,
  icu,
  superServer ? false,
}:

let
  base = {
    pname = "firebird";

    meta = {
      description = "SQL relational database management system";
      downloadPage = "https://github.com/FirebirdSQL/firebird/";
      homepage = "https://firebirdsql.org/";
      changelog = "https://github.com/FirebirdSQL/firebird/blob/master/CHANGELOG.md";
      license = with lib.licenses; [
        mpl11
        interbase
      ];
      platforms = lib.platforms.linux;
    };

    nativeBuildInputs = [ autoreconfHook ];

    buildInputs = [
      libedit
      icu.v73
    ];

    LD_LIBRARY_PATH = lib.makeLibraryPath [ icu.v73 ];

    # The build-time step that creates the system databases (security.fdb,
    # metadata.fdb, ...) runs the freshly-built engine, which dlopens ICU.
    # Export the path again inside the build so the loader finds it.
    preBuild = ''
      export LD_LIBRARY_PATH="${lib.makeLibraryPath [ icu.v73 ]}''${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
    '';

    NIX_LDFLAGS = "-L${lib.getLib icu.v73}/lib -licuuc -licui18n -licudata";

    configureFlags = [
      "--with-system-editline"
    ]
    ++ (lib.optional superServer "--enable-superserver");

    enableParallelBuilding = true;

    installPhase = ''
      runHook preInstall
      mkdir -p $out
      cp -r gen/Release/firebird/* $out
      rm -f $out/lib/*.a  # they were just symlinks to /build/source/...
      runHook postInstall
    '';

  };
in
stdenv.mkDerivation (
  base
  // rec {
    version = "4.0.6";

    src = fetchFromGitHub {
      owner = "FirebirdSQL";
      repo = "firebird";
      rev = "v${version}";
      hash = "sha256-65wfG6huDzvG/tEVllA58OfZqoL4U/ilw5YIDqQywTs=";
    };

    nativeBuildInputs = base.nativeBuildInputs ++ [ unzip ];
    buildInputs = base.buildInputs ++ [
      zlib
      libtommath
      libtomcrypt
    ];
  }
)
