defmodule CloudiniTest do
  use ExUnit.Case
  use ExVCR.Mock, adapter: ExVCR.Adapter.Httpc

  @sample_cloudinary_url "https://res.cloudinary.com/dc1obyxe2/image/upload/v1455616309/fa9293cb-2852-44f5-be72-bb7bcc8f155a.gif"
  @sample_cloudinary_pdf_url "https://res.cloudinary.com/clubbase-test/raw/upload/v1467299479/4c51acc7-69dc-47c5-bca8-3ba08d72a39c_1467299474649.pdf"
  @sample_cloudinary_fetch "https://res.cloudinary.com/demo/image/fetch/https://img.youtube.com/vi/mmW0v7GBNJw/default.jpg"

  @valid_trans_opts %{"width" => "300", "height" => "600", "dpr" => "2",
                      "mode" => "crop", "gravity" => "face"}
  @valid_cloudinary_opts ["w_300", "h_600", "dpr_2.0", "c_crop", "g_face"]

  setup do
    client = Cloudini.new(
      "https://api.cloudinary.com/v1_1",
      "https://res.cloudinary.com",
      "cloudini-test",
      "727468625589788",
      "MGrVnOPp6Cce1VBPaAwb94hVP0o"
    )

    {:ok, client: client}
  end

  ### URL functions

  test "generates valid cloudinary fetch URL", context do
    url = Cloudini.fetch_url(context.client, "http://example.com/image.jpeg")

    assert String.starts_with?(url, "https://res.cloudinary.com/")
    assert String.contains?(url, "/image/fetch/")
    assert String.ends_with?(url, "http://example.com/image.jpeg")
  end

  test "generates valid cloudinary transformation API URL from opts", context do
    url = Cloudini.transform_url(context.client, @sample_cloudinary_url, @valid_trans_opts)
    cloudinary_opts = extract_cloudinary_opts(url)
    assert cloudinary_opts == Enum.sort(@valid_cloudinary_opts)
  end

  test "generates valid cloudinary transformation API URL from opts when image is a PDF", context do
    url = Cloudini.transform_url(context.client, @sample_cloudinary_pdf_url, @valid_trans_opts)
    cloudinary_opts = extract_cloudinary_opts(url)
    assert cloudinary_opts == Enum.sort(@valid_cloudinary_opts)
  end

  test "generates valid cloudinary transformation API URL from empty opts", context do
    url = Cloudini.transform_url(context.client, @sample_cloudinary_url, %{"some_garbage" => "1"})
    assert url == @sample_cloudinary_url
  end

  test "generates valid cloudinary transformation from a remotely fetched image", context do
    url = Cloudini.transform_url(context.client, @sample_cloudinary_fetch, @valid_trans_opts)
    cloudinary_opts = extract_cloudinary_opts(url)
    assert cloudinary_opts == Enum.sort(@valid_cloudinary_opts)
  end

  ### API functions

  test "uploads a a valid picture to cloudinary", context do
    use_cassette "cloudinary_successful_upload" do
      {:ok, result} = Cloudini.upload_image(context.client, "fixture/upload/test.gif",
        public_id: "a_test_image")

      assert %{"bytes" => _,
               "public_id" => "a_test_image",
               "width" => _,
               "height" => _,
               "type" => "upload",
               "url" => _
      } = result
    end
  end

  test "rejects invalid picture being uploaded", context do
    use_cassette "cloudinary_invalid_image" do
      {:error, {status, result}} = Cloudini.upload_image(context.client,
        "fixture/upload/not-an-image.gif",
        public_id: "invalid_test_image")

      assert status == 400
      assert %{"error" => %{"message" => _}} = result
    end
  end

  test "removes existing picture", context do
    use_cassette "cloudinary_remove_existing_image" do
      {:ok, _} = Cloudini.upload_image(context.client, "fixture/upload/test.gif",
        public_id: "test_image_for_removal")

      {:ok, result} = Cloudini.delete_image(context.client, "test_image_for_removal")

      assert %{"result" => "ok"} = result
    end
  end

  test "removal of non-existing picture does not crash", context do
    use_cassette "cloudinary_remove_non_existing_image" do
      {:ok, result} = Cloudini.delete_image(context.client, "non_existent_picture")

      assert %{"result" => "not found"} = result
    end
  end

  ### Helpers

  defp extract_cloudinary_opts(url) do
    parsed = URI.parse(url)
    parsed.path
    |> String.split("/")
    |> Enum.fetch!(4)
    |> String.split(",")
    |> Enum.sort
  end
end
