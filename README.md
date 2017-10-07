# Mapi
Map your Elixir module to a microservice API

Very much a work in progress.

## Installation

  1. Add `mapi` to your list of dependencies in `mix.exs`:

  ```elixir
  def deps do
    [{:mapi, "~> 0.1.0"}]
  end
  ```

  2. Configure your endpoints in `config.exs`

  ```elixir
  config :mapi, endpoints: [
    {YourModule, [port: 4002]}
  ]

## Usage

  Once configured, call your server as if you were calling the function.

  ```elixir
  # config.exs
  config :mapi, endpoints: [
    {String, [port: 4002]}
  ]
  ```

  ```bash
  $ curl localhost:4002/upcase?q1="testing"
  "TESTING"
  ```

  URL params are applied to the function in alphabetical order without respect
  to the parameter names themselves. Use parameter names such as `q1, q2, ...`
  Currently only `GET` requests are supported.

  Your module's function must return a response that is `Poison` encodable.
  All responses are JSON with a `200` status unless a function is not defined,
  in which case it will return `404` with a `{"error": "not_found"}` body.

## Roadmap

  * Configurable support for HTTP methods other than `GET`
  * Body parameter decoding (for non-GET requests)
  * Configurable response type (Plaintext, ETF, etc.)
