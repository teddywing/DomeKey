class DomeKey < Formula
  desc ""
  homepage ""
  version "${VERSION}"
  url ""
  sha256 "${SHA256}"

  # Rust code requires at least 10.7
  depends_on :macos => :lion

  def install
    bin.install "dome-key"
    man1.install "dome-key.1"
  end

  def plist_name
    "com.teddywing.dome-key"
  end

  def plist; <<~EOS
${PLIST}
  EOS
  end
end
