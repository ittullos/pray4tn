# pray4tn

## Development

### Installation

You need Bundler installed, then simply run:
`bundler install`
Next, copy `.env.example` to `.env` and update your values accordingly as you go.

### Set up the Database

This application uses a PostgreSQL database. It assumes you are running a server
on the default port of 5432 with the name `development-pray4tn`. You can put this and other configuration in the `.env` file.

The app runs on `http://localhost:9292` by default.

### Running migrations

We're using ActiveRecord, so you can run and rollback migrations in the standard way:

```bash
$ be rake db:migrate

$ be rake db:rollback
```
