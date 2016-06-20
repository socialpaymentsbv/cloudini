defmodule Cloudini.Signature do
  @signed_params ~w(callback eager eager_async format from_public_id public_id
    resource_type tags timestamp to_public_id text transformation type context
    allowed_formats proxy notification_url eager_notification_url backup
    return_delete_token faces exif colors image_metadata phash invalidate
    use_filename unique_filename folder overwrite discard_original_filename
    face_coordinates custom_coordinates raw_convert auto_tagging
    background_removal moderation upload_preset font_family font_size
    font_color font_weight font_style background opacity text_decoration)a

  def sign(params, key, secret) do
    timestamp = :os.system_time
    params = [{:timestamp, timestamp}, {:api_key, key} | params]

    signature =
      params
      |> Keyword.take(@signed_params)
      |> List.keysort(0)
      |> build_query()
      |> hash_signature(secret)
      |> Base.encode16()

    [{:signature, signature} | params]
  end

  defp hash_signature(signature, secret) do
    :crypto.hash(:sha, signature <> secret)
  end

  defp build_query(params) do
    Enum.map_join(params, "&", fn {k, v} -> "#{k}=#{v}" end)
  end
end
