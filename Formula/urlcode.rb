# Rendered by scripts/render-homebrew.ts at release time and published as a
# release asset. The rendered file belongs in the jimhoyd-com/homebrew-urlcode
# tap as Formula/urlcode.rb. Placeholders are filled from the published tarball,
# so this template is never a stale copy of a real formula.
class Urlcode < Formula
  desc "Portable runtime for programmable URL behavior"
  homepage "https://github.com/jimhoyd-com/urlcode"
  url "https://registry.npmjs.org/@jimhoyd/urlcode/-/urlcode-0.6.5.tgz"
  sha256 "318f3690465ce882549ab8e6347ed4b887fd4a3769f42ec453aadb0e8a2007b7"
  license "Apache-2.0"

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    report = JSON.parse(shell_output("#{bin}/urlcode doctor"))
    assert_equal "Apache-2.0", report["license"]
    assert_equal "trusted-in-process", report["functionDefault"]
    assert_equal "quickjs-wasm", report["sandboxEngine"]

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
