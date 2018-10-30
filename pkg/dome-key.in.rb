class DomeKey < Formula
  desc ""
  homepage ""
  version "${VERSION}"
  url ""
  sha256 "${SHA256}"

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
