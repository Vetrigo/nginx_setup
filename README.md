Nginx Setup Script
This script automates the installation and configuration of Nginx along with additional features like virtual hosts, user directories, PAM authentication, and CGI scripting. It checks if Nginx is installed, sets up a virtual host if necessary, and installs the required dependencies. You can also configure specific features using command-line arguments.

Features:
Installs Nginx if not already installed.
Configures a virtual host by asking for the virtual host name if not already set.
Checks and installs dependencies for user directories, PAM authentication, and CGI scripting.
Uses arguments (-u, -a, -c) to configure specific features like user directories, PAM authentication, and CGI.
This script simplifies Nginx setup and ensures all necessary components are configured correctly.

