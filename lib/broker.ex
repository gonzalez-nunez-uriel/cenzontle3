defmodule Broker do
  @moduledoc """
  Abstract moule that contains the commonalities of all Brokers. Brokers are in charge of
  1. visiting pages
  1. checking that the structure of the div of interest has not changed
  1. extracting all the posts of that author
  1. visiting each post, extracting the information, and storing the information in files

  """

  # When the user input the URL, there should be a way for them to choose which briker to assign. Like this:

  # +-------------------------------------------------+
  # |          +-----------------------------------+  |
  # |     URL: | <Query>                           |  |
  # |          +-----------------------------------+  |
  # |                                                 |
  # |          +--------------+---+                   |
  # |  Broker: | <BrokerName> | V |                   |
  # |          +--------------+---+                   |
  # |                                                 |
  # + ----- <div with Broker specific configs> -------|
  # | In StackOverflow, whether the accepted answer,  |
  # | the most voted comment on the authors           |
  # | response, etc should also be indexed            |
  # |                                                 |
  # +-------------------------------------------------+
  # First time doing UI ascii art. Not bad.

  # These is tedious and error prone, so a better alternative should be considered. One way would be by having each briker indicate what websites it can handle. StackOverflow and Stack Exchange have similar layouts. Maybe someone fygures out a generic that can handle reddit and other sites with a similar format. Remember, the whole point is not to constrain a power user. The arch needs to be so that things are customizable. Perhaps, have the drop down selector display all of the Broker that can handle that cite. If none, the user should be informed and allow them to use the generic Broker (the one that indexes everything in a page).
  @broker_registry %{
    "stackoverflow.com" => "StackOverflow",
    "hover.blog" => "Hover",
    "blog.appsignal.com" => "AppSignal",
    "www.reddit.com" => "Reddit",
    "devrant.com" => "DevRant",
    "www.youtube.com" => "YouTube",
    "youtube.com" => "YouTube"
  }

  # ~ DON'T FORGET THAT THE BROKER NEEDS TO REPORT BACK ONCE IT IS DONE

  def start(domain, sup_pid) do
    module = Map.get(@broker_registry, domain)
    apply(String.to_atom("Elixir.Broker." <> module), :start, [sup_pid])
  end

  def process(broker_pid, authorpage) do
    GenServer.cast(broker_pid, {:process, authorpage})
  end
end
