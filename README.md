# Dotfiles (macOS)

Personal ZSH dotfiles for my macOS machine. Native ZSH only — no framework
overhead. The few plugins used are installed as
plain Homebrew formulae and sourced directly.

## Toolchain

- **Node.js** → [Volta](https://volta.sh)
- **Python** → [uv](https://docs.astral.sh/uv/)
- **Rust** → rustup / cargo
- **Docker** → [OrbStack](https://orbstack.dev)
- **Editor** → VSCode, or nano with syntax highlighting

## Structure

```
.zshenv           # loaded always; PATH/env needed everywhere
.zprofile         # loaded once per login shell (OrbStack init, private profile)
.zshrc            # interactive shell config, sources everything in zsh/
.nanorc           # nano config
Brewfile          # every tool/plugin these dotfiles depend on
install.sh        # brew bundle + symlink everything into $HOME
zsh/
  variables.zsh   # prompt icons/colors/symbols - start here to customize
  plugins.zsh     # sources the 3 Homebrew-installed zsh plugins
  history.zsh     # history options + substring search keybindings
  git-prompt.zsh  # native git status prompt segment
  node.zsh        # Volta-backed node version prompt segment
  rust.zsh        # cargo version prompt segment
  python.zsh      # uv-backed python version prompt segment
  time.zsh        # right-prompt command execution timer
  prompt.zsh      # assembles the final two-line prompt
  aliases.zsh     # short aliases + update-dotfiles
  print256colors.zsh
  bin/            # standalone scripts, added to $PATH by .zshenv (see below)
private/          # git submodule (separate repo) holding private configs
nano/             # custom nanorc files
```

## Prompt

```
<cwd> on <git branch> <status icon> <node> <cargo> <python>
シ <your input>
```

- The git segment only appears inside a git work tree.
- Node/Rust/Python segments only appear when the current folder looks like a
  project of that kind (`package.json`/`node_modules`, `Cargo.toml`,
  `pyproject.toml`/`requirements.txt`/`.python-version`/etc.), so the prompt
  stays uncluttered everywhere else.
- Git status icons (shown after the branch name): ✖ unmerged, ● staged,
  ✚ unstaged, … untracked, ⚑ stashed, ↑ ahead, ↓ behind, ✔ clean.
- Right prompt shows how long the last command took.
- A blank line is printed before every prompt (except the very first) so each
  command's output stays visually separated from the next one.

Everything is customizable from `zsh/variables.zsh` (icons, colors, the
`PROMPT_SYMBOL`) without touching the logic in the other files.

## Install

```sh
git clone --recurse-submodules git@github.com:Hecsall/dotfiles-macos.git ~/.dotfiles
cd ~/.dotfiles
./install.sh
```

> The `private` submodule only clones successfully if your SSH key has access
> to `Hecsall/dotfiles-macos-private`. Without access, clone without
> `--recurse-submodules` to still get the public one.

`install.sh` will:
1. Check Homebrew is installed (install it yourself from https://brew.sh first if not).
2. Run `brew bundle` to install every tool/plugin in `Brewfile`.
3. Fetch submodules.
4. Symlink `.zshenv`, `.zshrc`, `.zprofile`, `.nanorc`
   into `$HOME`, **overwriting existing files** — back them up first.
5. Run `private/install.sh`, which symlinks other private configs

## Pulling updates

```sh
update-dotfiles
```

There's an alias (`.u`) for this function which just runs
`git pull --recurse-submodules` here and restarts the shell, so both this repo
and the `private` submodule stay in sync.

## Pushing changes

For anything directly in this repo (`.zshrc`, `zsh/*.zsh`, `Brewfile`, etc.):

```sh
git add -A
git commit -m "..."
git push
```

`private/` is an independent git repo checked
out as submodules, so changes made *inside* it need their own commit/push
before updating the pointer here:

```sh
cd private
git add -A
git commit -m "..."
git push

cd ..
git add private                   # records the new submodule commit
git commit -m "Update private submodule"
git push
```

Tip: `git push --recurse-submodules=on-demand` from the root pushes the
submodule's already-made commits automatically if you forget the first step.

## Private submodule

Sensitive dotfiles (SSH config, `.gitconfig`, private aliases/tokens) live in
the private repo, checked out here as the
`private/` submodule.