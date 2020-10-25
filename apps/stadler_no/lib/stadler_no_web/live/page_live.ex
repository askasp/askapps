defmodule StadlerNoWeb.PageLive do
  use StadlerNoWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, page: "home", previous_page: false)}
  end

  @impl true
  def handle_params(params, _uri, socket) do
    case params["page"] do
      [] -> {:noreply, assign(socket, page: "home")}
      [x] -> {:noreply, assign(socket, page: x)}
    end
  end

  def handle_event(event, a, socket) do
    new_socket =
      case event do
        "toggle-menu" -> handle_menu_toggle(socket)
        "nav-home" -> push_patch(socket, to: "/home")
        "nav-projects" -> push_patch(socket, to: "/projects")
        "nav-led" -> push_patch(socket, to: "/led")
        _ -> socket
      end

    {:noreply, new_socket}
  end

  def render(assigns) do
    ~L"""
    <%= burger_menu(assigns) %>
    <%= case @page do %>
       <% "menu" -> %> <%= menu_page(assigns) %>
     	<% "home" -> %> <%= home_page(assigns) %>
     	<% "projects" -> %> <%= projects_page(assigns) %>
     	<% "led" -> %> <%= led_page(assigns) %>
    <% end %>
    """
  end

  def home_page(assigns) do
    ~L"""
      <div class="centered">
      <div clpass="m-auto text-center">
      	<h1 class="text-stadler text-3xl">Aksel Stadler</h1>
      	<h1 class="text-white opacity-75 text-sm ">Robotics Engineer & Programmer</h1>
      </div>
      </div>

    """
  end


  def projects_page(assigns) do
    ~L"""
    <section>
    <h1 class="text-stadler text-2xl"> Projects </h1>
    <hr class="border-solid border-stadler"> </hr>
    <%= project_page_intro(%{
    	image: "/images/saunandtermo.png",
    	title: "Led Thermometer for Africa Burn",
    	link: "nav-led",
    	description: "In Africa burn 2019 we gifted a sauna to the community. We installed a 3m tall LED thermometer so bypassers could see the current sauna temperature. Here is a walkthrough of the code and how I wired it all up"
    	}) %>
    	
       <%= project_page_intro(%{
    	image: "/images/nixops.png",
    	title: "Nixops & Liveview",
    	link: "nav-nixops",
    	description: "Phoenix liveview is the new go-to framework for building SPAs in much the same way that 2021 is the year of the desktop (fingers crossed). Its killer feature is server-side-rendered dynamic webpages (it is as great as it sounds). Nixops is for people that are too cool for kubernetes"
    	}) %>

       <%= project_page_intro(%{
    	image: "/images/telefon.svg",
    	title: "Koronavenn",
    	link: "https://kronavenn.web.app",
    	description: "KoronavennA service made during the 2020 pandemic. The purpose was to connect quaranteened people so everyone had a call buddy or a 'corona-friend' (which is the title in Norwegian)"
    	}) %>
    
    </section>
    """
  end


  def project_page_intro(assigns) do
    ~L"""
    <div class="flex flex-wrap mt-8 -mx-2">
    <div class="w-full lg:w-1/2 px-2 ">
    <img class="w-full bg-koronavenn" src=" <%= Routes.static_path(StadlerNoWeb.Endpoint, @image)  %>"/>
    </div>
    <div class="w-full lg:w-1/2 px-2 ">
    <a class="text-lg underline " phx-click="<%= @link %>"> <%= @title %> </a>
    <p class="text-white opacity-75 text-sm mt-2"> <%= @description %> </p>
    </div>    
    </div>    
    """
    end
       

  def menu_page(assigns) do
    ~L"""
    <div class="nav-links">
      <a phx-click="nav-home"> Home </a>
      <a phx-click="nav-projects"> Projects</a>
      <a href="/blogs">  Blogs </a>
    """
  end

  def burger_menu(assigns) do
    ~L"""
    <div phx-click="toggle-menu" style="position: fixed; top:20px; right:20px">
    <i class="material-icons text-white opacity-75 text-2xl">
      <%= if @page == "menu" do  %>
      	clear
      <% else %>
        menu
      <% end %>
    </i>
    </div>

    """
  end


  def led_page(assigns) do
    ~L"""
<h1 class="text-stadler text-xl"> LED thermometer for Africa burn </h1>
<hr class="border-solid border-stadler"> </hr>
    <img class="w-full bg-koronavenn" src=" <%= Routes.static_path(StadlerNoWeb.Endpoint, "/images/saunandtermo.png")  %>"/>

    <p class="text-white opacity-75 ">
    For Africa Burn 2019 my camp (Vagabonds)
    decided to gift a sauna to the community.
    This is a quick and dirty walkthrough for making the LED thermometer
    as seen on the picture.
    The hotter it gets the more LEDs
    are lit, and redder they become.
    In the picture the temperature  is 60°C and the range is 0-80°C
    </p>

<h2 class="text-stadler text-lg mt-2"> Equipment </h2>
<table class="w-full text-white border-collapse opacity-75">
  <tr class="text-left">
    <th >What </th>
    <th>Which </th>
    <th>Link </th>
  </tr>
  
  <tr class="">
    <td>Power Supply </td>
    <td>PHEVOS 5v 12A Dc Universal Switching Power Supply for Raspberry PI Models,CCTV </td>
    <td> tbd </td>
  </tr>

  <tr>
    <td>Micro Controller </td>
    <td> Rpi 3 </td>
    <td> tbd </td>
  </tr>

  <tr>
    <td>Thermometer </td>
    <td> Vktech 2M Waterproof Digital Temperature Temp Sensor Probe DS18b20 </td>
    <td> tbd </td>
  </tr>

  <tr>
    <td>Copper Wire</td>
    <td>  UL1015 Commercial Copper Wire, Bright, Red, 22 AWG, 0.0253" Diameter, 100' Length (Pack of 1) (As the leds draws about 6AMP its nice/wise to have a bit more then the standard RPI jumpers) </td>
    <td> tbd </td>
  </tr>

  </table>


<h2 class="text-stadler text-lg mt-2"> Wiring </h2>
<div style="width:100%;background-color: white">
    <img class="w-full bg-white" src=" <%= Routes.static_path(StadlerNoWeb.Endpoint, "/images/wiring.png")  %>"/>
    </div>

<h2 class="text-stadler text-lg mt-2"> Code </h2>
<p class="text-white opacity-75" >
The code is rather strighforward as it builds upon  <a href="https://learn.adafruit.com/neopixels-on-raspberry-pi/python-usage">  NeoPixel  </a>
and <a href="https://github.com/timofurrer/w1thermsensor"> w1Thermsensor </a>.
Only small modifications were needed from the NeoPixel examples.

Note the MAX and MIN constants as they decide the temperature range for the termometer
</p>

<pre class="text-white opacity-75"> <code>
#!/usr/bin/env python3

import time
from rpi_ws281x import *
import argparse
import math
from w1thermsensor import W1ThermSensor
sensor = W1ThermSensor()

MAX_TEMP = 100
MIN_TEMP = 0


# LED strip configuration:
LED_COUNT      = 300      # Number of LED pixels.
MAX_COLOR_LED = 200
LED_PIN        = 18      # GPIO pin connected to the pixels (18 uses PWM!).
#LED_PIN        = 10      # GPIO pin connected to the pixels (10 uses SPI /dev/spidev0.0).
LED_FREQ_HZ    = 800000  # LED signal frequency in hertz (usually 800khz)
LED_DMA        = 10      # DMA channel to use for generating signal (try 10)
LED_BRIGHTNESS = 255     # Set to 0 for darkest and 255 for brightest
LED_INVERT     = False   # True to invert the signal (when using NPN transistor level shift)
LED_CHANNEL    = 0       # set to '1' for GPIOs 13, 19, 41, 45 or 53

def getColor(lednr):
    red = math.floor(lednr/MAX_COLOR_LED * 255)
    print("red is",red)
    print("lednr is",lednr)
    if red > 255:
        red = 255

    blue = 255-red

    if blue > red:
        green = 255 - blue
    else:
        green = 255 -red
        red = 255
        blue = 0
   
    return Color(red,green,blue)
    
def SetColor(temp):
    nr_of_leds =math.floor(LED_COUNT*temp/MAX_TEMP)
    print("nr of leds is",nr_of_leds)
    for i in range(0,LED_COUNT):
        if i < nr_of_leds:
            color = getColor(i)
        else:
            color = Color(0,0,0)
        strip.setPixelColor(i,color)
        strip.show()


# Main program logic follows:
if __name__ == '__main__':
    # Process arguments
    parser = argparse.ArgumentParser()
    parser.add_argument('-c', '--clear', action='store_true', help='clear the display on exit')
    args = parser.parse_args()

    # Create NeoPixel object with appropriate configuration.
    strip = Adafruit_NeoPixel(LED_COUNT, LED_PIN, LED_FREQ_HZ, LED_DMA, LED_INVERT, LED_BRIGHTNESS, LED_CHANNEL)
    # Intialize the library (must be called once before other functions).
    strip.begin()

    print ('Press Ctrl-C to quit.')
    if not args.clear:
        print('Use "-c" argument to clear LEDs on exit')

    try:
        while True:
            SetColor(math.floor(sensor.get_temperature()))
            time.sleep(15)
          

    except KeyboardInterrupt:
        if args.clear:
            colorWipe(strip, Color(0,0,0), 10)


</code> </pre>


    """
end
    
  defp handle_menu_toggle(socket) do
    case socket.assigns.page do
      "menu" ->
        if socket.assigns.previous_page do
          push_patch(socket, to: "/" <> socket.assigns.previous_page)
        else
          push_patch(socket, to: "/home")
        end

      x ->
        assign(socket, previous_page: x) |> push_patch(to: "/menu")
    end
  end
end
