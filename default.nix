{ system ? builtins.currentSystem # TODO: Get rid of this system cruft
, iosSdkVersion ? "10.2"
}:
with import ./.obelisk/impl { inherit system iosSdkVersion; };
project ./. ({ pkgs, ... }: {
  android.applicationId = "systems.obsidian.obelisk.examples.minimal";
  android.displayName = "Obelisk Minimal Example";
  ios.bundleIdentifier = "systems.obsidian.obelisk.examples.minimal";
  ios.bundleName = "Obelisk Minimal Example";

  packages = {
    servant-reflex = pkgs.fetchFromGitHub {
      owner  = "imalsogreg";
      repo   = "servant-reflex";
      rev    = "7e6a372939b4218c1d76a641dded8d85126346fd";
      sha256 = "1a8xpndhh545ascw6ydrkpgs70iwmjpw2iqvl4qmcyw11g3nbizb";
    };
    servant-snap = pkgs.fetchFromGitHub {
      owner  = "haskell-servant";
      repo   = "servant-snap";
      rev    = "af5172a6de5bb2a07eb1bf4c85952075ec6ecdf3";
      sha256 = "0973iq3gc36qhiqnf5vp5djqsrz70srw1r7g73v8wamw04dx0g3z";
    };
  };

  overrides = self: super: with pkgs.haskell.lib; {
    servant-reflex = doJailbreak super.servant-reflex;
    hspec-snap     = dontCheck (self.callHackage "hspec-snap" "1.0.1.0" { });
  };
  shellToolOverrides = ghc: super: {
    ghcide = pkgs.haskell.lib.dontCheck ((ghc.override {
      overrides = ghc: super: {
        lsp-test =
          pkgs.haskell.lib.dontCheck (ghc.callHackage "lsp-test" "0.6.1.0" { });
          haddock-library = pkgs.haskell.lib.dontCheck
          (ghc.callHackage "haddock-library" "1.8.0" { });
          haskell-lsp = pkgs.haskell.lib.dontCheck
          (ghc.callHackage "haskell-lsp" "0.19.0.0" { });
          haskell-lsp-types = pkgs.haskell.lib.dontCheck
          (ghc.callHackage "haskell-lsp-types" "0.19.0.0" { });
          regex-posix = pkgs.haskell.lib.dontCheck
          (ghc.callHackage "regex-posix" "0.96.0.0" { });
          test-framework = pkgs.haskell.lib.dontCheck
          (ghc.callHackage "test-framework" "0.8.2.0" { });
          regex-base = pkgs.haskell.lib.dontCheck
          (ghc.callHackage "regex-base" "0.94.0.0" { });
          regex-tdfa = pkgs.haskell.lib.dontCheck
          (ghc.callHackage "regex-tdfa" "1.3.1.0" { });
          shake =
            pkgs.haskell.lib.dontCheck (ghc.callHackage "shake" "0.18.4" { });
            hie-bios = pkgs.haskell.lib.dontCheck (ghc.callHackageDirect {
              pkg = "hie-bios";
              ver = "0.4.0";
              sha256 = "19lpg9ymd9656cy17vna8wr1hvzfal94gpm2d3xpnw1d5qr37z7x";
            } { });
      };
    }).callCabal2nix "ghcide" (pkgs.fetchFromGitHub {
      owner = "digital-asset";
      repo = "ghcide";
      rev = "v0.1.0";
      sha256 = "1kf71iix46hvyxviimrcv7kvsj67hcnnqlpdsmazmlmybf7wbqbb";
    }) { });
  };
})
