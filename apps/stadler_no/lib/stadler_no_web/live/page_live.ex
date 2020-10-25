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
      _  -> {:noreply, socket}
    end
  end


  def handle_event(event, a, socket) do
    new_socket =
      case event do
        "toggle-menu" -> handle_menu_toggle(socket)
        "nav-home" -> push_patch(socket, to: "/home")
        "nav-projects" -> push_patch(socket, to: "/projects")
        "nav-led" -> push_patch(socket, to: "/led")
        "nav-nixops" -> push_patch(socket, to: "/nixops")
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
     	<% "nixops" -> %> <%= nixops_page(assigns) %>
    <% end %>
    """
  end

  def home_page(assigns) do
    ~L"""
      <div class="centered">
      <div clpass="m-auto text-center">
      	<h1 class="text-stadler text-3xl">Aksel Stadler</h1>
      	<h1 class="text-white opacity-67 text-sm ">Robotics Engineer & Programmer</h1>
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
    <p class="text-white opacity-67 text-sm mt-2"> <%= @description %> </p>
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
    <i class="material-icons text-white opacity-67 text-2xl">
      <%= if @page == "menu" do  %>
      	clear
      <% else %>
        menu
      <% end %>
    </i>
    </div>

    """
  end


  def nixops_page(assigns) do
    ~L"""
  <section>
   <h1 class="text-stadler text-xl">
    Nixops & Liveview
   </h1>
   <hr class="border-solid border-stadler">
   <img class="w-full" src="<%= Routes.static_path(StadlerNoWeb.Endpoint, "/images/phoenix.png")%>" </img>
   <p class="text-white opacity-67 mt-4">
    Phoenix liveview enables server-side-rendered &#39;&#39;single-page&#39;&#39; web pages. It does this by the power of a brand-new technology (not really) called websockets.
   </p>
   <p class="text-white opacity-67 mt-4">
    Liveview sets up a websocket connection between the client and the server. Commands goes from the client, and an updated html is sent back. Morphdom then seemlessly updates the view.
   </p>
   <p class="text-white opacity-67 mt-4">
    Why isn&#39;t this implemented in other backend languages you might wonder. Well, mostly because websockets are statefull, and most languages are not optimised for that.
   </p>
   <p class="text-white opacity-67 mt-4">
    In Elixir/Erlang state is trivial. This is because the latter is an (unintentional) implementation of the actor model. Each websocket connection is an totally isolated process (actor) that can only communicate with other actors through message passing. I.e. Share by communicating, don&#39;t communicate by sharing (i&#39;m looking at you C++)
   </p>
   <p class="text-white opacity-67 mt-4">
    NixOS is a declerative linux distribution built around the nix package manager. It enables, and encourages, users to declare their system in a version controlled config file. This makes rebuilding and duplication trivial. This is possible as nix packages are 100% declerative. Each package is built by pure functions, guaranteeing that it is identical each time it is built.
   </p>
   <p class="text-white opacity-67 mt-4">
    Nixops allows you to define a NixOS system, build it locally, and ship it to one or more remote NixOS machines.
   </p>
   <h2 class="text-stadler text-lg mt-4">
    What&#39;s wrong with Kubernetes?
   </h2>
   <p class="text-white opacity-67 mt-2">
    Nothing! It seems that kubernetes is about to become the de-facto standard for hosting. At-least for companies that are worried about cloud-provider lock-in (which they should be). Also, with microk8s it&#39;s cheap to spin up a cluster for hobby projects as well. The reason I, currently, choose to use nixops for my projects are.
   </p>
   <ul class="list-disc text-white opacity-67 mt-4 pl-8">
    <li>
     No need for a container registry
    </li>
    <li>
     Nix-shell on the default.nix makes a shell with all dependencies to build and run the project
    </li>
    <li>
     I can run it on a VM without a load balancer (cheap)
    </li>
    <li>
     I wanted to try something new
    </li>
   </ul>
   <h2 class="text-stadler text-lg mt-4">
    Making the nix package derivation
   </h2>
   <p class="text-white opacity-67">
    First create a new phoenix project with
   </p>
   <pre class="text-white opacity-67 text-xs "> <code> mix phx.new nixops_live --live --no-ecto </code> </pre>
   <p class="text-white opacity-67">
    You can easily test it by running
   </p>
   <pre class=" text-xs text-white opacity-67 items-center content-center"> <code> mix phx.server </code> </pre>
   <p class="text-white opacity-67">
    and go to localhost:4000.
   Try to search in the form to se server side rendered dynamic content in action
   </p>
   <p class="text-white opacity-67">
    Now, we create a derivation for how nix should build this project. Create a new file named default.nix and fill in
   </p>
   <pre class=" text-xs text-white opacity-67">
    <code class="px-4 text-xs">
with import <nixpkgs> {};
let stadler_no = {}:
 stdenv.mkDerivation rec {
  name = &#34;stadler_no&#34;;
  src = ./.;
  buildInputs = [elixir git nodejs];


  buildPhase = &#39;&#39;
  mkdir -p $PWD/.hex
  export HOME=$PWD/.hex
  #Certs are only needed if you pull repos directly from github
  export GIT_SSL_CAINFO=/etc/ssl/certs/ca-certificates.crt
  export SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt
  mix local.rebar --force
  mix local.hex --force
  mix deps.get
  MIX_ENV=prod mix compile
  npm install --prefix ./assets
  npm run deploy --prefix ./assets
  mix phx.digest
  MIX_ENV=prod mix release

  &#39;&#39;;
  installPhase = &#39;&#39;
    mkdir -p $out
    cp -rf _build/prod/rel/stadler_no/* $out/

  &#39;&#39;;
};
in
stadler_no
     </nixpkgs>
    </code>
   </pre>
   <p class="text-white opacity-67">
    There are multiple things going on here. For a more thorough explanation of nix packages I recommend this
    <a href="https://christine.website/blog/nixos-desktop-flow-2020-04-25">
     this
    </a>
    blogpost by Christine Dodrill.
What you need to pay attention to is
   </p>
   <ol class="list-decimal text-white opacity-67 ml-8  mt-4 mb-4">
    <li>
     buildInputs -- (The requirements to build)
    </li>
    <li>
     buildPhase --  (A bash recipe for building phoenix releases)
    </li>
    <li>
     install phase -- (Copying the binary to an artifact directory)
    </li>
   </ol>
   <p class="text-white opacity-67">
    You can test this by running
   </p>
   <pre class=" text-xs text-white opacity-67"> <code> nix-build default.ex --option sandbox false </code> </pre>
   <p class="text-white opacity-67">
    The latter is needed as we fetch deps from the internet. If successfull you should
see a result folder in your directory.
   </p>
   <p class="text-white opacity-67">
    Note: the default.nix can also be used to set up a development environment. Simply run
   </p>
   <pre class=" text-xs text-white opacity-67"> <code> nix-shell defualt.nix </code> </pre>
   <p class="text-white opacity-67">
    and you will drop into a shell with all the needed dependencies installed. This is
supernice when multiple devs are working on the same project
   </p>
   <h2 class="text-stadler text-lg mt-4">
    Making the service
   </h2>
   <p class="text-white opacity-67">
    nix-build only compile the code, is does not run it. Next step is to set up a service for that. A systemd service to be exact. Create the file service.nix and fill it with
   </p>
   <pre class=" text-xs text-white opacity-67 text-xs"> <code>
{config, lib, pkgs, ...}:
let stadler_no_build = pkgs.callPackage ./default.nix {};  #Build the derivation described in default.nix
    cfg = config.services.stadler_no;
in {
    #Set configurable options
    options.services.stadler_no.enable = lib.mkEnableOption &#34;stadler_no&#34;;
    options.services.stadler_no.port = lib.mkOption {
        type = lib.types.int;
        default = 4000;
    };

    config = lib.mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [ cfg.port ];
    #Define the service
    systemd.services.stadler_no = {
        description = &#34;My home page stadler no&#34;;
        environment = {
            HOME=&#34;/root&#34;;
            PORT=&#34;${toString cfg.port}&#34;;
            RELEASE_TMP=&#34;/tmp&#34;;
            #Secrets will be injected at a later time
            ADMIN_PWD=&#39;&#39;$(cat /run/keys/admin_pwd)&#39;&#39;;
            Stadler_NO_SKB=&#39;&#39;$(cat /run/keys/stadler_no_skb)&#39;&#39;;
            Stadler_NO_LV_SS=&#39;&#39;$(cat /run/keys/stadler_no_lv_ss)&#39;&#39;;
            };

     after = [ &#34;network-online.target&#34; ];
     wantedBy = [ &#34;network-online.target&#34; ];

    serviceConfig = {
        DynamicUser = &#34;true&#34;;
        PrivateDevices = &#34;true&#34;;
        ProtectKernelTunables = &#34;true&#34;;
        ProtectKernelModules = &#34;true&#34;;
        ProtectControlGroups = &#34;true&#34;;
        RestrictAddressFamilies = &#34;AF_INET AF_INET6&#34;;
        LockPersonality = &#34;true&#34;;
        RestrictRealtime = &#34;true&#34;;
        SystemCallFilter = &#34;@system-service @network-io @signal&#34;;
        SystemCallErrorNumber = &#34;EPERM&#34;;

	#This command is run when the systemd service starts
        ExecStart = &#34;${stadler_no_build}/bin/stadler_no start&#34;;
        Restart = &#34;always&#34;;
        RestartSec = &#34;5&#34;;
    };
    };
};
} </code> </pre>
   <p class="mt-2 text-white opacity-67">
    Commit the code and push it to gitlab
   </p>
   <h2 class="text-stadler text-lg mt-4">
    Nixops
   </h2>
   <p class="text-white opacity-67 mt-4">
    It&#39;s time to set up the server. You can naturally use the same repo as before, but I like creating a new one as I have many projects in the same deployment.
   </p>
   <p class="text-white opacity-67 mt-4">
   </p>
   <p class="text-white opacity-67 mt-4">
    Create a new directory named nixops_do, and generate a ssh keypair here. Be sure to place the keys in the nixops_do, and not overwrite the one in ~/.ssh. Keep the passphrase empty
   </p>
   <p class="text-white opacity-67 mt-4">
   </p>
   <p class="text-white opacity-67 mt-4">
    After this, go to digitalocean.com, create an ubuntu droplet, and add the newly generated key under authorized hosts Tutorial
   </p>
   <p class="text-white opacity-67 mt-4">
   </p>
   <p class="text-white opacity-67 mt-4">
    Make three empty files, nixops_do.nix, nixops_do_hw.nix, and nixops_do_secrets.nix The first will describe what is running on the machine, the second describes the machine, and the latter injects secrets as env variables
   </p>
   <h3 class="text-white opacity-67 text-lg font-bold mt-2">
    nixops_do.nix
   </h3>
   <pre class="text-white opacity-67 text-xs"> <code>
## Fetch service from gitlab
stadler_no = builtins.fetchGit {
      url = &#34;https://gitlab.com/akselsk/stadler_no&#34;;
      ref = &#34;master&#34;;
      rev = &#34;82b0e190d10c70c1878d1d61e3b7e1618f14d822&#34;;
};

in
    let backend= { config, pkgs, ... }: {
  	environment.systemPackages = with pkgs; [cacert git vim ];
  	 # Add public key to enable updates
  	users.users.root = {
    	openssh.authorizedKeys.keys = [&#34;ssh-ed25519 **pubkey** aksel@stadler.no&#34;];
  	};

        services.openssh.enable = true;
  	#Import the service file made previously
  	imports = [
      	&#34;${stadler_no.outPath}/service.nix&#34;

  	];
        networking.firewall.allowedTCPPorts = [ 22 4343 80 443 ];
        # Enable the service
  	services.stadler_no.enable = true;
  	services.stadler_no.port= 4002;
  	services.openssh.permitRootLogin = &#34;yes&#34;;

 	#Allow the erlang vm to write error logs to disk
	systemd.tmpfiles.rules = [
  	&#34;d /root/tmp 0755 root root&#34;
	];
	#Start nginx procy pass
        services.nginx = {
            enable = true;
            recommendedProxySettings = true;
            recommendedTlsSettings = true;
            virtualHosts.&#34;stadler.no&#34; =  {
              enableACME = true;
              forceSSL = true;
              locations.&#34;/&#34; = {
                proxyPass = &#34;http://127.0.0.1:4002&#34;;
                proxyWebsockets = true; # needed if you need to use WebSocket
              };
            };
        };
        security.acme.acceptTerms = true;
	security.acme.certs = {
  	&#34;stadler.no&#34;.email = &#34;aksel@stadler.no&#34;;
	};
    	};
in {
  network.description = &#34;Test server&#34;;
  #The server name, must have a corresponding hardware name
  asknixops1= backend;

  #If desireably to deploy to multiple machines
  #asknixops2= backend
}
    </code>
   </pre>
   <h3 class="text-white opacity-67 text-lg font-bold mt-2">
    nixops_hw.nix
   </h3>
   <pre class="text-white opacity-67 text-xs">
    <code>
# Hardware config
 let machine = { config, pkgs, ... }: {
    deployment.targetEnv = &#34;digitalOcean&#34;;
    deployment.digitalOcean.enableIpv6 = true;
    deployment.digitalOcean.region = &#34;ams3&#34;;
    deployment.digitalOcean.size = &#34;s-1vcpu-1gb&#34;;
    deployment.digitalOcean.vpc_uuid= &#34;default-ams3&#34;;
   # deployment.digitalOcean.authToken = &#34;Doesn&#39;t seem to work&#34;;
  };
in
{
  resources.sshKeyPairs.ssh-key = {
    publicKey = builtins.readFile ./tstKey.pub;
    privateKey = builtins.readFile ./tstKey;
  };

  asknixops1= machine; #Much mach a corresponding server

  #asknixops2 = machine;

}
    </code>
   </pre>
   <h3 class="text-white opacity-67 text-lg font-bold mt-2">
    nixops_secrets.nix
   </h3>
   <pre class="text-white opacity-67 text-xs"> <code> asknixops1= { config, pkgs, ... }:
    {
      deployment.keys.admin_pwd.text = &#34;***&#34;;
      deployment.keys.stadler_no_skb = &#34;**&#34;;
      deployment.keys.stadler_no_lv_ss = &#34;**&#34;;
    };
} </code> </pre>
   <p class="text-white opacity-67">
    Create a deployment by running
   </p>
   <pre class="text-white opacity-67 text-xs"> <code> nixops create ./nixops_do.nix ./nixops_do_hw.nix ./nixops_do_secrets.nix -d nixops_do </code> </pre>
   <p class="text-white opacity-67">
    and ship it with
   </p>
   <pre class="text-white opacity-67 text-xs"> <code> nixops deploy -d nixops_do </code> </pre>
   <p class="text-white opacity-67"> For debugging you can ssh into the machine with </p>
   <pre class="text-white opacity-67 text-xs"> <code> nixops ssh *deployname* *machine_name* </code> </pre>
   <p class="text-white opacity-67">
    To print debug logs run the following
   </p>
   <pre class="text-white opacity-67 text-xs">  <code> systemctl status *service_name* or journalctl -u *service_name* </code> </pre>
  </section>
  

    	  
	"""
   end


  def led_page(assigns) do
    ~L"""
<h1 class="text-stadler text-xl"> LED thermometer for Africa burn </h1>
<hr class="border-solid border-stadler"> </hr>
    <img class="w-full bg-koronavenn" src=" <%= Routes.static_path(StadlerNoWeb.Endpoint, "/images/saunandtermo.png")  %>"/>

    <p class="text-white opacity-67 ">
    For Africa Burn 2019 my camp (Vagabonds)
    decided to gift a sauna to the community.
    This is a quick and dirty walkthrough for making the LED thermometer
    as seen on the picture.
    The hotter it gets the more LEDs
    are lit, and redder they become.
    In the picture the temperature  is 60°C and the range is 0-80°C
    </p>

<h2 class="text-stadler text-lg mt-2"> Equipment </h2>
<table class="w-full text-white border-collapse opacity-67">
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
<p class="text-white opacity-67" >
The code is rather strighforward as it builds upon  <a href="https://learn.adafruit.com/neopixels-on-raspberry-pi/python-usage">  NeoPixel  </a>
and <a href="https://github.com/timofurrer/w1thermsensor"> w1Thermsensor </a>.
Only small modifications were needed from the NeoPixel examples.

Note the MAX and MIN constants as they decide the temperature range for the termometer
</p>

<pre class="text-white opacity-67 text-xs"> <code>
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
