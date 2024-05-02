#!/bin/bash

# ASCII banner
cat << "EOF"
#     _______   ___       _______  ___  ___      ___      ___   _______  ________   __          __            ________  _______   _______  ___      ___  _______   _______
#    |   __ "\ |"  |     /"     "||"  \/"  |    |"  \    /"  | /"     "||"      "\ |" \        /""\          /"       )/"     "| /"      \|"  \    /"  |/"     "| /"      \
#    (. |__) :)||  |    (: ______) \   \  /      \   \  //   |(: ______)(.  ___  :)||  |      /    \        (:   \___/(: ______)|:        |\   \  //  /(: ______)|:        |
#    |:  ____/ |:  |     \/    |    \\  \/       /\\  \/.    | \/    |  |: \   ) |||:  |     /' /\  \        \___  \   \/    |  |_____/   ) \\  \/. ./  \/    |  |_____/   )
#    (|  /      \  |___  // ___)_   /\.  \      |: \.        | // ___)_ (| (___\ |||.  |    //  __'  \        __/  \\  // ___)_  //      /   \.    //   // ___)_  //      /
#   /|__/ \    ( \_|:  \(:      "| /  \   \     |.  \    /:  |(:      "||:       :)/\  |\  /   /  \\  \      /" \   :)(:      "||:  __   \    \\   /   (:      "||:  __   \
#  (_______)    \_______)\_______)|___/\___|    |___|\__/|___| \_______)(________/(__\_|_)(___/    \___)    (_______/  \_______)|__|  \___)    \__/     \_______)|__|  \___)
#                                                                                                                                                   By: d43m0n1k
#
EOF

# Title and description
echo "----------------------------------------"
echo "      Plex Media Permissions Script     "
echo "----------------------------------------"
echo "This script will change file and folder "
echo "permissions for your Plex Media Server, "
echo "based on which option you choose. There "
echo "are 3 choices available for now, as per "
echo "Plex instructions is our Baseline Option" # see "https://support.plex.tv/articles/200288596-linux-permissions-guide/"
echo "Edit mode lets current user take over to"
echo "drag and drop on Linux Desktop. The last"
echo "option is Lockdown, my attempt at making"
echo " the server more secure, without losing "
echo " the ability to serve media. Be safe :) "

sleep 3

# Check if current user is in the plex group
if getent group plex | cut -d':' -f4 | grep -qw "$(whoami)"; then
    echo "Plex member confirmed, moving on.."
else
    # Prompt user to add current user to the plex group
    read -p "Not a plex group member. Do you want to add the current user to the Plex group? (Y/N): " add_user_to_group
    if [[ $add_user_to_group == "Y" || $add_user_to_group == "y" ]]; then
        # Add the current user to the plex group
        sudo usermod -aG plex "$(whoami)"
    fi

fi

sleep 3

# Check if plex user is already in the plex group
if getent group plex | grep -q "\bplex\b"; then
    echo "Confirmed plex user is in the Plex group."
else
    echo "Adding plex user to plex group"
    sudo usermod -aG plex plex
fi

sleep 3

# Define the base directories you want to modify
directories=(
        "/path/to/your/media/directory1"
        "/path/to/your/media/directory2"
        "/path/to/your/media/directory3"
        # Add more directories as needed
    )

# Prompt user for mode selection
read -p "Select mode: (B)aseline, (E)dit, or (L)ockdown: " mode
case "$mode" in
    [Bb]* )
        # Baseline mode: Set default permissions for Plex
        directories_permissions="755"
        files_permissions="644"
        owner="plex"
        group="plex"
        disclaimer="Baseline mode: Default permissions for Plex. Editing permissions may be restricted."
        ;;
    [Ee]* )
        # Edit mode: Allow Plex group members to edit directories
        directories_permissions="775"
        files_permissions="664"
        owner="$(whoami)"
        group="plex"
        disclaimer="Edit mode: Plex group members can edit directories. Exercise caution when making changes."
        ;;
    [Ll]* )
        # Lockdown mode: Restrict editing permissions for all users, including Plex
        directories_permissions="755"
        files_permissions="644"
        owner="root"
        group="root"
        disclaimer="Lockdown mode: Restricted editing permissions for all users, including Plex. Only read access is allowed."
        ;;
    * )
        echo "Invalid mode. Exiting."
        exit 1
        ;;
esac

# Display disclaimer based on mode selected
echo "$disclaimer"

sleep 3

# Uncomment the following lines for debug information
# echo "Current user groups:"
# groups "$(whoami)"
# echo "Mode: $mode"

# Prompt user for confirmation
read -p "Do you want to change permissions for directories and files? (Y/N): " answer
if [[ $answer != "Y" && $answer != "y" ]]; then
    echo "Exiting script."
    exit 0
fi

# Loop through each directory and change ownership,
# directories permissions, and files permissions based on mode
for dir in "${directories[@]}"; do
    echo "Processing directory: $dir"

    # Debug statement to check if the loop is progressing
    echo "Changing ownership of $dir to $owner:$group"

    # Change ownership of directory
    sudo chown -R "$owner:$group" "$dir"

    # Debug statement to check if ownership change is successful
    echo "Setting permissions for directories in $dir to $directories_permissions"

    # Set permissions for directories
    sudo find "$dir" -type d -exec chmod "$directories_permissions" {} +

    # Debug statement to check if directory permissions are set
    echo "Setting permissions for files in $dir to $files_permissions"

    # Set permissions for files
    sudo find "$dir" -type f -exec chmod "$files_permissions" {} +

    # Debug statement to indicate completion of processing
    echo "Finished processing $dir"
done

sleep 3 # Add a delay to allow script to wrap up
echo "Permissions setup successful."
sleep 3   # Add a delay to allow script to wrap up
exit 0
