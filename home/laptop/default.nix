{ pkgs, ...}:
{
  home.packages = with pkgs; [
    buildah            # builds OCI containers
    docker             # runs OCI containers
    docker-compose     # start collections of docker containers
    git-secret         # allows to encrypt individual files for storage
    gnupg
  ];

  programs.git = {
    enable = true;
    userName = "Simon Pettersson";
    userEmail = "simon.v.pettersson@gmail.com";
  };

  programs.bash = {
    bashrcExtra = ''
      export PATH=$HOME/.local/bin:$PATH
    '';
  };

  programs.termite = {
    enable = true;
  };

  programs.rofi = {
    enable = true;
    theme = "c64";
    terminal = "$HOME/.local/bin/terminal";
  };

#   programs.firefox.profiles = {
#     home = {
#       name = "home";
#       isDefault = true;
#     };
#   };

  home.file.".local/bin/statusbar/battery".source = ./bin/battery;
  home.file.".local/bin/statusbar/wifi".source = ./bin/wifi;
  home.file.".config/i3blocks/config".source = ./cfg/i3blocks;
  home.file.".local/bin/terminal".source = ./bin/terminal;
  home.file.".local/bin/launcher".source = ./bin/launcher;
}
