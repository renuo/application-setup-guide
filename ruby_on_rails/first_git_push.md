# Push to Git Repository

By now `rails new` has already initialised the local git repository and created an initial commit for you. This step pushes that commit to the GitHub repository you created in the [previous step](../create_git_repository.md).

If you used `hub create -p renuo/[project-name]`, the `origin` remote is already set. Otherwise, add it:

```sh
git remote add origin git@github.com:renuo/[project-name].git
```

Then push:

```sh
git push -u origin main
```
