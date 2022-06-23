# GIAS API

This is a tiny API meant to accompany [the GIAS Query Tool](https://github.com/DFE-Digital/gias-query-tool).

It is a proof of concept and prototype. It was intended to be built and deployed to the GOV.UK PAAS on a weekly basis for teams that need GIAS data to consume without having to handle the downloading/importing of the CSV.

The reason we're connecting via the socket is so we can keep the Docker image simple and not need to worry about PostgreSQL accounts when deploying.

## Building

1. ensure [Crystal](https://crystal-lang.org/) is installed
1. install dependencies by running `shards` in the project root
1. build the program with `crystal build src/gias-api.cr`
1. run it with `./gias-api`

## Speed

With no optimisation it's fast out of the box.

```sh
❯ time http get "localhost:3001/schools/100123"

HTTP/1.1 200 OK
Connection: keep-alive
Content-Type: application/json
Transfer-Encoding: chunked

{
    "urn": 100123,
    "name": "Eglinton Junior School"
}



________________________________________________________
Executed in    5.97 millis    fish           external
   usr time    1.08 millis    0.00 micros    1.08 millis
   sys time    3.83 millis  595.00 micros    3.23 millis

```

That's just one school, now with 49,514:

```sh
❯ time http get "localhost:3001/schools" > /tmp/all.json

________________________________________________________
Executed in  303.79 millis    fish           external
   usr time    3.82 millis  694.00 micros    3.12 millis
   sys time   15.48 millis    0.00 micros   15.48 millis
```
