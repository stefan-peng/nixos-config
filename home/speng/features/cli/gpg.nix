{ pkgs, config, lib, ... }:
let
  fetchKey = { url, sha256 ? lib.fakeSha256 }:
    builtins.fetchurl { inherit sha256 url; };

  pinentry =
    if config.gtk.enable then {
      package = pkgs.pinentry-gnome;
      name = "gnome3";
    } else {
      package = pkgs.pinentry-curses;
      name = "curses";
    };
in
{
  home.packages = [ pinentry.package ];

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    sshKeys = [ "149F16412997785363112F3DBD713BC91D51B831" ];
    pinentryFlavor = pinentry.name;
    enableExtraSocket = true;
  };

  programs =
    let
      fixGpg = ''
        gpgconf --launch gpg-agent
      ''; in
    {
      # Start gpg-agent if it's not running or tunneled in
      # SSH does not start it automatically, so this is needed to avoid having to use a gpg command at startup
      # https://www.gnupg.org/faq/whats-new-in-2.1.html#autostart
      bash.profileExtra = fixGpg;
      fish.loginShellInit = fixGpg;
      zsh.loginExtra = fixGpg;

      gpg = {
        enable = true;
        settings = {
          trust-model = "tofu+pgp";
        };
        publicKeys = [
          {
            source = fetchKey {
              url = "https://m7.rs/7088C7421873E0DB97FF17C2245CAB70B4C225E9.asc";
              sha256 = "sha256:00r9mw8z38l2i50wc4la8xbmkx9cv5hxkhy01l07g93rvpxy3vbz";
            };
            trust = 5;
          }
          {
            source = fetchKey {
              url = "https://guip.dev/43827E2886E5C34F38D577538C814D625FBD99D1.asc";
              sha256 = "sha256:1r5lxq4xrqjz8c16l6yh10ablgqrqssgsgshpfaphnfqp6hhvvjd";
            };
            trust = 4;
          }
        ];
      };
    };

  # Link /run/user/$UID/gnupg to ~/.gnupg-sockets
  # So that SSH config does not have to know the UID
  systemd.user.services.link-gnupg-sockets = {
    Unit = {
      Description = "link gnupg sockets from /run to /home";
    };
    Service = {
      Type = "oneshot";
      ExecStart = "${pkgs.coreutils}/bin/ln -Tfs /run/user/%U/gnupg %h/.gnupg-sockets";
      ExecStop = "${pkgs.coreutils}/bin/rm $HOME/.gnupg-sockets";
      RemainAfterExit = true;
    };
    Install.WantedBy = [ "default.target" ];
  };
}
# vim: filetype=nix
