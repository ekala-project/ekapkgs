{
  lib,
  stdenv,
  fetchurl,
  python3Packages,
  makeWrapper,
  gawk,
  bash,
  getopt,
  procps,
  which,
  java,
}:

let
  libPath = lib.makeLibraryPath [ stdenv.cc.cc ];
  binPath = lib.makeBinPath [
    bash
    getopt
    gawk
    which
    java.v11
    procps
  ];
in

stdenv.mkDerivation rec {
  pname = "cassandra";
  version = "4.1.8";

  src = fetchurl {
    url = "mirror://apache/cassandra/${version}/apache-cassandra-${version}-bin.tar.gz";
    hash = "sha256-jsMCNuHxTzPki3lYQ5QiRw+Y8JtVJ+8FyAfeQpf4lyE=";
  };

  pythonPath = with python3Packages; [ cassandra-driver ];

  nativeBuildInputs = [ python3Packages.wrapPython ];

  buildInputs = [ python3Packages.python ] ++ pythonPath;

  installPhase = ''
    runHook preInstall

    mkdir $out
    mv * $out

    # Clean up documentation.
    mkdir -p $out/share/doc/${pname}-${version}
    mv $out/CHANGES.txt \
       $out/LICENSE.txt \
       $out/NEWS.txt \
       $out/NOTICE.txt \
       $out/share/doc/${pname}-${version}

    if [[ -d $out/doc ]]; then
      mv "$out/doc/"* $out/share/doc/${pname}-${version}
      rmdir $out/doc
    fi


    for cmd in bin/cassandra \
               bin/nodetool \
               bin/sstablekeys \
               bin/sstableloader \
               bin/sstablescrub \
               bin/sstableupgrade \
               bin/sstableutil \
               bin/sstableverify; do
      # Check if file exists because some don't exist across all versions
      if [ -f $out/$cmd ]; then
        wrapProgram $out/bin/$(basename "$cmd") \
          --suffix-each LD_LIBRARY_PATH : ${libPath} \
          --prefix PATH : ${binPath} \
          --set JAVA_HOME ${java.v11}
      fi
    done

    for cmd in tools/bin/cassandra-stress \
               tools/bin/cassandra-stressd \
               tools/bin/sstabledump \
               tools/bin/sstableexpiredblockers \
               tools/bin/sstablelevelreset \
               tools/bin/sstablemetadata \
               tools/bin/sstableofflinerelevel \
               tools/bin/sstablerepairedset \
               tools/bin/sstablesplit \
               tools/bin/token-generator; do
      # Check if file exists because some don't exist across all versions
      if [ -f $out/$cmd ]; then
        makeWrapper $out/$cmd $out/bin/$(basename "$cmd") \
          --suffix-each LD_LIBRARY_PATH : ${libPath} \
          --prefix PATH : ${binPath} \
          --set JAVA_HOME ${java.v11}
      fi
    done

    runHook postInstall
  '';

  postFixup = ''
    # Remove cassandra bash script wrapper.
    # The wrapper searches for a suitable python version and is not necessary with Nix.
    rm $out/bin/cqlsh
    # Make "cqlsh.py" accessible by invoking "cqlsh"
    ln -s $out/bin/cqlsh.py $out/bin/cqlsh
    wrapPythonPrograms
  '';

  meta =

    {
      homepage = "https://cassandra.apache.org/";
      description = "Massively scalable open source NoSQL database";
      platforms = lib.platforms.unix;
      license = lib.licenses.asl20;
      sourceProvenance = with lib.sourceTypes; [
        binaryBytecode
        binaryNativeCode # bundled dependency libsigar
      ];
    };
}
