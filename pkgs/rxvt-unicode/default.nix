{
  symlinkJoin,
  makeWrapper,
  lib,
  rxvt-unicode-unwrapped,
  perlPackages,
  configure ?
    { ... }:
    {
      plugins = [ ];
      extraDeps = [ ];
      perlDeps = [ ];
    },
}:

let
  # Transform the string "self" to the plugin itself.
  # It's needed for plugins like bidi who depends on the perl
  # package they provide themself.
  mkPerlDeps =
    p:
    let
      deps = p.perlPackages or [ ];
    in
    map (x: if x == "self" then p else x) deps;

  # The wrapper is called with a `configure` function
  # that takes the urxvt plugins as input and produce
  # the configuration of the wrapper: list of plugins,
  # extra dependencies and perl dependencies.
  # This provides simple way to customize urxvt using
  # the `.override` mechanism.
  wrapper =
    { configure, ... }:
    let
      config = configure { };
      plugins = config.plugins or [ ];
      extraDeps = config.extraDeps or [ ];
      perlDeps = (config.perlDeps or [ ]) ++ lib.concatMap mkPerlDeps plugins;
    in
    symlinkJoin {
      pname = "rxvt-unicode";

      paths = [ rxvt-unicode-unwrapped ] ++ plugins ++ extraDeps;

      nativeBuildInputs = [ makeWrapper ];

      postBuild = ''
        wrapProgram $out/bin/urxvt \
          --prefix PERL5LIB : "${perlPackages.makePerlPath perlDeps}" \
          --suffix-each URXVT_PERL_LIB ':' "$out/lib/urxvt/perl"
        wrapProgram $out/bin/urxvtd \
          --prefix PERL5LIB : "${perlPackages.makePerlPath perlDeps}" \
          --suffix-each URXVT_PERL_LIB ':' "$out/lib/urxvt/perl"
      '';

      inherit (rxvt-unicode-unwrapped) meta version;
    };

in
lib.makeOverridable wrapper { inherit configure; }
