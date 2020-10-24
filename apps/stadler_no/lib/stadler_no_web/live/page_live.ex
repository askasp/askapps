defmodule StadlerNoWeb.PageLive do
  use StadlerNoWeb, :live_view


  @impl true
  def mount(_params, _session, socket) do
      {:ok, assign(socket, page: :home, show_menu: false)}
  end


  def handle_event(event, a, socket) do
    new_socket =
    case event do
      "toggle-menu" -> assign(socket, show_menu: !socket.assigns.show_menu)
      _ -> socket
      end

     {:noreply, new_socket}

  end


  def render(assigns) do
    ~L"""
    <%= burger_menu(assigns) %>
     <%= case @page do %>
      	<%_ -> %> <%= home_page(assigns) %>
    <% end %>
     """
  end



 def home_page(assigns) do
   ~L"""
     <div class="flex h-screen ">
	<div class="m-auto text-center">
	    <h1 class="text-stadler text-3xl">Aksel Stadler</h1>
	    <h1 class="text-white opacity-75 text-xs ">Robotics Engineer & Programmer</h1>
  	</div>
     </div>
   
   """
 end


  def burger_menu(assigns) do
    ~L"""
    <div phx-click="toggle-menu" style="position: fixed; top:20px; right:20px">
    <i class="material-icons text-white opacity-75">
      <%= if @show_menu do  %>
      	clear
      <% else %>
        menu
      <% end %>
    </i>
    </div>

    """
    end
 
end

    
