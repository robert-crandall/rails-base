# README

A vanilla Rails 7 setup with some additional settings:

- Postgres as the DB
- Sorbet for type checking
- A dockerfile geared towards Kubernetes
- A ready to go GitHub actions for uploading to GHCR

## New Project

- Copy `.env.example` to `.env`
- Use `direnv allow` to allow local development
- Copy `publish.yml.example` to `.github/workflows/publish.yml` and modify `hello-world` to the app name
## Building docker image

```
docker build -t hello-world .

docker run -d \
  --name hello-world \
  -p 3000:3000 \
  -e SECRET_KEY_BASE={$SECRET_KEY_BASE} \
  -e POSTGRES_HOST={$POSTGRES_HOST} \
  -e POSTGRES_USER={$POSTGRES_USER} \
  -e POSTGRES_PASSWORD={$POSTGRES_PASSWORD} \
  -e DATABASE={$DATABASE} \
  hello-world
```
