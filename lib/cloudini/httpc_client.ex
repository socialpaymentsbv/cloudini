defmodule Cloudini.HttpcClient do
  defstruct(
    base: nil,
    base_fetch: nil,
    name: nil,
    key: nil,
    secret: nil,
    http_options: []
  )
end

defimpl Cloudini.ClientAPI, for: Cloudini.HttpcClient do
  alias Cloudini.Signature

  @options [timeout: 3000, connect_timeout: 30000]

  def version(_) do
    {:ok, "1.1"}
  end

  def upload_image(client, path, opts \\ []) do
    {:ok, data} = :file.read_file(path)
    name = :filename.basename(path)
    opts = [{:files, [{:file, name, data}]} | opts]

    request(client, :post, "/image/upload", opts)
  end

  def delete_image(client, public_id, opts \\ []) do
    opts = [{:public_id, public_id} | opts]

    request(client, :post, "/image/destroy", opts)
  end

  defp request(%{key: key,
                 secret: secret,
                 http_options: http_options} = client, method, path, params) do
    options = Keyword.merge(@options, http_options)
    uri = build_uri(client, path)

    {boundary, body} =
      params
      |> Signature.sign(key, secret)
      |> render_multipart()

    content_type =
      :erlang.binary_to_list("multipart/form-data; boundary=" <> boundary)

    headers = [{'Content-Length', '#{byte_size(body)}'}]

    response = :httpc.request(
      method,
      {uri, headers, content_type, body},
      options,
      body_format: :binary
    )

    sanitize_response(response)
  end

  defp build_uri(%{base: base, name: name}, path) do
    to_char_list(base) ++ '/' ++ to_char_list(name) ++ to_char_list(path)
  end

  defp render_multipart(params) do
    fields = Keyword.drop(params, [:files])
    files = Keyword.get(params, :files, [])

    Cloudini.Multipart.render(fields, files)
  end

  defp sanitize_response(response) do
    case response do
      {:ok, {{_httpvs, 200, _status_phrase}, json_body}} ->
        {:ok, Poison.decode!(json_body)}
      {:ok, {{_httpvs, 200, _status_phrase}, _headers, json_body}} ->
        {:ok, Poison.decode!(json_body)}
      {:ok, {{_httpvs, 201, _status_phrase}, json_body}} ->
        {:ok, Poison.decode!(json_body)}
      {:ok, {{_httpvs, 201, _status_phrase}, _headers, json_body}} ->
        {:ok, Poison.decode!(json_body)}
      {:ok, {{_httpvs, status, _status_phrase}, json_body}} ->
        {:error, {status, maybe_json_decode(json_body)}}
      {:ok, {{_httpvs, status, _status_phrase}, _headers, json_body}} ->
        {:error, {status, maybe_json_decode(json_body)}}
      {:error, reason} ->
        {:error, {:bad_fetch, reason}}
    end
  end

  defp maybe_json_decode(payload) do
    result = Poison.decode(payload)
    case result do
      {:ok, json_payload} -> json_payload
      _ -> payload
    end
  end
end
