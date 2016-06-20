# Cloudini

Wrapper client library for [Cloudinary API](http://cloudinary.com).

For the time being, only image upload and deletion are supported.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add cloudini to your list of dependencies in `mix.exs`:

        def deps do
          [{:cloudini, "https://github.com/socialpaymentsbv/cloudini.git"}]
        end

  2. Configure cloudini in `config/config.exs`:

        config :cloudini,
          name: "CLOUDINARYNAME",
          api_key: "APIKEY",
          api_secret: "APISECRET"

## Usage

Basic Cloudindary API usage:

    client = Cloudini.new

    Cloudini.upload_image(client, "fixture/upload/test.gif", public_id: "image_id")
    # {:ok, %{"public_id" => "image_id", ...}}
    
    Cloudini.delete_image(client, "image_id")
    # {:ok, %{"result" => "ok"}}

Helpers for building URLs:

  * `fetch_url(client, "http://picture.from.internet.to.be.fetch.by.cloudinary.gif")`
  * `transform_url(client, "http://res.cloudinary.com/...", mode: "fill", width: 200)`
