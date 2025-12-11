{ pkgs, ... }:

{
  packages = [
    pkgs.python3
    pkgs.python3Packages.diff-match-patch
    pkgs.curl
    pkgs.entr
    pkgs.gnumake
    pkgs.pandoc
    pkgs.texlive.combined.scheme-small
    pkgs.texlivePackages.latexdiff
    pkgs.poppler-utils
    pkgs.diffutils
  ];

  enterShell = ''
    echo "Entering development environment..."
  '';
}
