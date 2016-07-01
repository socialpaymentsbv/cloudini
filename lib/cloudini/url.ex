defmodule Cloudini.URL do
  def fetch(%{base_fetch: base_fetch, name: name}, url) do
    "#{base_fetch}/#{name}/image/fetch/#{url}"
  end

  def transform(_, image_url, trans_opts)
  when is_list(trans_opts) or is_map(trans_opts) do
    uri = URI.parse(image_url)
    path_elements = uri.path |> String.split("/", parts: 5)

    case path_elements do
      [_head, _name, type, op, _rest]
        when op in ["upload", "fetch"]
        and type in ["raw", "image"] ->
          path_elements
          |> do_transform(uri, image_url, trans_opts)
    end
  end

  defp do_transform([head, name, _, op, rest], uri, image_url, trans_opts) do
    trans_opts = generate_transformation_string(trans_opts)
    if trans_opts != "" do
      new_path =
        [head, name, "image", op, trans_opts, rest]
        |> Enum.join("/")

      URI.to_string(%URI{uri | path: new_path})
    else
      image_url
    end
  end

  def generate_transformation_string(opts) do
    opts
    |> Enum.map(&trans_opt/1)
    |> Enum.reject(&is_nil/1)
    |> Enum.join(",")
  end

  defp trans_opt({"width", w}), do: "w_#{w}"
  defp trans_opt({:width, w}), do: "w_#{w}"
  defp trans_opt({"height", h}), do: "h_#{h}"
  defp trans_opt({:height, h}), do: "h_#{h}"
  defp trans_opt({"dpr", dpr}), do: "dpr_#{dpr}.0"
  defp trans_opt({:dpr, dpr}), do: "dpr_#{dpr}.0"
  defp trans_opt({"mode", "crop"}), do: "c_crop"
  defp trans_opt({:mode, "crop"}), do: "c_crop"
  defp trans_opt({"mode", "fill"}), do: "c_fill"
  defp trans_opt({:mode, "fill"}), do: "c_fill"
  defp trans_opt({"mode", "fit"}), do: "c_fit"
  defp trans_opt({:mode, "fit"}), do: "c_fit"
  defp trans_opt({"gravity", "face"}), do: "g_face"
  defp trans_opt({:gravity, "face"}), do: "g_face"
  defp trans_opt(_), do: nil
end
