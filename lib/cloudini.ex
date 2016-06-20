defmodule Cloudini do
  alias Cloudini.ClientAPI

  import Cloudini.Metrics, only: [with_metrics: 2]

  @default_base "https://api.cloudinary.com/v1_1"
  @default_base_fetch "https://res.cloudinary.com"

  def new(base, base_fetch, name, key, secret, opts \\ []) do
    stub_requests = Keyword.get(opts, :stub_requests, false)
    http_options = Keyword.get(opts, :http_options, [])

    case stub_requests do
      true -> %Cloudini.StubClient{}
      _ -> %Cloudini.HttpcClient{base: base, base_fetch: base_fetch,
                                name: name, key: key, secret: secret,
                                http_options: http_options}
    end
  end

  def new do
    cloudini_config = Application.get_env(:cloudini)
    with base = Keyword.get(cloudini_config, :base_uri, @default_base),
         base_fetch = Keyword.get(cloudini_config, :base_fetch, @default_base_fetch),
         http_options = Keyword.get(cloudini_config, :http_options, []),
         {:ok, name} <- Keyword.fetch(cloudini_config, :name),
         {:ok, key} <- Keyword.fetch(cloudini_config, :api_key),
         {:ok, secret} <- Keyword.fetch(cloudini_config, :api_secret),
         {:ok, stub_requests} <- Keyword.fetch(cloudini_config, :stub_requests),
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

  def version(client) do
    with_metrics "version" do
      ClientAPI.version(client)
    end
  end

  def upload_image(client, path, opts \\ []) do
    with_metrics "upload_image" do
      ClientAPI.upload_image(client, path, opts)
    end
  end

  def delete_image(client, public_id, opts \\ []) do
    with_metrics "delete_image" do
      ClientAPI.delete_image(client, public_id, opts)
    end
  end
end
