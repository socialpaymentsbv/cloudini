defmodule Cloudini.Multipart do
  @moduledoc """
  Renders fields and files with proper boundaries
  """
  def render(fields, files) do
    boundary = generate_boundary()

    field_parts =
      fields
      |> Enum.map(&add_field_boundary(boundary, &1))
      |> List.flatten()

    file_parts =
      files
      |> Enum.map(&add_file_boundary(boundary, &1))
      |> List.flatten()

    ending_parts = ["--" <> boundary <> "--", ""]

    body =
      [field_parts, file_parts, ending_parts]
      |> List.flatten()
      |> Enum.join("\r\n")

    {boundary, body}
  end

  defp add_field_boundary(boundary, {name, content}) do
    ["--" <> boundary,
     "Content-Disposition: form-data; name=\"#{name}\"",
     "",
     content]
  end

  defp add_file_boundary(boundary, {name, file_name, data}) do
    ["--" <> boundary,
     "Content-Disposition: form-data; name=\"#{name}\"; filename=\"#{file_name}\"",
     "Content-Type: application/octet-stream",
     "",
     data]
  end

  defp generate_boundary do
    "------------BOUNDARY#{random_string(64)}"
  end

  def random_string(length) do
    :crypto.strong_rand_bytes(length)
    |> Base.url_encode64
    |> binary_part(0, length)
  end
end
