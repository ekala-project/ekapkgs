{
  lib,
  stdenv,
  fetchFromGitLab,
}:

stdenv.mkDerivation rec {
  pname = "lmdb";
  version = "0.9.35";

  src = fetchFromGitLab {
    domain = "git.openldap.org";
    owner = "openldap";
    repo = "openldap";
    rev = "LMDB_${version}";
    sha256 = "sha256-XkOeVqzKojRLojBLkXB0V9lypJnL5ZmGAwutn6aRQIU=";
  };

  postUnpack = "sourceRoot=\${sourceRoot}/libraries/liblmdb";

  patches = [
    ./hardcoded-compiler.patch
    ./bin-ext.patch
  ];
  patchFlags = [ "-p3" ];

  postPatch = lib.optionalString stdenv.hostPlatform.isStatic ''
    sed 's/^ILIBS\>.*/ILIBS = liblmdb.a/' -i Makefile
  '';

  outputs = [
    "bin"
    "out"
    "dev"
  ];

  makeFlags = [
    "prefix=$(out)"
    "CC=${stdenv.cc.targetPrefix}cc"
    "AR=${stdenv.cc.targetPrefix}ar"
  ]
  ++ lib.optional stdenv.hostPlatform.isDarwin "LDFLAGS=-Wl,-install_name,$(out)/lib/liblmdb.so";

  doCheck = true;
  checkTarget = "test";

  postInstall = ''
    moveToOutput bin "$bin"
  ''
  + ''
    mkdir -p "$dev/lib/pkgconfig"
    cat > "$dev/lib/pkgconfig/lmdb.pc" <<EOF
    Name: lmdb
    Description: ${meta.description}
    Version: ${version}

    Cflags: -I$dev/include
    Libs: -L$out/lib -llmdb
    EOF

    ln -s lmdb.pc "$dev/lib/pkgconfig/liblmdb.pc"
  '';

  meta = {
    description = "Lightning memory-mapped database";
    homepage = "https://symas.com/lmdb/";
    license = lib.licenses.openldap;
    platforms = lib.platforms.all;
  };
}
