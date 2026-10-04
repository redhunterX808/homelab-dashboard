# Development

## Environment

Development is performed inside Ubuntu WSL2.

Projects should be stored in the Linux filesystem:

~/projects/

Avoid developing from /mnt/c or /mnt/d.

## Workflow

1. Update main:

   git checkout main
   git pull

2. Create a branch:

   git checkout -b feature/<name>

3. Develop and test.

4. Run:

   ./scripts/validate.sh

5. Commit:

   git add .
   git commit -m "<type>: <description>"

6. Push:

   git push -u origin HEAD

7. Create a Pull Request.

Direct development on main is not allowed.
