{ pkgs, ...}: {
  require = [
    (import ./starlord {})
    (import ./rco)
  ];
}
