

# Minecraft Purpur Server Management Script

This Bash script is designed to simplify the management of a Minecraft server using the Purpur software. It includes functionalities for starting, stopping, restarting, checking the status, and accessing the console of the server.

## Prerequisites

Before using this script, ensure that the following dependencies are installed:

- `screen`: A terminal multiplexer used to run the server in the background.
- `Java`: The Java Runtime Environment (JRE) is required to execute the Minecraft server.

## Getting Started

1. Clone this repository to your local machine:

   ```bash
   git clone https://github.com/your-username/your-repository.git
   cd your-repository
   ```
   or
   ```
   wget https://raw.githubusercontent.com/Sijon20/minecraft-server/main/minecraft-server.sh -O your_script_name.sh
   ```


3. Set the executable permission for the script:

   ```bash
   chmod +x your_script_name.sh
   ```

4. Open the script in a text editor to customize the configuration variables if needed.

5. Run the script with the desired command:

   ```bash
   ./your_script_name.sh start
   ```

## Configuration

- `PURPUR_JAR`: The name of the Purpur JAR file.
- `SERVER_OPTS`: Additional options for the server.
- `SCREEN_NAME`: The name of the screen session used for the server.
- `JAVA_EXECUTABLE`: The path to the Java executable.

## Commands

- `start`: Starts the server in the background using the `screen` command.
- `stop`: Stops the server by killing the screen session.
- `restart`: Restarts the server by stopping and then starting it.
- `status`: Checks if the server is currently running.
- `console`: Attaches to the server console using the `screen` command.

## Error Handling

- The script checks for the presence of `screen` and Java. If not found, it displays an error message and exits.
- If the Purpur JAR file is not found, the script prompts the user to input the Purpur version and build, then attempts to download it using `wget`.

## Additional Information

For more details, please check the `README.md` file included in this repository.

## License

This script is licensed under the [MIT License](LICENSE).

```

Replace placeholders like `your-username`, `your-repository`, and `your_script_name.sh` with your actual GitHub username, repository name, and script filename.

Additionally, you might want to include a license file (e.g., `LICENSE`) and any other relevant documentation specific to your project.
