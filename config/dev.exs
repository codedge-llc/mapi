use Mix.Config

config :mapi,
  endpoints: [
    {String, [port: 4002, type: :json]},
    {Enum, [port: 4003, type: :json]},
    {String, [port: 4004, type: :etf]},
    {String, [port: 4005]}
  ]
