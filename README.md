# 🚀 Reusable Deployment Workflow

A reusable GitHub Actions workflow to deploy an application to a remote Raspberry Pi (or other host) over **Tailscale + SSH**.

---

## ⚙️ Usage

Call this workflow from another workflow like this:

```yaml
jobs:
  deploy:
    uses: your-org/your-repo/.github/workflows/deploy.yml@main
    with:
      app-name: "my-app"
      startup-cmd: "docker compose up -d"
      branch: "main"
    secrets:
      TAILSCALE_OAUTH_CLIENT_ID: ${{ secrets.TAILSCALE_OAUTH_CLIENT_ID }}
      TAILSCALE_OAUTH_SECRET: ${{ secrets.TAILSCALE_OAUTH_SECRET }}
      HOST_USER: ${{ secrets.HOST_USER }}
```

---

## 🔧 Inputs

| Name          | Required | Default | Description                                                          |
| ------------- | -------- | ------- | -------------------------------------------------------------------- |
| `app-name`    | ✅        | —       | Name of the app to deploy.                                           |
| `startup-cmd` | ✅        | —       | Command to start the app (e.g. `npm start`, `docker compose up -d`). |
| `branch`      | ❌        | `main`  | Branch to deploy from.                                               |

---

## 🔐 Secrets

| Name                        | Required | Description                      |
| --------------------------- | -------- | -------------------------------- |
| `TAILSCALE_OAUTH_CLIENT_ID` | ✅        | Tailscale OAuth client ID.       |
| `TAILSCALE_OAUTH_SECRET`    | ✅        | Tailscale OAuth secret.          |
| `HOST_USER`                 | ✅        | SSH username on the remote host. |

---

## 🧱 What It Does

1. **Checkout** the repository.
2. **Connect to Tailscale** using OAuth credentials.
3. **Run** the remote deploy script via SSH:

   ```bash
   bash -s -- < scripts/deploy.sh <app-name> "<startup-cmd>"
   ```

---

## 📋 Requirements

* The host (e.g. `raspberrypi`) is reachable via Tailscale.
* `scripts/deploy.sh` exists in the repository.
* The SSH user has permission to deploy and restart the app.

---
