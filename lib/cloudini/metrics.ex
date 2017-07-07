defmodule Cloudini.Metrics do

  defmacro with_metrics(do: block) do
    action =
      __CALLER__.function
      |> elem(0)
      |> Atom.to_string

    quote do
      pre_hook = Application.get_env(:cloudini, :metrics_pre_hook, &(&1))
      post_hook = Application.get_env(:cloudini, :metrics_post_hook, &(&1))

      pre_result = pre_hook.(unquote(action))
      result = unquote(block)
      post_hook.({pre_result, unquote(action)})
      result
    end
  end
end
