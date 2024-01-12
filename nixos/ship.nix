# Shipnix recommended settings
# IMPORTANT: These settings are here for ship-nix to function properly on your server
# Modify with care

{ config, pkgs, modulesPath, lib, ... }:
{
  nix = {
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes ca-derivations
    '';
    settings = {
      trusted-users = [ "root" "ship" "nix-ssh" ];
    };
  };

  programs.git.enable = true;
  programs.git.config = {
    advice.detachedHead = false;
  };

  services.openssh = {
    enable = true;
    # ship-nix uses SSH keys to gain access to the server
    # Manage permitted public keys in the `authorized_keys` file
    settings.PasswordAuthentication = false;
  };


  users.users.ship = {
    isNormalUser = true;
    extraGroups = [ "wheel" "nginx" ];
    # If you don't want public keys to live in the repo, you can remove the line below
    # ~/.ssh will be used instead and will not be checked into version control. 
    # Note that this requires you to manage SSH keys manually via SSH,
    # and your will need to manage authorized keys for root and ship user separately
    openssh.authorizedKeys.keyFiles = [ ./authorized_keys ];
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDHW0hBxU8FjUadFi6v7KN1P3DeAJkxk3Nd3LFfP7Cmr7jA9X9IyPb9LMeG4VPQWHaZ2ArvrU0ZIh1aLNTUFYAtbfNHTbRYzDA7nV2Ng91EmSKlGuw8WxnozGXqSfteypyDiTuQP4fcAgop0/OY9+yuherorl+Q2OtBM2KViLUye6wIdfAKXc/O3JeWPbrFlR2yFeBdRHxSvoqIlCf04tc7S56PsPfe13kvc/XTdbnEhss1EzVUaBS9EVI8hTw8K4Fx1ierbtD0kAeI0FKFQYJ3hyRlA5hiwz2YAZsRm6k5W+Dh0W8mke3v0uzBtRR8Nn3NQL3s8XJId0RNjBeJoeLNsGZbAmvHBEC3Kzr5/4cUgq4veimqduuV2Kx0R+2a15AMinZ2mKFJ2E8dD78OuUeOt+sVT7SArXuooOb7EVoFgYJ7lSexgXaWWjKrdRmRvEYvKJyVbX3i8iUv9it20WIW4zMMrzhxxTAK7N/s/IWLjhXjhN8MJ39iIAbZIVhqIuM= ship@tite-ship
"
    ];
  };

  # Can be removed if you want authorized keys to only live on server, not in repository
  # Se note above for users.users.ship.openssh.authorizedKeys.keyFiles
  users.users.root.openssh.authorizedKeys.keyFiles = [ ./authorized_keys ];
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDHW0hBxU8FjUadFi6v7KN1P3DeAJkxk3Nd3LFfP7Cmr7jA9X9IyPb9LMeG4VPQWHaZ2ArvrU0ZIh1aLNTUFYAtbfNHTbRYzDA7nV2Ng91EmSKlGuw8WxnozGXqSfteypyDiTuQP4fcAgop0/OY9+yuherorl+Q2OtBM2KViLUye6wIdfAKXc/O3JeWPbrFlR2yFeBdRHxSvoqIlCf04tc7S56PsPfe13kvc/XTdbnEhss1EzVUaBS9EVI8hTw8K4Fx1ierbtD0kAeI0FKFQYJ3hyRlA5hiwz2YAZsRm6k5W+Dh0W8mke3v0uzBtRR8Nn3NQL3s8XJId0RNjBeJoeLNsGZbAmvHBEC3Kzr5/4cUgq4veimqduuV2Kx0R+2a15AMinZ2mKFJ2E8dD78OuUeOt+sVT7SArXuooOb7EVoFgYJ7lSexgXaWWjKrdRmRvEYvKJyVbX3i8iUv9it20WIW4zMMrzhxxTAK7N/s/IWLjhXjhN8MJ39iIAbZIVhqIuM= ship@tite-ship
"
  ];

  security.sudo.extraRules = [
    {
      users = [ "ship" ];
      commands = [
        {
          command = "ALL";
          options = [ "NOPASSWD" "SETENV" ];
        }
      ];
    }
  ];
}
