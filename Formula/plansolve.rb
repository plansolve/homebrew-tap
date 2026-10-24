class Plansolve < Formula
  desc "Kick-ass command-line interface for the PlanSolve optimization API."
  homepage "https://getplansolve.com"
  version "0.39.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/plansolve/distro/releases/download/rust/v0.39.0/plansolve-cli-aarch64-apple-darwin.tar.gz"
      sha256 "e8d0d7e8360435fadf027e6e9eb1f44082285999a4501e783c5f3dc6888a73a5"
      mirror "https://github.com/plansolve/sdk/releases/download/rust/v0.39.0/plansolve-cli-aarch64-apple-darwin.tar.gz"
      sha256 "e8d0d7e8360435fadf027e6e9eb1f44082285999a4501e783c5f3dc6888a73a5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/plansolve/distro/releases/download/rust/v0.39.0/plansolve-cli-x86_64-apple-darwin.tar.gz"
      sha256 "7a752a2011cb08056864e04e36eaeb88accad78ee00b9dff1102c23e1ba30d99"
      mirror "https://github.com/plansolve/sdk/releases/download/rust/v0.39.0/plansolve-cli-x86_64-apple-darwin.tar.gz"
      sha256 "7a752a2011cb08056864e04e36eaeb88accad78ee00b9dff1102c23e1ba30d99"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/plansolve/distro/releases/download/rust/v0.39.0/plansolve-cli-x86_64-unknown-linux-gnu.tar.gz"
    sha256 "02335666690898790668467b836b7592d9bd6717b314ade7d8239a002cebcd98"
    mirror "https://github.com/plansolve/sdk/releases/download/rust/v0.39.0/plansolve-cli-x86_64-unknown-linux-gnu.tar.gz"
    sha256 "02335666690898790668467b836b7592d9bd6717b314ade7d8239a002cebcd98"
  end
  license "Apache-2.0"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":     {},
    "x86_64-apple-darwin":      {},
    "x86_64-pc-windows-gnu":    {},
    "x86_64-unknown-linux-gnu": {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "plansolve"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "plansolve"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "plansolve"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
