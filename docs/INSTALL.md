# Install

## System packages

### Arch Linux
```sh
sudo pacman -S mpd mpc yt-dlp python fzf
# optional: walker (Omarchy default), wofi, or rofi for the switch picker
```

### Debian / Ubuntu
```sh
sudo apt install mpd mpc yt-dlp python3 fzf
```

### Fedora
```sh
sudo dnf install mpd mpc yt-dlp python3 fzf
```

## crate itself

```sh
git clone https://github.com/<user>/crate.git
cd crate
make install
```

This installs `crate` to `~/.local/bin/` and copies config examples to `~/.config/crate/` (without overwriting existing files).

Make sure `~/.local/bin` is on your `PATH`.

## mpd

```sh
mkdir -p ~/.config/mpd ~/.local/share/mpd/playlists
cp config/mpd.conf.example ~/.config/mpd/mpd.conf
systemctl --user enable --now mpd
```

The example config binds mpd to localhost only — no network exposure.

If mpd fails to start with `failed to open log file`, the state directory
doesn't exist yet. `make install` creates it; otherwise run the `mkdir -p`
above first.

## API key

Set one of these in your shell profile:

```sh
export ANTHROPIC_API_KEY=sk-ant-...
# or
export GEMINI_API_KEY=...
# or
export OPENAI_API_KEY=sk-...
```

`crate` auto-detects and uses the first one available, in that order.

## Compositor bindings

### Hyprland

```sh
cp config/hyprland.bindings.example ~/.config/crate/hyprland.bindings
echo "source = ~/.config/crate/hyprland.bindings" >> ~/.config/hypr/bindings.conf
hyprctl reload
```

### Sway / i3 / sxhkd

See the corresponding `config/<compositor>.bindings.example` file. Append the bindings to your compositor config.

## Verify

```sh
crate doctor
```

If everything's green:

```sh
crate new focus -d "deep melodic techno, instrumental, ~122bpm, like Tale of Us"
crate add focus
crate play focus
```

## Uninstall

```sh
make uninstall          # removes binary; keeps config + audio
rm -rf ~/.config/crate  # remove config
rm -rf ~/Audio/crate    # remove your library (you sure?)
```
