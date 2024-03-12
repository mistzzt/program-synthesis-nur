{
  fetchurl,
  lib,
  makeWrapper,
  stdenv,
  autoconf,
  automake,
  libtool,
  ncurses,
  libz,
  bzip2,
  libiconv,
  which,
  darwin,
}:
stdenv.mkDerivation {
  name = "reduce-algebra";
  version = "r6658";
  src = fetchurl {
    url = "https://sourceforge.net/projects/reduce-algebra/files/snapshot_2023-12-18/Reduce-svn6658-src.tar.gz";
    sha1 = "b5c7d4b5c09b546a1b0576368aa702b40eef8568";
  };
  patches = [./configure.patch];

  nativeBuildInputs =
    [
      autoconf
      automake
      libtool
      ncurses
      libz
      bzip2
      libiconv
      which
    ]
    ++ lib.optionals stdenv.isDarwin [
      darwin.apple_sdk.frameworks.Carbon
      darwin.stubs.rez
    ];

  configureFlags = ["--with-csl" "--without-gui"];
  dontDisableStatic = true;

  installPhase = ''
    mkdir -p $out/bin
    cp -r ./bin/redcsl $out/bin
    cp -r ./bin/reduce $out/bin
    cp -r ./cslbuild $out
    cp -r ./scripts $out
    cp ./config.guess $out
  '';
  
  dontFixup = true;
}
