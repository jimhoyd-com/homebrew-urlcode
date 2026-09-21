# Rendered by scripts/render-homebrew.ts at release time and published as a
# release asset. The rendered file belongs in the jimhoyd-com/homebrew-urlcode
# tap as Formula/urlcode.rb. Placeholders are filled from the published tarball,
# so this template is never a stale copy of a real formula.
class Urlcode < Formula
  desc "Portable runtime for programmable URL behavior"
  homepage "https://github.com/jimhoyd-com/urlcode"
  url "https://registry.npmjs.org/@jimhoyd/urlcode/-/urlcode-0.4.8.tgz"
  sha256 "7b5a654c93b0914cae2c093c390ed3eb2702d9c066237eed62bbe5d6b5eaf28a"
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
