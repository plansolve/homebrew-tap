class Plansolve < Formula
  desc "Kick-ass command-line interface for the PlanSolve optimization API."
  homepage "https://getplansolve.com"
  version "0.37.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/plansolve/distro/releases/download/rust/v0.37.0/plansolve-cli-aarch64-apple-darwin.tar.gz"
      sha256 "61a020d6f78f2777cce1ceb3eea8c115ddc071e8af9b29c1d2ac6b9edede706f"
      mirror "https://github.com/plansolve/sdk/releases/download/rust/v0.37.0/plansolve-cli-aarch64-apple-darwin.tar.gz"
      sha256 "61a020d6f78f2777cce1ceb3eea8c115ddc071e8af9b29c1d2ac6b9edede706f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/plansolve/distro/releases/download/rust/v0.37.0/plansolve-cli-x86_64-apple-darwin.tar.gz"
      sha256 "1d17ad565f96158d8efaf053c92f797c02f5c92dc6e4ddf3ee8db037c598e0ed"
      mirror "https://github.com/plansolve/sdk/releases/download/rust/v0.37.0/plansolve-cli-x86_64-apple-darwin.tar.gz"
      sha256 "1d17ad565f96158d8efaf053c92f797c02f5c92dc6e4ddf3ee8db037c598e0ed"
    end
  end
  license "Apache-2.0"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":  {},
    "x86_64-apple-darwin":   {},
    "x86_64-pc-windows-gnu": {},
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

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
