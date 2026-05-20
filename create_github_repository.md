# Create a GitHub Repository

At Renuo we currently use [GitHub](https://github.com/) as our git repository. You should already be part of the Renuo Organisation and have permissions to do so.
If that's not the case, double check the Laptop Setup Guide or ask wg-operations.

To create a new GitHub project you can use the tool you prefer, but it should have the following characteristics:
* Should be under `renuo` organisation
* Should have `[project-name]` as a name
* Should be private (unless you are creating an OpenSource project)

Use the command `gh repo create renuo/[project-name] --private --source=. --remote=origin` to create the repo and add it to the origin of the current folder.

## Public repos need a license

If your repository is public, ensure that it contains a license.
We usually use the [MIT](https://choosealicense.com/licenses/mit/) license if possible or a [CreativeCommons](https://creativecommons.org/licenses/) license for documentation-only repositories (such as the application setup guide 🙂).
You can add a license directly on GitHub while initializing a repository by selecting a license template in the "Add a license" dropdown.
However, if the repository is already initialized, you're still able to add a license using a template:
* Click `Create new file`
* Use `LICENSE` for the filename
* Then click on `Choose a license template` and select the MIT license
* Fill in Renuo AG in the full name placeholder
* Click submit and commit the file
