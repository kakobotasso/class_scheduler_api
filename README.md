[![Build Status](https://travis-ci.org/kakobotasso/class_scheduler_api.svg?branch=master)](https://travis-ci.org/kakobotasso/class_scheduler_api)

# Class Scheduler API

This API is made to study Dart and Aqueduct. When we done here, we'll create a Flutter app to use it.


## Running the Application Locally

### Database

We're using Postgres and PgAdmin to manage our database.

* Run `docker-compose up -d`;
* Open `http://localhost:16543`
    * `teste@teste.com`
    * `123456`
* Create a server with:
    * Hostname: `teste-postgres-compose`
    * User: `postgres`
    * Password: `Postgres2020!`
* Create two databases called `class_scheduler` for our application and `dart_test` for tests;
* Run the scripts from `initial_scripts.sql` on the right database.

### Application

We already have an `database.yaml` with our database configuration.

* Run `aqueduct db upgrade` to run the migrations on database;
* Run `aqueduct auth add-client --id br.com.class_scheduler_api` to generate OAuth client key;
* Run `aqueduct serve` to start the application on `localhost:8888`.

To generate a SwaggerUI client, run `aqueduct document client`. It'll generate a file called `client.html` that can be opened on the browser.

## Running Application Tests

To run all tests for this application, run the following in this directory:

```
pub run test
```