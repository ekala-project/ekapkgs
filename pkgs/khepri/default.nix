{
  lib,
  beamPackages,
  fetchFromGitHub,
  erlang,
}:

let
  inherit (beamPackages)
    buildRebar3
    fetchHex
    ;

  # Hex dependencies (translated from Khepri's rebar.lock via rebar3_nix).
  aten = buildRebar3 {
    name = "aten";
    version = "0.6.0";
    src = fetchHex {
      pkg = "aten";
      version = "0.6.0";
      sha256 = "sha256-XzmhZCBq4/IR71iAsfeBlBVoZDbjIp0wtqBYVk+6oWg=";
    };
    beamDeps = [ ];
  };

  seshat = buildRebar3 {
    name = "seshat";
    version = "1.0.1";
    src = fetchHex {
      pkg = "seshat";
      version = "1.0.1";
      sha256 = "sha256-ODJP6MV4LGnXOzNN0Asg4WwNme7z57QAXFGf6bwONPw=";
    };
    beamDeps = [ ];
  };

  gen_batch_server = buildRebar3 {
    name = "gen_batch_server";
    version = "0.10.0";
    src = fetchHex {
      pkg = "gen_batch_server";
      version = "0.10.0";
      sha256 = "sha256-OR4uY0q+wA+SKfdmvP9zbgfMZlMEld/UoWRyTsr3AI8=";
    };
    beamDeps = [ ];
  };

  ra = buildRebar3 {
    name = "ra";
    version = "3.2.0";
    src = fetchHex {
      pkg = "ra";
      version = "3.2.0";
      sha256 = "sha256-hUK3GvL61rTpK5jCCSvuu25R4cranVHW1Lsc3KPbzQY=";
    };
    beamDeps = [
      aten
      gen_batch_server
      seshat
    ];
  };

  horus = buildRebar3 {
    name = "horus";
    version = "0.5.1";
    src = fetchHex {
      pkg = "horus";
      version = "0.5.1";
      sha256 = "sha256-oZyJ0lgHlv841LqaR6Pb4Og+BGSBSypiH9gRTBB36Kc=";
    };
    beamDeps = [ ];
  };
in
buildRebar3 (finalAttrs: {
  pname = "khepri";
  name = "khepri";
  version = "0.19.3";

  src = fetchFromGitHub {
    owner = "rabbitmq";
    repo = "khepri";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-Wu/yuQXfX0gsFJ6SoavF+AbW4Elw5gRto5WxzjRWxUI=";
  };

  beamDeps = [
    horus
    ra
  ];

  meta = {
    description = "Tree-like replicated on-disk database library for Erlang and Elixir";
    homepage = "https://github.com/rabbitmq/khepri";
    changelog = "https://github.com/rabbitmq/khepri/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    platforms = erlang.meta.platforms;
  };
})
