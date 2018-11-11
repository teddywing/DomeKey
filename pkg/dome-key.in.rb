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

  def caveats; <<~EOS
    To get started with a set of mappings, try running the these commands:

    mkdir -p $$HOME/.config/dome-key
    cat <<EOM > $$HOME/.config/dome-key/mappings.dkmap
    map <Play> <Nop>

    mode <Play><Play> {
        map <Up> <Left>
        map <Play> <Space>
        map <Down> <Right>
    }
    EOM
  EOS
  end

  def plist; <<~EOS
${PLIST}
  EOS
  end
end
