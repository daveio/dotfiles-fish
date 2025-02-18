function asdf-latest
  echo "updating asdf..." 1>&2
  asdf update --head > /dev/null 2>/dev/null
  echo "updating plugins..." 1>&2
  asdf plugin update --all > /dev/null 2>/dev/null
  echo "getting latest versions..." 1>&2
  for i in (asdf plugin list)
    echo -n "$i "
    asdf latest $i
  end
end

function nas-docker
  set -gx DOCKER_HOST tcp://7t54.myqnapcloud.com:2376
  set -gx DOCKER_TLS_VERIFY 1
end

function le-fw
  lego -d fw.lan.sl1p.net -d fw.mgmt.lan.sl1p.net -d fw.private.lan.sl1p.net -d fw.guest.lan.sl1p.net -d fw.iot.lan.sl1p.net -d fw.fastlane.lan.sl1p.net -d fw.public.lan.sl1p.net -d private.external.lan.sl1p.net -d fastlane.external.lan.sl1p.net -d public.external.lan.sl1p.net -a --email dave@dave.io -k ec384 --dns dnsimple --dns.resolvers ns1.dnsimple.com --pem --pfx run
end

function fzf --wraps="fzf"
  set -Ux FZF_DEFAULT_OPTS "
	--color=fg:#908caa,bg:#191724,hl:#ebbcba
	--color=fg+:#e0def4,bg+:#26233a,hl+:#ebbcba
	--color=border:#403d52,header:#31748f,gutter:#191724
	--color=spinner:#f6c177,info:#9ccfd8
	--color=pointer:#c4a7e7,marker:#eb6f92,prompt:#908caa
	"
	command fzf
end

function cma
  chmod a-x $argv
  chezmoi add $argv
end

function cmae
  chmod a-x $argv
  chezmoi add --encrypt $argv
end

function globals.nodejs
  set -lx NODE_VERSIONS 22.14.0 23.8.0
  for i in $NODE_VERSIONS
    asdf shell nodejs $i
    npm install -g npm@latest
    npm install -g \
      @builder.io/ai-shell \
      bun \
      degit \
      genaiscript \
      opencommit \
      pnpm \
      wrangler
  end
end

function globals.python
  # config
  set -lx PYTHON_DOWNGRADE_VERSION 3.12.9

  # pipx
  pip install pipx
  pipx uninstall-all

  # python 3.12
  pipx install --python ~/.asdf/installs/python/$PYTHON_DOWNGRADE_VERSION/bin/python3 \
    bpython \
    bpytop \
    jupyterlab \
    markitdown \
    n3map \
    pelican[markdown] \
    poetry \
    pygi \
    showcert \
    tidal-dl-ng[gui]

  # python 3.13+
  pipx install \
    aerleon \
    asitop \
    autopep8 \
    black \
    flake8 \
    httpie \
    ipython \
    isort \
    jc \
    legit \
    mypy \
    nyx \
    pre-commit \
    pylint \
    pyoxidizer \
    pyright \
    remarshal \
    sherlock-project \
    shyaml \
    toml-sort \
    virtualfish \
    xonsh \
    yamale \
    yamllint \
    yt-dlp

  # injections
  pipx inject bpython \
    urwid
  pipx inject jupyterlab \
    PyQt6 \
    PySide6 \
    jupyter-pieces \
    jupyter_base16_theme \
    jupyterlab-horizon-theme \
    jupyterlab-pygments \
    jupyterlab_theme_sophon \
    matplotlib \
    scipy
  pipx inject poetry \
    poetry-audit-plugin \
    poetry-plugin-shell
end

function globals.ruby
  gem install \
    bundler \
    cocoapods \
    httparty \
    rails \
    rubocop \
    rubocop-rspec \
    rubyfmt \
    rubygems-server \
    solargraph \
    standard \
    syntax_tree \
    yard
end

function globals.dotnet
  for i in \
    dotnet-dump \
    Microsoft.CST.DevSkim.CLI
      dotnet tool install --global $i
  end
end

function globals.golang
  for i in \
    github.com/go-acme/lego/v4/cmd/lego@latest \
    github.com/google/gops@latest \
    github.com/goreleaser/goreleaser/v2@latest \
    github.com/jesseduffield/lazygit@latest \
    github.com/nsf/gocode@latest \
    github.com/schollz/croc/v10@latest \
    github.com/sigstore/cosign/v2/cmd/cosign@latest \
    github.com/theupdateframework/go-tuf/cmd/tuf-client@latest \
    sigs.k8s.io/kind@latest
      go install $i
  end
end

function globals.rust
  cargo install \
    bat \
    cargo-edit \
    cargo-generate \
    cargo-outdated \
    cargo-release \
    cargo-tree \
    cargo-update \
    cargo-watch \
    exa \
    fast-conventional \
    fd-find \
    git-absorb \
    git-brws \
    git-delta \
    gitoxide \
    gitui \
    hgrep \
    hyperfine \
    just \
    mdbook \
    rage \
    ripgrep \
    sd \
    tokei \
    xsv
end

function globals
  globals.nodejs
  globals.python
  globals.ruby
  globals.dotnet
  globals.golang
  globals.rust
end
