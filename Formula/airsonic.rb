class Airsonic < Formula
  desc "Free and Open Source media streaming server (fork of Subsonic and Libresonic)"
  homepage "https://airsonic.github.io/docs/"
  url "https://github.com/airsonic/airsonic/releases/download/v10.1.0/airsonic.war"
  version "10.1.0"
  sha256 "bf5f396f0aba49c022e4c3694c94b1a1edc16c4e1a9137062b0f2899368ff04e"

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

  def plist; <<-EOS.undent
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
          <string>-Dserver.contextPath=/</string>
          <string>-Dairsonic.home=#{workingdir}</string>
          <string>-Dairsonic.host=0.0.0.0</string>
          <string>-Dairsonic.port=4040</string>
          <string>-Dairsonic.contextPath=/</string>
          <string>-Dairsonic.defaultMusicFolder=~/Music/iTunes/iTunes Media/Music</string>
          <string>-Dairsonic.defaultPodcastFolder=~/Music/iTunes/iTunes Media/Podcasts</string>
          <string>-Dairsonic.defaultPlaylistFolder=~/Music/Playlists</string>
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
