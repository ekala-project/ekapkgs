let
  fetch = { repo, rev, sha256 }:
    builtins.fetchTarball {
      url = "https://github.com/ekala-project/${repo}/archive/${rev}.tar.gz";
      inherit sha256;
    };
in
{
  core = fetch {
    repo = "corepkgs";
    rev = "a25062ad495fe06e37a28a87ec999ec708a7ec38";
    sha256 = "13whiafihmnbr6k03m3c64n98s9q9zssd878r3x3h38ck8m6v3g8";
  };
  python = fetch {
    repo = "python-pkgs";
    rev = "7db4a4905b3ebe0e708808e8b88ef119e659c556";
    sha256 = "17x8rf4wb0lgzzjzw89lsmxdqnq0yw6i1cwnnvs4mz4fa3l5y9hw";
  };
  haskell = fetch {
    repo = "haskell-pkgs";
    rev = "5843f018b71c70eda0f68c87b0df44438299ce53";
    sha256 = "0bwvidzlfda0ss0zig3bbpm7j4l5q1sb6k68zxvk17grrmiqq5sh";
  };
  node = fetch {
    repo = "node-packages";
    rev = "aa453253b6f2cb96c982a99f815162368f8ac74f";
    sha256 = "12sj1hxqy5sk1j4vsdc8d420hdnaldkdx6vn6df0qkmrqv76gffr";
  };
  lib = import (fetch {
    repo = "nix-lib";
    rev = "fd5cdc455e167022c720950fcc599c8a5ef618a1";
    sha256 = "17rhyn3icddg5rnslqv7wsx0bh8vd6njamdpcc447hpmqcphmv4m";
  });
}
