[![Build Status](https://travis-ci.org/codedge-llc/mapi.svg?branch=master)](https://travis-ci.org/codedge-llc/mapi)
[![Coverage Status](https://coveralls.io/repos/github/codedge-llc/mapi/badge.svg)](https://coveralls.io/github/codedge-llc/mapi)
[![Hex.pm](http://img.shields.io/hexpm/v/mapi.svg)](https://hex.pm/packages/mapi)

# Mapi
Map your Elixir module to a microservice API

Very much a work in progress.

## Installation

  1. Add `mapi` to your list of dependencies in `mix.exs`:

  ```elixir
  def deps do
    [
      {:mapi, "~> 0.1.0"}
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

  Set up an example server for the `String` module.
  ```elixir
  # config.exs
  config :mapi, endpoints: [
    {String, [port: 4002]}
  ]
  ```

  Once configured, call your server as if you were calling the function.
  ```bash
  $ curl localhost:4002/upcase?q1="testing"
  "TESTING"
  ```

  URL params are applied to the function in alphabetical order without respect
  to the parameter names themselves. Use parameter names such as `q1, q2, ...`.
  Parameter values are strings, so your module will need to cast accordingly.
  Currently only `GET` requests are supported.

  Your module's function must return a response that is [Poison](https://github.com/devinus/poison) encodable.
  All responses are JSON with a `200` status unless a function is not defined,
  in which case it will return `404` with a `{"error": "not_found"}` body.

## Roadmap TODO

  * Configurable support for HTTP methods other than `GET`
  * Body parameter decoding (for non-GET requests)
  * Configurable endpoint webserver
  * Configurable response type (Plaintext, XML, ETF, etc.)
  * Support for nested paths, custom routing, etc
