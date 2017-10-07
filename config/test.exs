use Mix.Config

config :mapi, endpoints: [
    {String, [port: 4002]},
    {Mapi.TestModule, [port: 4003]} 
  ]
