# Contributing to UCLA's Dataverse-Ansible Fork

Thanks for helping improve our Dataverse Ansible infrastructure! This guide outlines our team’s Git workflow, branch naming conventions, and testing expectations.

## 🔁 Branching Strategy

We use a **feature branch workflow** off `develop`. Avoid direct commits to `main`.

### Branch Prefixes

| Prefix    | Purpose                                                   |
| --------- | --------------------------------------------------------- |
| `config/` | Changes to group\_vars, defaults, environment config      |
| `task/`   | Fixes or updates to role tasks, handlers, templates, etc. |
| `doc/`    | Documentation or markdown (README, usage notes, etc.)     |

### Create a Branch

```
git checkout -b config/molecule-vars
```

Use a short, descriptive suffix after the prefix.

## 🛠 Local Workflow

### 1. Work on Your Branch

Make small, focused commits:

```
git add group_vars/molecule.yml
git commit -m "Add vars for molecule testing"
```

Avoid combining unrelated changes in one commit.

### 2. Test with Molecule

For full tests:

```
molecule test -s rocky9
```

Or iterate with:

```
molecule converge -s rocky9
```



### 3. Push to GitHub

```
git push origin config/molecule-vars
```



### 4. Create a Pull Request

Use GitHub CLI:

```
gh pr create --base develop --fill
```

If you're still working:

```
gh pr create --base develop --draft --fill
```

New commits to the same branch automatically update the PR.

### 5. Merge

After review:

```
git checkout develop
git merge config/molecule-vars
git push origin develop
```

## 🧾 Best Practices

* Keep branches short-lived and narrow in scope.
* Use flat key-value structure in `group_vars/molecule.yml`.
* Do not commit secrets. Use placeholders like `admin1` or `dvnsecret`.
* Add inline comments or notes (`UCLA-CONTRIBUTING.md`) for non-obvious decisions.

For questions, check existing branches or ask Tim.