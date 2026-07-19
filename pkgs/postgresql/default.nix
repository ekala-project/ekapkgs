{
  lib,
  stdenv,
  fetchFromGitHub,
  # runtime deps
  readline,
  zlib,
  openssl,
  libxml2,
  libuuid,
  lz4,
  zstd,
  icu,
  tzdata,
  glibc,
  # build deps
  bison,
  flex,
  pkg-config,
  perl,
  libxslt,
  docbook-xsl-nons,
  docbook_xml_dtd_45,
  makeBinaryWrapper,
  removeReferencesTo,
  # optional language support
  python3,
  tcl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "postgresql";
  version = "17.10";

  src = fetchFromGitHub {
    owner = "postgres";
    repo = "postgres";
    rev = "refs/tags/REL_17_10";
    hash = "sha256-3ZAqlT3R8ywhNH13oqz2VUbSwpOJ2JaICbxZ29awaMw=";
  };

  __structuredAttrs = true;

  outputs = [
    "out"
    "dev"
    "doc"
    "lib"
    "man"
  ];

  strictDeps = true;

  buildInputs = [
    zlib
    readline
    openssl
    libxml2
    libuuid
    icu
    lz4
    zstd
  ];

  nativeBuildInputs = [
    bison
    docbook-xsl-nons
    docbook_xml_dtd_45
    flex
    libxml2
    libxslt
    makeBinaryWrapper
    perl
    pkg-config
    removeReferencesTo
  ];

  enableParallelBuilding = true;

  separateDebugInfo = true;

  buildFlags = [ "world" ];

  env = {
    CFLAGS = "-fdata-sections -ffunction-sections";
    LDFLAGS = "-Wl,--gc-sections";
    NIX_CFLAGS_COMPILE = "-UUSE_PRIVATE_ENCODING_FUNCS";
  };

  configureFlags = [
    "--with-openssl"
    "--with-libxml"
    "--with-icu"
    "--sysconfdir=/etc"
    "--with-system-tzdata=${tzdata}/share/zoneinfo"
    "--enable-debug"
    "--with-uuid=e2fs"
    "--with-lz4"
    "--with-zstd"
  ];

  patches =
    let
      mkPatch = name: text: builtins.toFile name text;
    in
    [
      # On NixOS we want stuff relative to symlinks
      (mkPatch "relative-to-symlinks.patch" ''
        --- a/src/common/exec.c
        +++ b/src/common/exec.c
        @@ -238,6 +238,8 @@
         static int
         normalize_exec_path(char *path)
         {
        +	return 0;
        +
         	/*
         	 * We used to do a lot of work ourselves here, but now we just let
         	 * realpath(3) do all the heavy lifting.
      '')
      # Use less instead of more as the default pager
      (mkPatch "less-is-more.patch" ''
        --- a/src/include/fe_utils/print.h
        +++ b/src/include/fe_utils/print.h
        @@ -18,7 +18,7 @@

         /* This is not a particularly great place for this ... */
         #ifndef __CYGWIN__
        -#define DEFAULT_PAGER "more"
        +#define DEFAULT_PAGER "less"
         #else
         #define DEFAULT_PAGER "less"
         #endif
      '')
      # Default socket directory to /run/postgresql
      (mkPatch "socketdir-in-run.patch" ''
        --- a/src/include/pg_config_manual.h
        +++ b/src/include/pg_config_manual.h
        @@ -201,7 +201,7 @@
          * support them yet.
          */
         #ifndef WIN32
        -#define DEFAULT_PGSOCKET_DIR  "/tmp"
        +#define DEFAULT_PGSOCKET_DIR  "/run/postgresql"
         #else
         #define DEFAULT_PGSOCKET_DIR ""
         #endif
      '')
      # Fix Nix store paths confusing the postgresql suffix detection
      (mkPatch "paths-with-postgresql-suffix.patch" ''
        --- a/src/Makefile.global.in
        +++ b/src/Makefile.global.in
        @@ -102,15 +102,15 @@
         bindir := @bindir@

         datadir := @datadir@
        -ifeq "$(findstring pgsql, $(datadir))" ""
        -ifeq "$(findstring postgres, $(datadir))" ""
        +ifeq "$(findstring pgsql, $(notdir $(datadir)))" ""
        +ifeq "$(findstring postgres, $(notdir $(datadir)))" ""
         override datadir := $(datadir)/postgresql
         endif
         endif

         sysconfdir := @sysconfdir@
        -ifeq "$(findstring pgsql, $(sysconfdir))" ""
        -ifeq "$(findstring postgres, $(sysconfdir))" ""
        +ifeq "$(findstring pgsql, $(notdir $(sysconfdir)))" ""
        +ifeq "$(findstring postgres, $(notdir $(sysconfdir)))" ""
         override sysconfdir := $(sysconfdir)/postgresql
         endif
         endif
        @@ -136,8 +136,8 @@
         mandir := @mandir@

         docdir := @docdir@
        -ifeq "$(findstring pgsql, $(docdir))" ""
        -ifeq "$(findstring postgres, $(docdir))" ""
        +ifeq "$(findstring pgsql, $(notdir $(docdir)))" ""
        +ifeq "$(findstring postgres, $(notdir $(docdir)))" ""
         override docdir := $(docdir)/postgresql
         endif
         endif
      '')
      # Redirect PGXS path in config_info.c to the dev output
      (mkPatch "paths-for-split-outputs.patch" ''
        --- a/src/common/config_info.c
        +++ b/src/common/config_info.c
        @@ -118,7 +118,7 @@
         	i++;

         	configdata[i].name = pstrdup("PGXS");
        +	strlcpy(path, "@dev@/lib", sizeof(path));
        -	get_pkglib_path(my_exec_path, path);
         	strlcat(path, "/pgxs/src/makefiles/pgxs.mk", sizeof(path));
         	cleanup_path(path);
         	configdata[i].setting = pstrdup(path);
        --- a/src/Makefile.global.in
        +++ b/src/Makefile.global.in
        @@ -116,7 +116,7 @@

         libdir := @libdir@

        -pkglibdir = $(libdir)
        +pkglibdir = @out@/lib
         ifeq "$(findstring pgsql, $(pkglibdir))" ""
         ifeq "$(findstring postgres, $(pkglibdir))" ""
         override pkglibdir := $(pkglibdir)/postgresql
      '')
      # Empty the pg_config system information view to avoid references
      (mkPatch "empty-pg-config-view.patch" ''
        --- a/src/backend/utils/misc/pg_config.c
        +++ b/src/backend/utils/misc/pg_config.c
        @@ -32,20 +32,5 @@
         	/* initialize our tuplestore */
         	InitMaterializedSRF(fcinfo, 0);

        -	configdata = get_configdata(my_exec_path, &configdata_len);
        -	for (i = 0; i < configdata_len; i++)
        -	{
        -		Datum		values[2];
        -		bool		nulls[2];
        -
        -		memset(values, 0, sizeof(values));
        -		memset(nulls, 0, sizeof(nulls));
        -
        -		values[0] = CStringGetTextDatum(configdata[i].name);
        -		values[1] = CStringGetTextDatum(configdata[i].setting);
        -
        -		tuplestore_putvalues(rsinfo->setResult, rsinfo->setDesc, values, nulls);
        -	}
        -
         	return (Datum) 0;
         }
      '')
    ];

  postPatch = ''
    substituteInPlace "src/Makefile.global.in" --subst-var out
    substituteInPlace "src/common/config_info.c" --subst-var dev
    substituteInPlace "src/backend/commands/collationcmds.c" \
      --replace-fail '"locale -a"' '"${lib.getBin stdenv.cc.libc}/bin/locale -a"'
  '';

  installTargets = [ "install-world" ];

  postInstall = ''
    moveToOutput "bin/ecpg" "$dev"
    moveToOutput "bin/pg_config" "$dev"
    moveToOutput "lib/pgxs" "$dev"

    # Remove static libraries when shared versions exist
    for i in $lib/lib/*.a; do
      name="$(basename "$i")"
      ext="${stdenv.hostPlatform.extensions.sharedLibrary}"
      if [ -e "$lib/lib/''${name%.a}$ext" ] || [ -e "''${i%.a}$ext" ]; then
        rm "$i"
      fi
    done

    # Move remaining static libraries to dev output
    moveToOutput "lib/*.a" "$dev"

    # Remove references to dev/doc/man from the postgres binary to avoid cycles
    remove-references-to -t "$dev" -t "$doc" -t "$man" "$out/bin/postgres"
  '';

  postFixup = lib.optionalString stdenv.hostPlatform.isGnu ''
    wrapProgram $out/bin/initdb --prefix PATH ":" ${glibc.bin}/bin
  '';

  doCheck = false;
  doInstallCheck = false;

  passthru = {
    psqlSchema = lib.versions.major finalAttrs.version;
  };

  meta = {
    homepage = "https://www.postgresql.org";
    description = "Powerful, open source object-relational database system";
    license = lib.licenses.postgresql;
    changelog = "https://www.postgresql.org/docs/release/${finalAttrs.version}/";
    mainProgram = "psql";
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
