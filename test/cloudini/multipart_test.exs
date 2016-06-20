defmodule Cloudini.MultipartTest do
  use ExUnit.Case
  doctest Cloudini

  alias Cloudini.Multipart

  test "Encodes basic fields without files" do
    {boundary, body} = Multipart.render([field1: "value1", field2: "value2"], [])

    assert String.starts_with?(body, "--" <> boundary)
    assert String.contains?(body, "Content-Disposition: form-data; name=\"field1\"")
    assert String.contains?(body, "value1")
    assert String.contains?(body, "Content-Disposition: form-data; name=\"field2\"")
    assert String.contains?(body, "value2")
  end
end
