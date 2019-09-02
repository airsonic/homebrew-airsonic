# Airsonic Homebrew Tap

Free and Open Source media streaming server (fork of Subsonic and Libresonic)

## Installation

```
$ brew tap airsonic/airsonic
$ brew install airsonic
```

## Updating settings

Use your favorite text editor and open `$(brew --prefix)/Cellar/airsonic/10.4.0/homebrew.mxcl.airsonic.plist`

Edit any of the following properties:

```
<string>-Xmx512m</string>  <!-- Max Memory -->
<string>-Dlogging.file=/usr/local/var/log/airsonic.log</string>
<string>-Dlogging.level.root=ERROR</string>
<string>-Dserver.host=0.0.0.0</string>
<string>-Dserver.port=4040</string>
<string>-Dserver.context-path=/</string>  <!-- localhost:port/context-path, e.g.: /airsonic -->
<string>-Dairsonic.home=/usr/local/var/airsonic</string>
<string>-Djava.awt.headless=true</string>
<string>-jar</string>
<string>/usr/local/Cellar/airsonic/10.4.0/airsonic.war</string>
```

> Source: https://airsonic.github.io/docs/install/homebrew/