class Plansolve < Formula
  desc "Kick-ass command-line interface for the PlanSolve optimization API."
  homepage "https://getplansolve.com"
  version "0.28.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/plansolve/distro/releases/download/rust/v0.28.0/plansolve-cli-aarch64-apple-darwin.tar.gz"
      sha256 "58ebb012c412d7f91e1b3f34fd46cf4fdb5166bf724f0ae899188333d1e1f4c6"
      mirror "https://github.com/plansolve/sdk/releases/download/rust/v0.28.0/plansolve-cli-aarch64-apple-darwin.tar.gz"
      sha256 "58ebb012c412d7f91e1b3f34fd46cf4fdb5166bf724f0ae899188333d1e1f4c6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/plansolve/distro/releases/download/rust/v0.28.0/plansolve-cli-x86_64-apple-darwin.tar.gz"
      sha256 "ba51a25ba50691dff82fbd19d1fd3e94a14b395f73f97fbb11991331b44cb26a"
      mirror "https://github.com/plansolve/sdk/releases/download/rust/v0.28.0/plansolve-cli-x86_64-apple-darwin.tar.gz"
      sha256 "ba51a25ba50691dff82fbd19d1fd3e94a14b395f73f97fbb11991331b44cb26a"
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
