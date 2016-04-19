# PhoenixFacebookMessenger
[![Build Status](https://travis-ci.org/oarrabi/phoenix_facebook_messenger.svg?branch=master)](https://travis-ci.org/oarrabi/phoenix_facebook_messenger)
[![Hex.pm](https://img.shields.io/hexpm/v/phoenix_facebook_messenger.svg)](https://hex.pm/packages/phoenix_facebook_messenger)
[![API Docs](https://img.shields.io/badge/api-docs-yellow.svg?style=flat)](http://hexdocs.pm/phoenix_facebook_messenger/)
[![Coverage Status](https://coveralls.io/repos/github/oarrabi/phoenix_facebook_messenger/badge.svg?branch=master)](https://coveralls.io/github/oarrabi/phoenix_facebook_messenger?branch=master)
[![Inline docs](http://inch-ci.org/github/oarrabi/phoenix-facebook-messenger.svg?branch=master)](http://inch-ci.org/github/oarrabi/phoenix-facebook-messenger)

Phoenix Facebook Messenger is a library that easy the creation of facebook messenger bots.

## Installation

```
def deps do
  [{:phoenix_facebook_messenger, "~> 0.2.0"}]
end
```

## Requirements
- a Phoenix App with phoenix `1.1` and up

## Usage
You need to have a working phoenix app to use `phoenix_facebook_messenger`.

To create an echo back bot, do the following:

Create a new controller `web/controller/test_controller.ex`

```
defmodule TestController do
  use FacebookMessenger.Phoenix.Controller

  def message_received(msg) do
    text = FacebookMessenger.Response.message_texts(msg) |> hd
    sender = FacebookMessenger.Response.message_senders(msg) |> hd
    FacebookMessenger.Sender.send(sender, text)
  end
end
```

Add the required routes in `web/router.ex`
```
defmodule YourApp.Router do
  use YourApp.Web, :router

  # Add these two lines
  use FacebookMessenger.Phoenix.Router
  facebook_routes "/api/webhook", TestController
end
```
This defines a webhook endpoint at:
`http://your-app-url/api/webhook`

Go to your `config/config.exs` and add the required configurations
```
config :facebook_messenger,
      facebook_page_token: "Your facebook page token",
      challenge_verification_token: "the challenge verify token"
```

To get the `facebook_page_token` and `challenge_verification_token` follow the instructions [here ](https://developers.facebook.com/docs/messenger-platform/quickstart)

For the webhook endpoint use `http://your-app-url/api/webhook`

## Sample
A sample facebook chat echo bot can be found [here](https://github.com/oarrabi/elixir-echo-bot).
