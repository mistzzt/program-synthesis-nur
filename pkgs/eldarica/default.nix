{
  fetchFromGitHub,
  lib,
  makeWrapper,
  stdenv,
  which,
  coreutils,
  sbt,
  jdk8_headless,
}:
stdenv.mkDerivation rec {
  name = "eldarica-${version}";
  version = "2.2";
  src =
    fetchFromGitHub
    {
      owner = "uuverifiers";
      repo = "eldarica";
      rev = "v${version}";
      sha256 = "cQW1B5wTnlxEv9SczQXCIDQlxXl3Ixs68nUveyuXNYM=";
    };

  buildInputs = [sbt jdk8_headless makeWrapper];

  buildPhase = "sbt assembly";

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/share/java

    cp target/scala-2.13/*.jar $out/share/java

    ls -la .
    ls -la target/scala-2.*/
    exit 1

    makeWrapper ${jdk8_headless}/bin/java $out/bin/nix-scala-example \
      --add-flags "-cp \"$out/share/java/*\" com.example.nixscalaexample.Main"
  '';

  meta = with lib; {
    description = "The Eldarica model checker ";
    homepage = "https://github.com/uuverifiers/eldarica";
    license = licenses.bsd3;
    platforms = platforms.unix;
  };
}
