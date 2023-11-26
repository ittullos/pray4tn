# pray4tn

## Development

### Installation

You need Bundler installed, then simply run:
`bundler install`
Next, copy `.env.example` to `.env` and update your values accordingly as you go.

This application uses a PostgreSQL database. It assumes you are currently
running Postgres on the default port of 5432.

Postgres.app is a great tool for managing PG locally, and it works nicely with
the database client "Postico".

https://postgresapp.com/


### Set up the Database

In your terminal, use Rake to create the development and test databases:
`bundle exec rake db:create`

### Running migrations

We're using ActiveRecord, so you can run and rollback migrations in the standard way:

```bash
$ be rake db:migrate

$ be rake db:rollback
```

### Running the app

The app runs on `http://localhost:9292` by default.
Run it on port 8000 using:
`bundle exec rackup -p 8000`
