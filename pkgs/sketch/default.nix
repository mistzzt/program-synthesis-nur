{
  fetchurl,
  lib,
  makeWrapper,
  stdenv,
  bison,
  flex,
  jdk,
  which,
  coreutils,
}:
stdenv.mkDerivation rec {
  name = "sketch-${version}";
  version = "1.7.6";
  src = fetchurl {
    url = "https://people.csail.mit.edu/asolar/sketch-1.7.6.tar.gz";
    sha256 = "5cdac9ce841fd532215ff9ad8cb61a38cbdf6de0a635a669d0e46cdae72da707";
  };

  nativeBuildInputs = [flex bison makeWrapper];
  buildInputs = [jdk which coreutils];

  configurePhase = "cd sketch-backend && chmod +x ./configure && ./configure";
  installPhase = ''
    mkdir -p $out
    cp -r ../sketch-backend $out
    cp -r ../sketch-frontend $out

    makeWrapper $out/sketch-frontend/sketch $out/bin/sketch \
      --argv0 "sketch" \
      --chdir $out/sketch-frontend \
      --add-flags "--fe-inc=$out/sketch-frontend/sketchlib" \
      --set SKETCH_HOME $out/sketch-frontend/runtime
  '';

  meta = with lib; {
    description = "The sketch program synthesis tool";
    homepage = "https://github.com/asolarlez/sketch-backend";
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
