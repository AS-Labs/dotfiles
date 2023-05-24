# My Dots and scripts


Currently working on vfio helper script for Pop_OS

## gitclones-user.sh
### Installation

To use this code, follow the instructions below:

* Clone the repository or download the script file.
* Ensure that you have the necessary dependencies installed. This script requires curl and git to be installed on your system.
* Open a terminal or command prompt and navigate to the directory where the script is located.
* Run the script using the following command:

```bash
./gitclones-user.sh <username>
```

Replace <username> with the GitHub username for which you want to clone the repositories.

* The script will prompt you to enter the username if it is not provided as an argument. Enter the username and press Enter.
* The script will then retrieve a list of repositories associated with the provided username from the GitHub API and save it to a file named repos_<username>.json.
* It will extract the SSH URLs of the repositories from the JSON file and save them to a file named clones_<username>.json.
* The script will then proceed to clone each repository by iterating over the SSH URLs and using the git clone command.
* Once the cloning process is complete, the script will perform cleanup by deleting the JSON files created during the process.
* Finally, the script will display a "Done" message to indicate the completion of the process.

Please note that you should have appropriate permissions and access rights to clone the repositories associated with the provided username.

### Contributing

Contributions to this script are welcome. Feel free to open a pull request with any suggested changes or additions.
# License

This script is licensed under the GPLv2 License.
