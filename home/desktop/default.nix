{ pkgs, ...}:
{
  home.packages = with pkgs; [
    buildah            # builds OCI containers
    docker             # runs OCI containers
    docker-compose     # start collections of docker containers
    gnupg              # encryption
    minikube           # run kuberenetes locally
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

  home.file.".config/i3blocks/config".source = ./cfg/i3blocks;
  home.file.".local/bin/terminal".source = ./bin/terminal;
  home.file.".local/bin/launcher".source = ./bin/launcher;
}
