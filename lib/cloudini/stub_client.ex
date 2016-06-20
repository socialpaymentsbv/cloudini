defmodule Cloudini.StubClient do
  defstruct stub_requests: true
end

defimpl Cloudini.ClientAPI, for: Cloudini.StubClient do
  require Logger

  def version(_) do
    {:ok, "1.1-stub"}
  end

  def upload_image(_, path, opts \\ []) do
    Logger.warn "[CLOUDINI-STUB] Uploading file from #{path} with opts #{opts}"
  end

  def delete_image(_, public_id, opts \\ []) do
    Logger.warn "[CLOUDINI-STUB] Deleting file with public ID #{public_id} with opts #{opts}"
  end
end
