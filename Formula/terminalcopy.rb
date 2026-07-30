class Terminalcopy < Formula
  desc "AI-friendly terminal output helper for macOS and zsh"
  homepage "https://github.com/knnkanda/terminalcopy"
  license "MIT"

  head "https://github.com/knnkanda/terminalcopy.git", branch: "main"

  def install
    libexec.install "terminalcopy.zsh"
    (bin/"terminalcopy").write <<~EOS
      #!/usr/bin/env zsh
      echo 'TerminalCopy is installed.'
      echo 'Add this to your ~/.zshrc:'
      echo "source \"$(brew --prefix #{name})/libexec/terminalcopy.zsh\""
    EOS
    chmod 0755, bin/"terminalcopy"
  end

  def caveats
    <<~EOS
      TerminalCopy is a shell integration, so you still need to load it from zsh.

      Add this line to your ~/.zshrc:
        source "$(brew --prefix #{name})/libexec/terminalcopy.zsh"

      Then reload your shell:
        source ~/.zshrc
    EOS
  end

  test do
    assert_match "TerminalCopy is installed.", shell_output("#{bin}/terminalcopy")
  end
end
