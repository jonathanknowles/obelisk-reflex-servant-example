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
      rev    = "ec8723351c8245f29a88cc5e6250533d2d6f4761";
      sha256 = "1r8z95hpl6f5pql1f6a3plczahym09fdnxkcg3a6ildw6chmips0";
    };
  };

  overrides = self: super: with pkgs.haskell.lib; {
    servant-reflex = doJailbreak super.servant-reflex;
  };

})
