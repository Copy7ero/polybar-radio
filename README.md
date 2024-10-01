
# Radio Module for Polybar

A custom Polybar module for listening to multiple online radio stations with easy controls for switching between stations, pausing, and saving track information.

## Features

- **Multiple Stations**: Easily switch between multiple pre-configured radio stations.
- **Playback Controls**: 
  - Left click: Play/pause the current radio station.
  - Right click: Skip to the next station (stops the current station if playing).
  - Middle click: Save the currently playing track and artist to a file.
- **Customizable Icons**: Displays play/pause icons depending on the playback status.
- **Station Names**: The name of the current radio station is displayed instead of the URL.
- **Automatic Switching**: Switches to the next station if the current one is stopped.

## Dependencies

- **Polybar**: Make sure Polybar is installed and properly configured on your system.
- **mpv**: Used to stream the radio stations. Install it with your package manager:
  ```bash
  sudo apt install mpv  # for Debian/Ubuntu
  sudo pacman -S mpv    # for Arch
  sudo dnf install mpv  # for Fedora
  ```

## Installation

1. **Clone the repository**:
   ```bash
   git clone https://github.com/Copy7ero/polybar-radio.git
   cd polybar-radio
   ```

2. **Configure the stations**:
   - Edit the `radio_stations` array in the `radio_module.sh` script to add your favorite radio stations. The format is:
     ```bash
    "http://your-first-radio-url Radio One"
    "http://your-second-radio-url Radio Two"
    "http://your-third-radio-url Radio Three"
     ```

3. **Add the module to your Polybar config**:
   - Open your Polybar config file (typically `~/.config/polybar/config`) and add the following module:
     ```ini
     [module/radio]
     type = custom/script
     exec = /path/to/radio_module.sh
     interval = 1
     label = %output%
     click-left = /path/to/radio_module.sh toggle
     click-right = /path/to/radio_module.sh next
     click-middle = /path/to/radio_module.sh save
     ```
   - Adjust the paths to the script and ensure that it's executable:
     ```bash
     chmod +x /path/to/radio_module.sh
     ```

4. **Launch Polybar**:
   Reload Polybar or restart it to see the new radio module in action.

## Usage

- **Play/Pause**: Left click on the module to toggle playback.
- **Next Station**: Right click to stop the current station and move to the next.
- **Save Track Info**: Middle click to save the currently playing track's artist and title into a file.

## Customization

- You can customize the icons, station names, and the behavior of the script by modifying the `radio_module.sh` file.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
