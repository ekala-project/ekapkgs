{
  stdenv,
  lib,
  fetchurl,
  fetchhg,
  libidn,
  openssl,
  makeWrapper,
  buildPackages,
  icu,
  lua,
  withDBI ? true,
  # use withExtraLibs to add additional dependencies of community modules
  withExtraLibs ? [ ],
  withExtraLuaPackages ? _: [ ],
  withOnlyInstalledCommunityModules ? [ ],
  withCommunityModules ? [ ],
}:

let
  luaInterp = lua.v5_2_compat;
  luaEnv = luaInterp.withPackages (
    p:
    (lib.filter (x: x != null) [
      (p.luasocket or null)
      (p.luasec or null)
      (p.luaexpat or null)
      (p.luafilesystem or null)
      (p.luabitop or null)
      (p.luadbi-sqlite3 or null)
      (p.luaunbound or null)
    ])
    ++ lib.optional (withDBI && (p ? luadbi)) p.luadbi
    ++ withExtraLuaPackages p
  );
in
stdenv.mkDerivation (finalAttrs: {
  pname = "prosody";
  version = "13.0.6";

  src = fetchurl {
    url = "https://prosody.im/downloads/source/prosody-${finalAttrs.version}.tar.gz";
    hash = "sha256-7GlvnPViw69KBLB9P7NqHO3MTmmjkv3c/FJLxn2TBQ8=";
  };

  # The following community modules are necessary for the nixos module
  # prosody module to comply with XEP-0423 and provide a working
  # default setup.
  nixosModuleDeps = [
    "cloud_notify"
  ];

  communityModules = fetchhg {
    url = "https://hg.prosody.im/prosody-modules";
    rev = "15a7749c7acb";
    hash = "sha256-RvhPV6YMdwxxIeHhpqXPfBh6087PAPAQV8D+stpXmBs=";
  };

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [
    luaEnv
    libidn
    openssl
    icu
  ]
  ++ withExtraLibs;

  configureFlags = [
    "--ostype=linux"
    "--with-lua-bin=${lib.getBin buildPackages.lua.v5_2_compat}/bin"
    "--with-lua-include=${luaEnv}/include"
    "--with-lua=${luaEnv}"
    "--c-compiler=${stdenv.cc.targetPrefix}cc"
    "--linker=${stdenv.cc.targetPrefix}cc"
  ];

  configurePlatforms = [ ];

  postBuild = ''
    make -C tools/migration
  '';

  buildFlags = [
    # don't search for configs in the nix store when running prosodyctl
    "INSTALLEDCONFIG=/etc/prosody"
    "INSTALLEDDATA=/var/lib/prosody"
  ];

  # the wrapping should go away once lua hook is fixed
  postInstall = ''
    ${lib.concatMapStringsSep "\n"
      (module: ''
        cp -r ${finalAttrs.communityModules}/mod_${module} $out/lib/prosody/modules/
      '')
      (
        lib.lists.unique (
          finalAttrs.nixosModuleDeps ++ withCommunityModules ++ withOnlyInstalledCommunityModules
        )
      )
    }
    make -C tools/migration install
  '';

  passthru = {
    communityModules = withCommunityModules;
    # TODO(ekaos): replace with integrationTests
    # tests = { inherit (nixosTests) prosody prosody-mysql; };
  };

  meta = {
    description = "Open-source XMPP application server written in Lua";
    license = lib.licenses.mit;
    changelog = "https://prosody.im/doc/release/${finalAttrs.version}";
    homepage = "https://prosody.im";
    platforms = lib.platforms.linux;
    mainProgram = "prosody";
  };
})
