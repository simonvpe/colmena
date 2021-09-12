{}:
{
  "module/i3" = {
    type = "internal/i3";
    pin-workspaces = true;
    strip-wsnumbers = true;
    index-sort = true;
    enable-click = false;
    enable-scroll = false;
    wrapping-scroll = false;
    reverse-scroll = false;
    fuzzy-match = true;
    format = "<label-state> <label-mode>";
    label-mode = "%mode%";
    label-mode-padding = 2;
    label-mode-background = "#e60053";
    label-focused = "%index%";
    label-focused-foreground = "\${colors.secondary}";
    label-focused-background = "\${colors.background}";
    label-focused-underline = "\${colors.primary}";
    label-focused-padding = 0;
    label-unfocused = "%index%";
    label-unfocused-padding = 0;
    label-separator = "|";
    label-separator-padding = 1;
    label-separator-foreground = "\${colors.primary}";
  };
}
