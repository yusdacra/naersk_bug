{ release ? true
, common
,
}:
with common;
let
  meta = with pkgs.stdenv.lib; {
    description = "Description for mre_naersk";
    longDescription = ''Long description for mre_naersk.'';
    homepage = "https://github.com/<owner>/mre_naersk";
    license = licenses.mit;
  };



  package = with pkgs; naersk.buildPackage {
    root = ../.;
    nativeBuildInputs = crateDeps.nativeBuildInputs;
    buildInputs = crateDeps.buildInputs;
    overrideMain = (prev: rec {
      inherit meta;

    });
    inherit release;
  };
in
package
