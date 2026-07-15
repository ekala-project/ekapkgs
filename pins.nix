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
    rev = "7f4e2ddd8922722f92f9f13a7eba3e36d2cc0387";
    sha256 = "0wk2h2q20gcgrwg2qhqlxbqmiqdcg84xv3dsrgjkl51wx8svh9ag";
  };
  python = fetch {
    repo = "python-pkgs";
    rev = "f3bccf526c2cbc38f4d6af565417889fb6e0edaa";
    sha256 = "1zq0bc4598y6qjf4m5jmmanisyg9ns745vyq8ycjfb97hhcqh8cw";
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
  lib = fetch {
    repo = "nix-lib";
    rev = "9acd37c8934331a3e53a099f8755101bc2a149e2";
    sha256 = "0jjxajx05kqvbg8i6iyx8plw4kn72n349qk652rnj309gwc6w1b9";
  };
}
