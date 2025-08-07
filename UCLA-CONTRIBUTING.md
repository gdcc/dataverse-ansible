
# Contributing to UCLA's Dataverse-Ansible Fork

Welcome! This repository customizes the [gdcc/dataverse-ansible](https://github.com/gdcc/dataverse-ansible) project to support UCLA Library’s Dataverse deployment. This document outlines our Git workflow and how to contribute changes.

---

## 🛠 Local Workflow

We use a **feature branch workflow**, with the `develop` branch as our integration branch. Most contributions follow this cycle:

### 1. Create a New Feature or Fix Branch

Use a descriptive name, prefixed by the type of change:

```bash
git checkout -b feature/enable-shib
````

Use `fix/` for bug fixes and `feature/` for enhancements.

### 2. Make and Commit Your Changes

Keep commits focused and relevant. Test as you go.

```bash
git add group_vars/molecule.yml
git commit -m "Enable Shibboleth settings in molecule.yml"
```

If your change addresses a previously discussed issue, mention it in the message.

### 3. Merge Back into `develop`

When you're ready to integrate:

```bash
git checkout develop
git merge feature/enable-shib
git push origin develop
```

Avoid long-running branches. Merge frequently to keep things clean.

---

## 🔁 Syncing and Rebasing

If `develop` moves forward while you're working:

```bash
git checkout feature/your-branch
git fetch origin
git rebase origin/develop
```

Then resolve any conflicts and continue working.

---

## 🧪 Molecule Testing

Most tests are run locally using Molecule with Docker:

```bash
molecule test
```

For iterative changes:

```bash
molecule converge
```

Vars for Molecule are stored in `group_vars/molecule.yml` using a **flat structure** (e.g., `dataverse_hostname`, not nested keys).

---

## 🧾 Notes and Practices

* `develop` is our working branch. We don't commit directly to `main` at this time.
* Keep commits atomic and reversible.
* Don’t commit secrets. Use fake passwords (`admin1`, `dvnsecret`) in shared vars.
* Document major changes inline with comments or markdown notes where appropriate.


If in doubt, check the existing branches or reach out to Tim.
