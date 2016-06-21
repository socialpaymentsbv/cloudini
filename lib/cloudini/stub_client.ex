defmodule Cloudini.StubClient do
  defstruct stub_requests: true, base_fetch: "http://example.com/", name: "stub"
end

defimpl Cloudini.ClientAPI, for: Cloudini.StubClient do
  require Logger

  def version(_) do
    {:ok, "1.1-stub"}
  end

  def upload_image(_, path, opts \\ []) do
    public_id = Keyword.get(opts, :public_id, "example_pic")

    Logger.warn "[CLOUDINI-STUB] Uploading file from #{path}"
    {:ok, %{"secure_url" => "https://res.cloudinary.com/demo/image/upload/lady.jpg", "height" => 1000, "width" => 667, public_id: public_id}}
  end

  def delete_image(_, public_id, _opts \\ nil) do
    Logger.warn "[CLOUDINI-STUB] Deleting file with public ID #{public_id}"
    {:ok, %{"result" => "ok"}}
  end
end
