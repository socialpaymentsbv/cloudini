# Cloudini

Wrapper client library for [Cloudinary API](http://cloudinary.com).

For the time being, only image upload and deletion are supported.

## Installation

The package can be installed in a following steps:

  1. Add `cloudini` to your list of dependencies in `mix.exs`:

        def deps do
          [{:cloudini, "~> 1.0"}]
        end

  2. Ensure `cloudini` is started before your application:

   ```elixir
   def application do
      [applications: [:cloudini]]
   end
   ```

  3. Configure cloudini in `config/config.exs`:

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

  * `fetch_url(client, "http://picture.from.internet.to.fetch.by.cloudinary.gif")`
  * `transform_url(client, "http://res.cloudinary.com/...", mode: "fill", width: 200)`
