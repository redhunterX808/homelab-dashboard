# Deployment

## Architecture

Deployment uses a pull-based model.

GitHub is the source of truth.

Production servers periodically check the protected main branch for new commits.

Flow:

Developer
  -> Pull Request
  -> CI
  -> protected main
  -> production fetch
  -> validation
  -> build
  -> deploy
  -> healthcheck

If the healthcheck fails, the previous working commit must be restored.

## Production rules

Do not:

- edit application files directly on the server
- commit from the production server
- force-push production branches
- store credentials in the repository

Production repositories must remain clean.

Check with:

git status
