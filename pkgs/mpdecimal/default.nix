{
  lib,
  stdenv,
  fetchurl,
  autoreconfHook,
}:

stdenv.mkDerivation rec {
  pname = "mpdecimal";
  version = "4.0.0";
  outputs = [
    "out"
    "cxx"
    "doc"
    "dev"
  ];

  src = fetchurl {
    url = "https://www.bytereef.org/software/mpdecimal/releases/mpdecimal-${version}.tar.gz";
    hash = "sha256-lCRFwyRbInMP1Bpnp8XCMdEcsbmTa5wPdjNPt9C0Row=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  configureFlags = [ "LD=${stdenv.cc.targetPrefix}cc" ];

  postPatch = ''
    # Use absolute library install names on Darwin.
    substituteInPlace configure.ac \
      --replace-fail '-install_name @rpath/' "-install_name $out/lib/"
  '';

  postInstall = ''
    mkdir -p $cxx/lib
    mv $out/lib/*c++* $cxx/lib

    mkdir -p $dev/nix-support
    echo -n $cxx >> $dev/nix-support/propagated-build-inputs
  '';

  meta = {
    description = "Library for arbitrary precision decimal floating point arithmetic";
    homepage = "https://www.bytereef.org/mpdecimal/index.html";
    changelog = "https://www.bytereef.org/mpdecimal/changelog.html";
    license = lib.licenses.bsd2;
    maintainers = [ ];
    platforms = lib.platforms.unix ++ lib.platforms.windows;
  };
}
