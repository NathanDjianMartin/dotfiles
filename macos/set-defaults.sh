# Sets macOS defaults how I like them.
#
# The original idea (and a couple settings) were grabbed from:
#   https://github.com/mathiasbynens/dotfiles/blob/master/.macos

# Close any open System Preferences panes, to prevent them from overriding
# settings we’re about to change
osascript -e 'tell application "System Preferences" to quit'

if [ "$CI" != "true" ]; then
	# Ask for the administrator password upfront
	sudo -v

	# Keep-alive: update existing `sudo` time stamp until `.macos` has finished
	while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &
fi

###############################################################################
# General UI/UX                                                               #
###############################################################################

# Display battery percentage.
defaults write com.apple.menuextra.battery ShowPercent YES

# Show Bluetooth in menu bar
defaults write com.apple.systemuiserver menuExtras -array \
"/System/Library/CoreServices/Menu Extras/Bluetooth.menu"

# Use AirDrop over every interface
defaults write com.apple.NetworkBrowser BrowseAllInterfaces 1

# Automatically quit printer app once the print jobs complete
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

# Disable automatic period after typing 2 spaces
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false

# Disable auto-correct
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

###############################################################################
# Trackpad, mouse, keyboard, Bluetooth accessories, and input                 #
###############################################################################

# Enable “natural” scrolling
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool true

# Set a blazingly fast keyboard repeat rate
defaults write NSGlobalDomain KeyRepeat -int 1
defaults write NSGlobalDomain InitialKeyRepeat -int 12

# Set language and text formats
# Note: if you’re in the US, replace `EUR` with `USD`, `Centimeters` with
# `Inches`, `en_GB` with `en_US`, and `true` with `false`.
defaults write NSGlobalDomain AppleLanguages -array "en_GB"
defaults write NSGlobalDomain AppleLocale -string "en_GB@currency=EUR"
defaults write NSGlobalDomain AppleMeasurementUnits -string "Centimeters"
defaults write NSGlobalDomain AppleMetricUnits -bool true

# Set the timezone; see `sudo systemsetup -listtimezones` for other values
sudo systemsetup -settimezone "Europe/Paris" > /dev/null

###############################################################################
# Screen                                                                      #
###############################################################################

# Require password immediately after sleep or screen saver begins
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

# Save screenshots to the desktop
defaults write com.apple.screencapture location -string "${HOME}/Desktop"

# Enable subpixel font rendering on non-Apple LCDs
# Reference: https://github.com/kevinSuttle/macOS-Defaults/issues/17#issuecomment-266633501
defaults write NSGlobalDomain AppleFontSmoothing -int 1

# Enable HiDPI display modes (requires restart)
sudo defaults write /Library/Preferences/com.apple.windowserver DisplayResolutionEnabled -bool true

###############################################################################
# Safari & WebKit                                                             #
###############################################################################

# Privacy: don’t send search queries to Apple
defaults write com.apple.Safari UniversalSearchEnabled -bool false
defaults write com.apple.Safari SuppressSearchSuggestions -bool true

# Press Tab to highlight each item on a web page
defaults write com.apple.Safari WebKitTabToLinksPreferenceKey -bool true
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2TabsToLinks -bool true

# Show the full URL in the address bar (note: this still hides the scheme)
defaults write com.apple.Safari ShowFullURLInSmartSearchField -bool true

# Set Safari’s home page to `about:blank` for faster loading
defaults write com.apple.Safari HomePage -string "about:blank"

# Prevent Safari from opening ‘safe’ files automatically after downloading
defaults write com.apple.Safari AutoOpenSafeDownloads -bool false

# Show Safari's bookmark bar
defaults write com.apple.Safari ShowFavoritesBar -bool true

# Enable Safari’s debug menu
defaults write com.apple.Safari IncludeInternalDebugMenu -bool true

# Enable the Develop menu and the Web Inspector in Safari
defaults write com.apple.Safari IncludeDevelopMenu -bool true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true

# Add a context menu item for showing the Web Inspector in web views
defaults write NSGlobalDomain WebKitDeveloperExtras -bool true

# Warn about fraudulent websites
defaults write com.apple.Safari WarnAboutFraudulentWebsites -bool true

# Enable “Do Not Track”
defaults write com.apple.Safari SendDoNotTrackHTTPHeader -bool true

###############################################################################
# Dock, Dashboard, and hot corners                                            #
###############################################################################

# Hide the dock
defaults write com.apple.dock autohide -bool true

# Minimize windows using the scale effect
defaults write com.apple.dock mineffect -string scale

# Magnify dock icons on hover
defaults write com.apple.dock largesize -int 128

# Disable recent apps
defaults write com.apple.dock show-recents -bool false

# Don't minimize windows into their application’s icon
defaults write com.apple.dock minimize-to-application -bool false

# Enable spring loading for all Dock items
defaults write com.apple.dock enable-spring-load-actions-on-all-items -bool true

# Show indicator lights for open applications in the Dock
defaults write com.apple.dock show-process-indicators -bool true

# Wipe all (default) app icons from the Dock
# This is only really useful when setting up a new Mac, or if you don’t use
# the Dock to launch apps.
defaults write com.apple.dock persistent-apps -array

# Speed up Mission Control animations
defaults write com.apple.dock expose-animation-duration -float 0.1

# Disable Dashboard
defaults write com.apple.dashboard mcx-disabled -bool true

# Don’t automatically rearrange Spaces based on most recent use
defaults write com.apple.dock mru-spaces -bool false

# Remove the auto-hiding Dock delay
defaults write com.apple.dock autohide-delay -float 0

# Remove the animation when hiding/showing the Dock
defaults write com.apple.dock autohide-time-modifier -float 0

# Hot corners
# Possible values:
#  0: no-op
#  2: Mission Control
#  3: Show application windows
#  4: Desktop
#  5: Start screen saver
#  6: Disable screen saver
#  7: Dashboard
# 10: Put display to sleep
# 11: Launchpad
# 12: Notification Center
# 13: Lock Screen
# Top right screen corner → Desktop
defaults write com.apple.dock wvous-tr-corner -int 4
defaults write com.apple.dock wvous-tr-modifier -int 0
# Bottom left screen corner → Lock screen
defaults write com.apple.dock wvous-br-corner -int 13
defaults write com.apple.dock wvous-br-modifier -int 0

###############################################################################
# Finder                                                                      #
###############################################################################

# Allow quitting via ⌘ + Q; doing so will also hide desktop icons
defaults write com.apple.finder QuitMenuItem -bool true

# Show file extensions
defaults write NSGlobalDomain "AppleShowAllExtensions" -bool true

# Always open everything in Finder's column view
# Four-letter codes for the other view modes: `icnv`, `Nlsv`, `glyv`
defaults write com.apple.Finder FXPreferredViewStyle clmv

# Show the ~/Library folder
chflags nohidden ~/Library

# Disable warning when changing file extension
defaults write com.apple.finder "FXEnableExtensionChangeWarning" -bool false

# Set the Finder prefs for showing a few different volumes on the Desktop
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true

# Display full POSIX path as Finder window title
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

# When performing a search, search the current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Enable spring loading for directories
defaults write NSGlobalDomain com.apple.springing.enabled -bool true

# Remove the spring loading delay for directories
defaults write NSGlobalDomain com.apple.springing.delay -float 0

# Avoid creating .DS_Store files on network or USB volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Show the /Volumes folder
sudo chflags nohidden /Volumes

# Expand the following File Info panes:
# “General”, “Open with”, and “Sharing & Permissions”
# Collapse the following File Info panes:
# "Preview"
defaults write com.apple.finder FXInfoPanesExpanded -dict \
	General -bool true \
	OpenWith -bool true \
	Privileges -bool true \
    Preview -bool false

###############################################################################
# Mail                                                                        #
###############################################################################

# Disable inline attachments (just show the icons)
defaults write com.apple.mail DisableInlineAttachmentViewing -bool true

# Disable automatic spell checking
defaults write com.apple.mail SpellCheckingBehavior -string "NoSpellCheckingEnabled"

###############################################################################
# Spotlight                                                                   #
###############################################################################

# Change indexing order and disable some search results
# Yosemite-specific search results (remove them if you are using macOS 10.9 or older):
# 	MENU_DEFINITION
# 	MENU_CONVERSION
# 	MENU_EXPRESSION
# 	MENU_SPOTLIGHT_SUGGESTIONS (send search queries to Apple)
# 	MENU_WEBSEARCH             (send search queries to Apple)
# 	MENU_OTHER
defaults write com.apple.spotlight orderedItems -array \
		'{"enabled" = 1;"name" = "APPLICATIONS";}' \
		'{"enabled" = 1;"name" = "SYSTEM_PREFS";}' \
		'{"enabled" = 1;"name" = "DIRECTORIES";}' \
		'{"enabled" = 1;"name" = "MENU_CONVERSION";}' \
		'{"enabled" = 0;"name" = "PDF";}' \
		'{"enabled" = 0;"name" = "DOCUMENTS";}' \
		'{"enabled" = 0;"name" = "FONTS";}' \
		'{"enabled" = 0;"name" = "MESSAGES";}' \
		'{"enabled" = 0;"name" = "CONTACT";}' \
		'{"enabled" = 0;"name" = "EVENT_TODO";}' \
		'{"enabled" = 0;"name" = "IMAGES";}' \
		'{"enabled" = 0;"name" = "BOOKMARKS";}' \
		'{"enabled" = 0;"name" = "MUSIC";}' \
		'{"enabled" = 0;"name" = "MOVIES";}' \
		'{"enabled" = 0;"name" = "PRESENTATIONS";}' \
		'{"enabled" = 0;"name" = "SPREADSHEETS";}' \
		'{"enabled" = 0;"name" = "SOURCE";}' \
		'{"enabled" = 0;"name" = "MENU_DEFINITION";}' \
		'{"enabled" = 0;"name" = "MENU_OTHER";}' \
		'{"enabled" = 1;"name" = "MENU_EXPRESSION";}' \
		'{"enabled" = 0;"name" = "MENU_SPOTLIGHT_SUGGESTION";}'

# Load new settings before rebuilding the index
killall mds > /dev/null 2>&1
# Make sure indexing is enabled for the main volume
sudo mdutil -i on / > /dev/null

###############################################################################
# Activity Monitor                                                            #
###############################################################################

# Show the main window when launching Activity Monitor
defaults write com.apple.ActivityMonitor OpenMainWindow -bool true

# Visualize CPU usage in the Activity Monitor Dock icon
defaults write com.apple.ActivityMonitor IconType -int 5

# Show all processes in Activity Monitor
defaults write com.apple.ActivityMonitor ShowCategory -int 0

# Sort Activity Monitor results by CPU usage
defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"
defaults write com.apple.ActivityMonitor SortDirection -int 0

###############################################################################
# TextEdit                                                                    #
###############################################################################

# Use plain text mode for new TextEdit documents
defaults write com.apple.TextEdit RichText -int 0
# Open and save files as UTF-8 in TextEdit
defaults write com.apple.TextEdit PlainTextEncoding -int 4
defaults write com.apple.TextEdit PlainTextEncodingForWrite -int 4

###############################################################################
# Disk Utility                                                                #
###############################################################################

# Enable the debug menu in Disk Utility
defaults write com.apple.DiskUtility DUDebugMenuEnabled -bool true
defaults write com.apple.DiskUtility advanced-image-options -bool true

###############################################################################
# Mac App Store                                                               #
###############################################################################

# Enable the WebKit Developer Tools in the Mac App Store
defaults write com.apple.appstore WebKitDeveloperExtras -bool true

# Enable Debug Menu in the Mac App Store
defaults write com.apple.appstore ShowDebugMenu -bool true

# Enable the automatic update check
defaults write com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true

# Check for software updates daily, not just once per week
defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1

# Install System data files & security updates
defaults write com.apple.SoftwareUpdate CriticalUpdateInstall -int 1

# Allow the App Store to reboot machine on macOS updates
defaults write com.apple.commerce AutoUpdateRestartRequired -bool true

###############################################################################
# Photos                                                                      #
###############################################################################

# Prevent Photos from opening automatically when devices are plugged in
defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true