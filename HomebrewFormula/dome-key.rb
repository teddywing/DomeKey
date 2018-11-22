class DomeKey < Formula
  desc "Control your computer with a pair of headphones"
  homepage "https://domekey.teddywing.com"
  version "1.0"
  url "https://domekey.teddywing.com/downloads/dome-key_1.0.tar.bz2"
  sha256 "999377af51f9bfd381dcc5cce1a4ece0626774a35674827ad5002e5a2c2786f4"

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

    mkdir -p $HOME/.config/dome-key
    cat <<EOM > $HOME/.config/dome-key/mappings.dkmap
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
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN"
    	"http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
    	<key>Label</key>
    	<string>com.teddywing.dome-key</string>
    	<key>ProgramArguments</key>
    	<array>
    		<string>/usr/local/bin/dome-key</string>
    		<string>--daemon</string>
    		<string>--audio</string>
    	</array>
    	<key>RunAtLoad</key>
    	<true/>
    	<key>KeepAlive</key>
    	<true/>
    	<key>StandardErrorPath</key>
    	<string>/tmp/dome-key.log</string>
    </dict>
    </plist>
  EOS
  end
end
