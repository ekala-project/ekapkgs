{
  lib,
  stdenv,
  fetchurl,
  perl,
  openldap,
  pam,
  db,
  cyrus_sasl,
  libcap,
  expat,
  libxml2,
  openssl,
  pkg-config,
  systemd,
  cppunit,
  ipv6 ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "squid";
  version = "7.6";

  src = fetchurl {
    url = "https://github.com/squid-cache/squid/releases/download/SQUID_${
      builtins.replaceStrings [ "." ] [ "_" ] finalAttrs.version
    }/squid-${finalAttrs.version}.tar.xz";
    hash = "sha256-hSF4/cN8WweGqTT8mQx9L//IKs8ZsihL4gm5ZDHSWZI=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    perl
    openldap
    db
    cyrus_sasl
    expat
    libxml2
    openssl
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    libcap
    pam
    systemd
  ];

  enableParallelBuilding = true;

  configureFlags = [
    "--disable-strict-error-checking"
    "--disable-arch-native"
    "--with-openssl"
    "--enable-ssl-crtd"
    "--enable-storeio=ufs,aufs,diskd,rock"
    "--enable-removal-policies=lru,heap"
    "--enable-delay-pools"
    "--enable-x-accelerator-vary"
    "--enable-htcp"
  ]
  ++ (if ipv6 then [ "--enable-ipv6" ] else [ "--disable-ipv6" ])
  ++ lib.optional (
    stdenv.hostPlatform.isLinux && !stdenv.hostPlatform.isMusl
  ) "--enable-linux-netfilter";

  doCheck = true;
  nativeCheckInputs = [ cppunit ];
  preCheck = ''
    echo "#!$SHELL" > fake-true
    chmod +x fake-true
    grep -rlF '/bin/true' test-suite/ | while read -r filename ; do
      substituteInPlace "$filename" \
        --replace "$(type -P true)" "$(realpath fake-true)" \
        --replace "/bin/true" "$(realpath fake-true)"
    done

    cd test-suite/
  '';

  postCheck = ''
    cd ..
  '';

  postInstall = ''
    rm -r $out/var
    rm $out/share/mib.txt
    mv $out/sbin $out/bin
  '';

  meta = {
    description = "Caching proxy for the Web supporting HTTP, HTTPS, FTP, and more";
    homepage = "http://www.squid-cache.org";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
})
