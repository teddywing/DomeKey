class DomeKey < Formula
  desc "Control your computer with a pair of headphones"
  homepage "https://domekey.teddywing.com"
  version "${VERSION}"
  url "https://domekey.teddywing.com/downloads/dome-key_${VERSION}.tar.bz2"
  sha256 "${SHA256}"

  # Rust code requires at least 10.7
  depends_on :macos => :lion

  def install
    bin.install "dome-key"
    man1.install "dome-key.1"
    man7.install "dome-key-mappings.7"
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

  plist_options :manual => "dome-key --daemon --audio"

  def plist; <<~EOS
${PLIST}
  EOS
  end
end
