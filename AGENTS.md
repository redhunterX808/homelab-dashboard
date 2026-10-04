# Development Guidelines

## General

- Keep the application portable and reproducible.
- Prefer simple solutions over unnecessary dependencies.
- Follow the existing project architecture.
- Document significant architectural decisions.

## Development

- Run tests after relevant changes.
- Run linting and formatting when configured.
- Do not commit generated artifacts unless required.
- Do not make Git commits unless explicitly requested.
- Do not push to remote repositories unless explicitly requested.

## Docker

- Prefer Docker Compose for local orchestration.
- Use official or trusted base images.
- Pin important dependency versions where appropriate.
- Avoid running application containers as root when practical.
- Use healthchecks for long-running services when useful.
- Keep persistent data outside application containers.

## Security

- Never commit secrets.
- Never put real credentials in .env.example.
- Never expose private keys.
- Never print credentials or tokens to logs.
- Treat .env files as sensitive.

## Production

- Do not perform production deployments unless explicitly requested.
- Do not remove production containers or volumes without explicit approval.
- Do not execute destructive Docker commands without explicit approval.


# Agent Instructions

## Environment

This project is developed in Ubuntu WSL2.

## Git

- Never work directly on main.
- Create a branch for every change.
- Do not force push.
- Do not bypass pre-commit hooks.
- Do not commit secrets.

## Validation

Before considering a task complete, run:

./scripts/validate.sh

All validation steps must pass.

## Docker

Validate Compose with:

docker compose config --quiet

Do not modify production infrastructure directly.

## Security

Never place credentials, tokens, passwords, private keys, or production secrets in source code.

Do not disable security checks to make CI pass.

If a security check fails, identify and correct the underlying cause.

## Scope

Make the smallest change necessary to complete the requested task.

Avoid unrelated refactoring unless explicitly requested.
