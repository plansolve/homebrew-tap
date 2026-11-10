class Plansolve < Formula
  desc "Kick-ass command-line interface for the PlanSolve optimization API."
  homepage "https://getplansolve.com"
  version "0.40.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/plansolve/distro/releases/download/rust/v0.40.1/plansolve-cli-aarch64-apple-darwin.tar.gz"
      sha256 "1570bb0a83da75dee413d179ed0ae70ed588df4486b8f0c3e34ecbfad89f2379"
      mirror "https://github.com/plansolve/sdk/releases/download/rust/v0.40.1/plansolve-cli-aarch64-apple-darwin.tar.gz"
      sha256 "1570bb0a83da75dee413d179ed0ae70ed588df4486b8f0c3e34ecbfad89f2379"
    end
    if Hardware::CPU.intel?
      url "https://github.com/plansolve/distro/releases/download/rust/v0.40.1/plansolve-cli-x86_64-apple-darwin.tar.gz"
      sha256 "50672c08b2dea4f053b3bc78ca863e06ff05b804eb3314189e2936c96e9d1202"
      mirror "https://github.com/plansolve/sdk/releases/download/rust/v0.40.1/plansolve-cli-x86_64-apple-darwin.tar.gz"
      sha256 "50672c08b2dea4f053b3bc78ca863e06ff05b804eb3314189e2936c96e9d1202"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/plansolve/distro/releases/download/rust/v0.40.1/plansolve-cli-x86_64-unknown-linux-gnu.tar.gz"
    sha256 "3db164ef45778c2622a5a17a973156dd02b5fb8c4b35db582082c91762864c02"
    mirror "https://github.com/plansolve/sdk/releases/download/rust/v0.40.1/plansolve-cli-x86_64-unknown-linux-gnu.tar.gz"
    sha256 "3db164ef45778c2622a5a17a973156dd02b5fb8c4b35db582082c91762864c02"
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
