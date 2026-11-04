{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  java,
  java-hamcrest,
  stripJavaArchivesHook,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "junit";
  version = "4.13.2";

  src = fetchFromGitHub {
    owner = "junit-team";
    repo = "junit4";
    tag = "r${finalAttrs.version}";
    hash = "sha256-A6ZbmsECwP/hYqmIoU3rDvEX3V9Dx3FtCgAxpv8n8+Q=";
  };

  nativeBuildInputs = [
    java
    stripJavaArchivesHook
  ];

  propagatedBuildInputs = [ java-hamcrest ];

  patches = [
    ./0001-fix-everyItem-return-type-cast-for-hamcrest-2.patch
    ./0002-remove-hamcrest-factory-decorators.diff
  ];

  postPatch = ''
    # Generate Version.java from the template (Maven normally does this)
    # The committed Version.java has a stale "4.13.2-SNAPSHOT" string
    mv src/main/java/junit/runner/Version.java.template \
       src/main/java/junit/runner/Version.java
    substituteInPlace src/main/java/junit/runner/Version.java \
      --replace-fail '@version@' '${finalAttrs.version}'
  '';

  buildPhase = ''
    runHook preBuild

    mkdir -p build/classes

    find src/main/java -name "*.java" > sources.txt

    javac \
      --release 8 \
      -classpath "$(find ${java-hamcrest}/share/java -name '*.jar' | tr '\n' ':')" \
      -encoding ISO-8859-1 \
      -d build/classes \
      @sources.txt

    cp -r src/main/resources/. build/classes/ 2>/dev/null || true

    jar cf junit-${finalAttrs.version}.jar -C build/classes .

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm644 junit-${finalAttrs.version}.jar $out/share/java/junit-${finalAttrs.version}.jar

    runHook postInstall
  '';

  strictDeps = true;

  meta = {
    description = "JUnit 4 testing framework for Java";
    homepage = "https://junit.org/junit4/";
    license = lib.licenses.epl10;
    platforms = lib.platforms.all;
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
    broken = true; # java-hamcrest build is broken (gradle bnd plugin resolution)
  };
})
