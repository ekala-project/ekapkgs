{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  cmake,
  gettext,
  libuv,
  luajit,
  msgpack-c,
  pkg-config,
  tree-sitter,
  unibilium,
  utf8proc,
  libvterm-neovim,
  wasmSupport ? false,
}:

let
  treesitter-parsers = import ./treesitter-parsers.nix { inherit fetchurl; };

  # Build lpeg from source as a static library for neovim
  lpeg = stdenv.mkDerivation {
    pname = "lpeg";
    version = "1.1.0";

    src = fetchurl {
      url = "https://github.com/neovim/deps/raw/d495ee6f79e7962a53ad79670cb92488abe0b9b4/opt/lpeg-1.1.0.tar.gz";
      hash = "sha256-SxVdZ9IkbB/6ete8RmweqJm7xA/vAlfMnAPOy67UNSo=";
    };

    nativeBuildInputs = [ cmake ];

    dontUseCmakeConfigure = true;

    buildPhase = ''
      runHook preBuild
      for f in lpcap.c lpcode.c lpcset.c lpprint.c lptree.c lpvm.c; do
        cc -fPIC -O2 -w -I${luajit}/include/luajit-2.1 -c "$f"
      done
      ar rcs liblpeg_a.a lpcap.o lpcode.o lpcset.o lpprint.o lptree.o lpvm.o
      cc -shared -o lpeg.so lpcap.o lpcode.o lpcset.o lpprint.o lptree.o lpvm.o
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      mkdir -p $out/lib
      cp liblpeg_a.a $out/lib/
      cp lpeg.so $out/lib/
      runHook postInstall
    '';
  };

  # Build libluv (lua bindings for libuv) from source
  lua-compat-53 = fetchurl {
    url = "https://github.com/lunarmodules/lua-compat-5.3/archive/v0.13.tar.gz";
    hash = "sha256-9dww57H9qFbuTTkr5FdkLB8MJZJkqbm/vLaAMCzoj8I=";
  };

  libluv = stdenv.mkDerivation {
    pname = "libluv";
    version = "1.52.1-0";

    src = fetchurl {
      url = "https://github.com/luvit/luv/archive/1.52.1-0.tar.gz";
      hash = "sha256-6Lh3SzHSS+T88rAhuQWZ7MzI5HbGHvzFnDwQyrgTqIU=";
    };

    nativeBuildInputs = [
      cmake
      cmake.configurePhaseHook
      pkg-config
    ];

    buildInputs = [
      luajit
      libuv
    ];

    postUnpack = ''
      mkdir -p $sourceRoot/deps/lua-compat-5.3
      tar -xzf ${lua-compat-53} -C $sourceRoot/deps/lua-compat-5.3 --strip-components=1
    '';

    cmakeFlags = [
      (lib.cmakeFeature "LUA_BUILD_TYPE" "System")
      (lib.cmakeFeature "LUA_COMPAT53_DIR" "deps/lua-compat-5.3")
      (lib.cmakeBool "WITH_SHARED_LIBUV" true)
      (lib.cmakeBool "BUILD_STATIC_LIBS" true)
      (lib.cmakeBool "BUILD_MODULE" false)
      (lib.cmakeFeature "WITH_LUA_ENGINE" "LuaJit")
    ];
  };

  # Build a single treesitter parser grammar
  buildGrammar =
    {
      language,
      src,
      location ? null,
    }:
    stdenv.mkDerivation {
      pname = "tree-sitter-${language}";
      version = "neovim-0.12.4";
      inherit src;

      dontConfigure = true;

      env.CFLAGS = "-Isrc -O2";

      setSourceRoot = lib.optionalString (location != null) "sourceRoot=$(echo */${location})";

      buildPhase = ''
        runHook preBuild
        if [[ -e src/scanner.cc ]]; then
          c++ -fPIC -c src/scanner.cc -o scanner.o $CXXFLAGS
        elif [[ -e src/scanner.c ]]; then
          cc -fPIC -c src/scanner.c -o scanner.o $CFLAGS
        fi
        cc -fPIC -c src/parser.c -o parser.o $CFLAGS
        c++ -shared -o parser *.o
        runHook postBuild
      '';

      installPhase = ''
        runHook preInstall
        mkdir -p $out
        mv parser $out/
        runHook postInstall
      '';
    };

  builtParsers =
    lib.mapAttrs
      (
        language: grammar:
        buildGrammar {
          inherit (grammar) src;
          language = grammar.language or language;
          location = grammar.location or null;
        }
      )
      (
        treesitter-parsers
        // {
          markdown = treesitter-parsers.markdown // {
            location = "tree-sitter-markdown";
          };
        }
        // {
          markdown_inline = treesitter-parsers.markdown // {
            language = "markdown_inline";
            location = "tree-sitter-markdown-inline";
          };
        }
      );

in

stdenv.mkDerivation (finalAttrs: {
  pname = "neovim-unwrapped";
  version = "0.12.5";

  src = fetchFromGitHub {
    owner = "neovim";
    repo = "neovim";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dpu2kncpm+2k+XR7qOEi4KeEy9a1E6X7kjf3s4AbcSo=";
  };

  strictDeps = true;

  patches = [
    # introduce a system-wide rplugin.vim in addition to the user one
    ./system_rplugin_manifest.patch
  ];

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    gettext
    pkg-config
  ];

  buildInputs = [
    libuv
    libluv
    lpeg
    luajit
    tree-sitter
    unibilium
    utf8proc
    libvterm-neovim
  ];

  cmakeFlags = [
    (lib.cmakeBool "USE_BUNDLED" false)
    (lib.cmakeBool "ENABLE_TRANSLATIONS" true)
    (lib.cmakeFeature "LUAC_PRG" "${luajit}/bin/luajit -b -s %s -")
    (lib.cmakeFeature "LUA_GEN_PRG" "${luajit}/bin/luajit")
    (lib.cmakeFeature "LUA_PRG" "${luajit}/bin/luajit")
  ];

  doCheck = false;

  preConfigure = ''
    mkdir -p $out/lib/nvim/parser
  ''
  + lib.concatStrings (
    lib.mapAttrsToList (language: grammar: ''
      ln -sf \
        ${grammar}/parser \
        $out/lib/nvim/parser/${language}.so
    '') builtParsers
  );

  separateDebugInfo = true;

  meta = {
    description = "Vim text editor fork focused on extensibility and agility";
    longDescription = ''
      Neovim is a project that seeks to aggressively refactor Vim in order to:
      - Simplify maintenance and encourage contributions
      - Split the work between multiple developers
      - Enable the implementation of new/modern user interfaces without any
        modifications to the core source
      - Improve extensibility with a new plugin architecture
    '';
    homepage = "https://neovim.io";
    mainProgram = "nvim";
    license = with lib.licenses; [
      asl20
      vim
    ];
    platforms = lib.platforms.unix;
  };
})
