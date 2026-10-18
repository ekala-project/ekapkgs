{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  cmake,
  gettext,
  jq,
  libuv,
  luajit,
  lpeg,
  libluv,
  pkg-config,
  unibilium,
  utf8proc,
  tree-sitter,
}:

let
  treesitter-parsers = {
    c.src = fetchurl {
      url = "https://github.com/tree-sitter/tree-sitter-c/archive/v0.24.1.tar.gz";
      hash = "sha256:25dd4bb3dec770769a407e0fc803f424ce02c494a56ce95fedc525316dcf9b48";
    };
    lua.src = fetchurl {
      url = "https://github.com/tree-sitter-grammars/tree-sitter-lua/archive/v0.5.0.tar.gz";
      hash = "sha256:cf01b93f4b61b96a6d27942cf28eeda4cbce7d503c3bef773a8930b3d778a2d9";
    };
    vim.src = fetchurl {
      url = "https://github.com/tree-sitter-grammars/tree-sitter-vim/archive/v0.8.1.tar.gz";
      hash = "sha256:93cafb9a0269420362454ace725a118ff1c3e08dcdfdc228aa86334b54d53c2a";
    };
    vimdoc.src = fetchurl {
      url = "https://github.com/neovim/tree-sitter-vimdoc/archive/v4.1.0.tar.gz";
      hash = "sha256:020e8f117f648c8697fca967995c342e92dbd81dab137a115cc7555207fbc84f";
    };
    query.src = fetchurl {
      url = "https://github.com/tree-sitter-grammars/tree-sitter-query/archive/v0.8.0.tar.gz";
      hash = "sha256:c2b23b9a54cffcc999ded4a5d3949daf338bebb7945dece229f832332e6e6a7d";
    };
    markdown.src = fetchurl {
      url = "https://github.com/tree-sitter-grammars/tree-sitter-markdown/archive/v0.5.3.tar.gz";
      hash = "sha256:df845b1ab7c7c163ec57d7fa17170c92b04be199bddab02523636efec5224ab6";
    };
  };

  # Build a single treesitter parser grammar into a shared library
  buildGrammar =
    {
      language,
      src,
      location ? null,
    }:
    stdenv.mkDerivation {
      pname = "tree-sitter-${language}";
      version = "neovim-0.12.5";
      inherit src;

      __structuredAttrs = true;

      nativeBuildInputs = [ jq ];

      env = {
        CFLAGS = "-Isrc -O2";
        CXXFLAGS = "-Isrc -O2";
        inherit language;
      };

      ${if location != null then "setSourceRoot" else null} = "sourceRoot=$(echo */${location})";

      configurePhase = ''
        runHook preConfigure
        if [[ -e tree-sitter.json ]]; then
          GRAMMAR=$(jq -c 'first(.grammars[] | select(.name == env.language))' tree-sitter.json)
          if [[ -z "$GRAMMAR" ]]; then
            GRAMMAR=$(jq -c 'first(.grammars[]) // {}' tree-sitter.json)
          fi
          cd -- $(jq -r '.path // "."' <<< $GRAMMAR)
        fi
        runHook postConfigure
      '';

      buildPhase = ''
        runHook preBuild
        if [[ -e src/scanner.cc ]]; then
          $CXX -fPIC -c src/scanner.cc -o scanner.o $CXXFLAGS
        elif [[ -e src/scanner.c ]]; then
          $CC -fPIC -c src/scanner.c -o scanner.o $CFLAGS
        fi
        $CC -fPIC -c src/parser.c -o parser.o $CFLAGS
        rm -rf parser
        $CXX -shared -o parser *.o
        runHook postBuild
      '';

      installPhase = ''
        runHook preInstall
        mkdir -p $out
        mv parser $out/
        if [[ -d queries ]]; then
          cp -r queries $out
        fi
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

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "neovim";
    repo = "neovim";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dpu2kncpm+2k+XR7qOEi4KeEy9a1E6X7kjf3s4AbcSo=";
  };

  strictDeps = true;

  patches = [
    # Introduce a system-wide rplugin.vim in addition to the user one.
    # Necessary so that nix can handle UpdateRemotePlugins for plugins
    # it installs. See https://github.com/neovim/neovim/issues/9413.
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
  ];

  doCheck = false;

  cmakeFlags = [
    (lib.cmakeBool "USE_BUNDLED" false)
    (lib.cmakeBool "ENABLE_TRANSLATIONS" true)
    (lib.cmakeBool "USE_BUNDLED_BUSTED" false)
    (lib.cmakeFeature "LUAC_PRG" "${lib.getExe' luajit "luajit"} -b -s %s -")
    (lib.cmakeFeature "LUA_GEN_PRG" (lib.getExe' luajit "luajit"))
    (lib.cmakeFeature "LUA_PRG" (lib.getExe' luajit "luajit"))
  ];

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

  disallowedRequisites = [
    stdenv.cc
  ];

  separateDebugInfo = true;

  doInstallCheck = false;

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
    changelog = "https://github.com/neovim/neovim/releases/tag/v${finalAttrs.version}";
    mainProgram = "nvim";
    license = with lib.licenses; [
      asl20
      vim
    ];
    platforms = lib.platforms.unix;
  };
})
