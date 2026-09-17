# Rendered by scripts/render-homebrew.ts at release time and published as a
# release asset. The rendered file belongs in the jimhoyd-com/homebrew-urlcode
# tap as Formula/urlcode.rb. Placeholders are filled from the published tarball,
# so this template is never a stale copy of a real formula.
class Urlcode < Formula
  desc "Portable runtime for programmable URL behavior"
  homepage "https://github.com/jimhoyd-com/urlcode"
  url "https://registry.npmjs.org/@jimhoyd/urlcode/-/urlcode-0.3.0.tgz"
  sha256 "d099cdc2d36b817370e2cb25be32b0778ccb7224290324b6fb4e5727e69bc43c"
  license "Apache-2.0"

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  def caveats
    <<~EOS
      Live short-link storage needs a Node build carrying the patched SQLite WAL
      fix. Check it with:
        urlcode doctor
      Everything except live links runs on any supported Node build.
    EOS
  end

  test do
    report = JSON.parse(shell_output("#{bin}/urlcode doctor"))
    assert_equal "Apache-2.0", report["license"]
    assert_equal "quickjs-wasm", report["functionSandbox"]

    (testpath/"urlcode.yaml").write <<~YAML
      version: "1"
      routes:
        /go:
          redirect:
            url: https://example.com/
    YAML
    # Single-quoted: the expected text contains double quotes, and escaping them
    # inside a double-quoted Ruby string is what made this formula unparsable.
    assert_match '"routes":1', shell_output("#{bin}/urlcode validate --project #{testpath}")
  end
end
