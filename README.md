[![Build Status](https://travis-ci.org/codedge-llc/mapi.svg?branch=master)](https://travis-ci.org/codedge-llc/mapi)
[![Coverage Status](https://coveralls.io/repos/github/codedge-llc/mapi/badge.svg)](https://coveralls.io/github/codedge-llc/mapi)
[![Hex.pm](http://img.shields.io/hexpm/v/mapi.svg)](https://hex.pm/packages/mapi)

# mapi
Turn your Elixir module into an HTTP microservice API

Very much a work in progress.

## Installation

1. Add `mapi` to your list of dependencies in `mix.exs`:

  ```elixir
  def deps do
    [
      {:mapi, "~> 0.2.0"}
    ]
  end
  ```

2. Configure your endpoints in `config.exs`

  ```elixir
  config :mapi, endpoints: [
    {YourModule, [port: 4002]}
  ]
  ```

## Usage

Set up an example server for the `String` module with JSON responses.

  ```elixir
  # config.exs
  config :mapi, endpoints: [
    {String, [port: 4002, type: :json]}
  ]
  ```

Once configured, call your server as if you were calling the function.

  ```bash
  $ curl localhost:4002/upcase?q1="testing"
  "TESTING"
  ```

URL params are applied to the function in alphabetical order without respect
to the parameter names themselves. Use parameter names such as `q1, q2, ...`.
Parameters are strings, but will be cast to integers, atoms, and booleans if
applicable. All other types are not yet supported.

Currently only `GET` requests are supported.

## Responses

Mapi currently supports the following response types:

  * Plaintext
  * JSON
  * Erlang ETF

Configure them with a `:type` option of either `:text`, `:json`, or `:etf`,
respectively. If not specified, Mapi will default to plaintext.

All valid requests give a response of `200` status. Invalid paths will
return `404`. Valid paths with an incorrect number of parameters will return
`400`, and all other errors will return `500`.

## Roadmap TODO

* Configurable support for HTTP methods other than `GET`
* Body parameter decoding (for non-GET requests)
* Configurable endpoint webserver
* Support for nested paths, custom routing, etc
