{ pkgs, lib, ... }:

{
  environment.systemPackages = [
    (pkgs.writeShellScriptBin "codium-test" ''
      set -e
      dir="''${XDG_CACHE_HOME:-~/.cache}/nixd-codium"
      ${pkgs.coreutils}/bin/mkdir -p "$dir/User"
      cat >"$dir/User/settings.json" <<EOF
      {
      "security.workspace.trust.enabled": false,
      "nix.enableLanguageServer": true,
      "nix.serverPath": "nixd",
      }
      EOF
      ${pkgs.vscode-with-extensions.override {
        vscode = pkgs.vscodium;
        vscodeExtensions = with pkgs.vscode-extensions; [
          jnoortheen.nix-ide
        ];
      }}/bin/codium --user-data-dir "$dir" "$@"
    '')
  ];
}