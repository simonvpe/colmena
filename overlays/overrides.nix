channels: final: prev: {

  __dontExport = true; # overrides clutter up actual creations

  inherit (channels.latest)
    brave
    cachix
    dhall
    discord
    element-desktop
    nixpkgs-fmt
    qutebrowser
    rage
    signal-desktop
    starship;

  haskellPackages = prev.haskellPackages.override
    (old: {
      overrides = prev.lib.composeExtensions (old.overrides or (_: _: { })) (hfinal: hprev:
        let version = prev.lib.replaceChars [ "." ] [ "" ] prev.ghc.version;
        in
        {
          # same for haskell packages, matching ghc versions
          inherit (channels.latest.haskell.packages."ghc${version}")
            haskell-language-server;
        });
    });

  vimPlugins = channels.latest.vimPlugins // {
    vim-merginal = channels.latest.vimPlugins.vim-merginal.overrideAttrs (orig: {
      src = final.fetchFromGitHub {
        owner = "idanarye";
        repo = "vim-merginal";
        rev = "ad992ac2549e8df96330ca915fe497b6efc5255e";
        sha256 = "sha256-hD0lpmhDAWPxWBxGjhJX0Y8WgzU/IBnTgHkLyFM5J9Q=";
      };
    });
  };
}
