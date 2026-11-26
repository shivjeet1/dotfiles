# dotfiles

Hyprland-first dotfiles for Lenovo Yoga Slim 6i (Intel `intel_backlight`), with a
kept-as-is X11/dwm fallback. Managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Install / deploy

```sh
sudo pacman -S stow

# Back up every managed path that already exists in $HOME
mkdir -p /tmp/dotfiles-home-backup
for p in .zshrc .xinitrc \
  .config/betterlockscreen .config/cava .config/hypr .config/kitty \
  .config/nvim .config/picom .config/wal .config/waybar .config/wofi \
  .config/xdg-desktop-portal .config/zsh .local/bin; do
  [ -e "$HOME/$p" ] && cp -a "$HOME/$p" "/tmp/dotfiles-home-backup/$(echo "$p" | tr / _)"
done

# Remove the backed-up real paths so stow can create clean symlinks
# (skip anything you want to keep, e.g. unmanaged files in ~/.local/bin such as agy/gh)
rm -rf ~/.config/hypr ~/.config/waybar ~/.config/zsh ~/.config/nvim \
       ~/.config/picom ~/.config/betterlockscreen ~/.config/cava \
       ~/.config/kitty ~/.config/wal ~/.config/wofi \
       ~/.config/xdg-desktop-portal ~/.zshrc ~/.xinitrc
sudo rm -f ~/.local/bin/grims ~/.local/bin/dynamic-bgtns
rm -f ~/.config/picom/picom.config

cd ~/dotfiles
stow -n -v -t ~ .   # dry run: inspect before applying
stow -t ~ .         # apply
```

To undo: `stow -D -t ~ .`.

Only the paths listed above are stowed. `scripts/`, README, LICENSE and images are
excluded via `.stow-local-ignore`.

## What is managed

- `~/.config/hypr/` – `hyprland.lua`, `hypridle.conf`, `hyprlock.conf`, `hyprpaper.conf`, `scripts/cava.sh`
- `~/.config/waybar/` – `config.jsonc`, `style.css`
- `~/.config/nvim/` – lazy.nvim config (`lua/impossibleclone-nvim/`)
- `~/.config/zsh/` – `aliasrc`, `git-prompt.sh`
- `~/.zshrc`, `~/.xinitrc`
- `~/.local/bin/grims` – screenshot helper used by Hyprland

## Notes

- **Brightness:** `XF86MonBrightnessUp/Down` call `brillo -q -A/-U 5 -u 300000`.
  `hypridle` still uses `brightnessctl` for idle dim/restore; both tools are installed.
- **Wallpaper/palette:** wallpapers live in `~/Pictures` (not in git). `wal -R` renders
  `~/.cache/wal/colors-hyprland.lua` for `hyprland.lua`; `scripts/gen-conf.py` writes
  `~/.cache/wal/colors-hyprland.conf` for `hyprlock`. `scripts/hyprset.sh <wallpaper>`
  regenerates the palette and updates `hyprpaper.conf`.
- **X11/dwm fallback:** `.xinitrc` starts `picom`, `xwallpaper`, `slstatus` and `dwm`.
  `picom` reads `~/.config/picom/picom.conf`. `scripts/setwall` expects suckless sources
  in `~/.local/src/{dwm,dmenu,st,slock,slstatus}` (not tracked here).
  `betterlockscreen` config is kept, but the binary is not installed; enable the
  commented `BL` alias in `.config/zsh/aliasrc` once it is.
- **Package lists:** `scripts/installed_packages.txt` and `scripts/manually-installed`
  are intentionally left unchanged as a reference.
- `scripts/win10.sh` / `start-win.sh` are VM helpers used via the `win10` shell alias.
