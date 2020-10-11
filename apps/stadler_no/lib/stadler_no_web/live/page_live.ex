defmodule StadlerNoWeb.PageLive do
  use StadlerNoWeb, :live_view


  #Unsafe code.
  @spec init(any) :: {:ok, Model.t} | {:error, atom}
  def init(page) when page in [["/"],["home"]] do
    case page do
      ["/"] -> {:ok, {:home, HomeModel.new("aksel")}}
      ["home"] -> {:ok, {:home, HomeModel.new("tor")}}
     end
  end

  @spec init(any) :: {:ok, Model.t} | {:error, atom}
  def init(page), do: {:error, :not_found}


  @impl true
  def mount(params, _session, socket) do

    {:ok, assign(socket, query: "", results: %{}, title: :hello_world.hello())}
  end

  @impl true
  def handle_event("suggest", %{"q" => query}, socket) do
    {:noreply, assign(socket, results: search(query), query: query)}
  end

  @impl true
  def handle_event("search", %{"q" => query}, socket) do
    case search(query) do
      %{^query => vsn} ->
        {:noreply, redirect(socket, external: "https://hexdocs.pm/#{query}/#{vsn}")}

      _ ->
        {:noreply,
         socket
         |> put_flash(:error, "No dependencies found matching \"#{query}\"")
         |> assign(results: %{}, query: query)}
    end
  end

  defp search(query) do
    if not StadlerNoWeb.Endpoint.config(:code_reloader) do
      raise "action disabled when not in development"
    end

    for {app, desc, vsn} <- Application.started_applications(),
        app = to_string(app),
        String.starts_with?(app, query) and not List.starts_with?(desc, ~c"ERTS"),
        into: %{},
        do: {app, vsn}
  end
end
