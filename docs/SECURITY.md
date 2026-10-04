# Security

## Secrets

Never commit:

- passwords
- API keys
- access tokens
- private SSH keys
- .env files containing secrets

Use environment variables or an approved secret management mechanism.

## Repository protection

The main branch is protected.

Changes must pass:

- pre-commit
- CI validation
- Gitleaks

before merge.

## Production

Production servers must not be used for development.

Deployments are performed from the protected main branch.

Do not modify application source code directly on the production server.
