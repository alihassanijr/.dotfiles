### Fix hostname!

```bash
sudo scutil --set HostName $YOUR_CUSTOM_HOSTNAME
```

### Disabling pop up view of key accents
Run this command:

```bash
defaults write -g ApplePressAndHoldEnabled -bool false
```


### Disable bouncing icons in dock!!!

```bash
defaults write com.apple.dock no-bouncing -bool TRUE
killall Dock
```
