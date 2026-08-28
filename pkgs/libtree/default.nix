{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libtree";
  version = "3.1.1";

  src = fetchFromGitHub {
    owner = "haampie";
    repo = "libtree";
    rev = "v${finalAttrs.version}";
    hash = "sha256-q3JtQ9AxoP0ma9K96cC3gf6QmQ1FbS7T7I59qhkwbMk=";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  doCheck = false;

  meta = {
    description = "Tree ldd with an option to bundle dependencies into a single folder";
    mainProgram = "libtree";
    homepage = "https://github.com/haampie/libtree";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
  };
})
