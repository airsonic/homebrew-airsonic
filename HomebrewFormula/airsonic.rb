class Airsonic < Formula
  desc "Free and Open Source media streaming server (fork of Subsonic and Libresonic)"
  homepage "https://airsonic.github.io/docs/"
  url "https://github.com/airsonic/airsonic/releases/download/v10.2.1/airsonic.war"
  version "10.2.1"
  sha256 "9bd4e9651df1a15278fb6414d011bd5a45c037857e84eaeb1375b26c717a5ebe"

  depends_on :java
  depends_on "ffmpeg" => ["with-fdk-aac"]
  depends_on "lame"

  def install
    prefix.install "airsonic.war"
  end

  def post_install
    (var/"airsonic").mkpath
    unless (var/"airsonic/airsonic.log").exist?
      (var/"airsonic/airsonic.log").write("")
    end
    (var/"airsonic/transcode").mkpath
    (var/"airsonic/transcode").install_symlink HOMEBREW_PREFIX/"bin/ffmpeg"
    (var/"airsonic/transcode").install_symlink HOMEBREW_PREFIX/"bin/lame"
  end

  def workingdir
    var/"airsonic"
  end

  def plist; <<-EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>EnableGlobbing</key>
        <true/>
        <key>ProgramArguments</key>
        <array>
          <string>java</string>
          <string>--add-modules=java.se.ee</string>
          <string>-XX:+IgnoreUnrecognizedVMOptions</string>
          <string>-Xmx512m</string>
          <string>-Dlogging.file=#{var}/log/airsonic.log</string>
          <string>-Dlogging.level.root=ERROR</string>
          <string>-Dserver.host=0.0.0.0</string>
          <string>-Dserver.port=4040</string>
          <string>-Dserver.context-path=/</string>
          <string>-Dairsonic.home=#{workingdir}</string>
          <string>-Djava.awt.headless=true</string>
          <string>-jar</string>
          <string>#{prefix}/airsonic.war</string>
        </array>
        <key>ServiceDescription</key>
        <string>#{name}</string>
        <key>WorkingDirectory</key>
        <string>#{workingdir}</string>
        <key>StandardErrorPath</key>
        <string>#{var}/log/airsonic.log</string>
        <key>StandardOutPath</key>
        <string>#{var}/log/airsonic.log</string>
        <key>RunAtLoad</key>
        <true/>
      </dict>
      </plist>
    EOS
  end
end
