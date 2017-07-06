defmodule Cloudini do
  alias Cloudini.ClientAPI

  import Cloudini.Metrics, only: [with_metrics: 1]

  @default_base "https://api.cloudinary.com/v1_1"
  @default_base_fetch "https://res.cloudinary.com"

  def new(base, base_fetch, name, key, secret, opts \\ []) do
    stub_requests = Keyword.get(opts, :stub_requests, false)
    http_options = Keyword.get(opts, :http_options, [])

    case stub_requests do
      true -> %Cloudini.StubClient{base_fetch: @default_base_fetch}
      _ -> %Cloudini.HttpcClient{base: base, base_fetch: base_fetch,
                                name: name, key: key, secret: secret,
                                http_options: http_options}
    end
  end

  def new do
    with base = Application.get_env(:cloudini, :base_uri, @default_base),
         base_fetch = Application.get_env(:cloudini, :base_fetch, @default_base_fetch),
         http_options = Application.get_env(:cloudini, :http_options, []),
         name = Application.fetch_env!(:cloudini, :name),
         key = Application.fetch_env!(:cloudini, :api_key),
         secret = Application.fetch_env!(:cloudini, :api_secret),
         stub_requests = Application.fetch_env!(:cloudini, :stub_requests),
      do: new(base, base_fetch, name, key, secret,
            stub_requests: stub_requests,
            http_options: http_options,
          )
  end

  def fetch_url(client, url) do
    Cloudini.URL.fetch(client, url)
  end

  def transform_url(client, image_url, opts \\ []) do
    Cloudini.URL.transform(client, image_url, opts)
  end

  def generate_transformation_string(opts \\ []) do
    Cloudini.URL.generate_transformation_string(opts)
  end

  def version(client) do
    with_metrics do
      ClientAPI.version(client)
    end
  end

  def upload_image(client, path, opts \\ []) do
    with_metrics do
      ClientAPI.upload_image(client, path, opts)
    end
  end

  def delete_image(client, public_id, opts \\ []) do
    with_metrics do
      ClientAPI.delete_image(client, public_id, opts)
    end
  end
end
