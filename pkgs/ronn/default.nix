{
  lib,
  bundlerApp,
}:

bundlerApp {
  pname = "ronn-ng";
  gemdir = ./.;
  exes = [ "ronn" ];

  meta = {
    description = "Markdown-based tool for building manpages";
    mainProgram = "ronn";
    homepage = "https://github.com/apjanke/ronn-ng";
    license = lib.licenses.mit;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
}
