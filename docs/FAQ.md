# FAQ

## Is downloading from YouTube legal?

It's a gray zone that varies by jurisdiction. The norms in the producer/DJ community are that label SoundCloud uploads and many YouTube uploads are intended to be discoverable. For tracks you genuinely love and want to support: buy them on Beatport / Bandcamp / iTunes. Many are.

`crate` is a tool. Use it to discover; pay for what you keep listening to.

## Why not just use Spotify?

Spotify deprecated the recommendations + audio-features APIs for new apps in November 2024. Even if they hadn't, Spotify doesn't let you actually own the audio files — they live in their app. `crate` builds a local library you control.

## Will the LLM hallucinate fake tracks?

Sometimes. yt-dlp returns "no results" and the script logs it as a failure. Typical hit rate: 80-95% of suggestions match an actual file on YouTube. Failures don't crash anything.

## What if it downloads the wrong upload?

Rare but happens (remix instead of original, low-quality re-upload, fake). Press `crate skip` — file moves to `.trash/`, won't be re-downloaded, mpd advances.

## How does dedup work?

The LLM sees three lists each time you run `crate add`:
1. The current crate description
2. The filenames currently in the crate folder
3. The filenames in `.trash/` (rejected)

It's instructed to avoid both lists when suggesting new tracks. As the library grows, suggestions shift toward less-obvious territory — the LLM goes deeper into adjacent labels and lesser-known artists.

## Why a separate folder per crate? Can a track be in multiple crates?

Each crate has its own purpose, prose description, and dedup state. Cross-crate playlists complicate that. If you genuinely want a track in two crates, copy or symlink it. v1 keeps it stupid.

## What about rate limits?

- yt-dlp: YouTube periodically rolls out anti-bot measures. If downloads start failing, run `yt-dlp -U` and try `--cookies-from-browser firefox`.
- LLM APIs: not a concern at this scale (one call per `add`, ~700 input tokens).

## Can I use a local LLM?

Not in v1. Anthropic / Gemini / OpenAI HTTP only. Local Ollama support is a candidate plugin — PRs welcome.

## How do I add a new compositor / picker / OS?

- New compositor: write a `<name>.bindings.example` in `config/` mirroring an existing one.
- New picker: add a branch in `pick_picker()` and `run_picker()` in `bin/crate`.
- macOS / Windows: would need to swap mpd for something native (mpv? AppleScript Music app?). Significant work; not on the roadmap.

## How big should a crate get?

No hard limit. Practically: 100-300 tracks per crate is a sweet spot. Past that, the LLM context gets long enough that suggestions start drifting in quality (the model gets "bored" of the constraint list). Solution: archive old tracks elsewhere and let the crate breathe.

## Can I edit the description after `crate new`?

Yes. Edit `~/Audio/crate/<name>/.crate.json` directly. Future `crate add` runs use the new description.

## Why no audition / vocal-detection pipeline?

We tried. The simpler version is: tell the LLM "instrumental only" in the description, and skip any misses. After ~100 tracks, the misses are vanishingly rare.

If you really want it: write a plugin that runs CLAP zero-shot scoring on `_candidates/` before they land in the library. The hooks are there in `cmd_add`.
