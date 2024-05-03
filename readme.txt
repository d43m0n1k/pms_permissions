# Plex Media Permissions Script

This script automates the process of setting file and folder permissions for your Plex Media Server. It offers three modes: Baseline, Edit, and Lockdown, each serving different needs depending on your security and accessibility requirements.

## Usage

1. **Clone the Repository**: Clone this repository to your local machine.

    ```bash
    git clone "https://github.com/d43m0n1k/pms_permissions"
    ```

2. **Open the Script**: Navigate to the cloned directory and open the `pmsownfixpublic.sh` script in a text editor.

    ```bash
    cd pms_permissions
    nano pmsownfixpublic.sh
    ```

3. **Edit Media Paths**: In the script, locate the `directories` array and edit it to include the paths of your Plex media directories. These are the directories where your media files are stored.

    ```bash
    directories=(
        "/path/to/your/media/directory1"
        "/path/to/your/media/directory2"
        "/path/to/your/media/directory3"
        # Add more directories as needed
    )
    ```

    Replace `/path/to/your/media/directoryX` with the actual paths of your media directories.

4. **Save and Close**: After editing the paths, save the script and close the text editor.

5. **Make the Script Executable**: Before running the script, you need to make it executable. You can do this using the `chmod` command.

    ```bash
    chmod +x pmsownfixpublic.sh
    ```

6. **Run the Script**: Execute the script and follow the prompts to select the desired mode (Baseline, Edit, or Lockdown) and set the permissions accordingly.

    ```bash
    ./pmsownfixpublic.sh
    ```

## Disclaimer

Please review the permissions settings carefully before applying them. Incorrect permissions may affect the functionality of your Plex Media Server.
