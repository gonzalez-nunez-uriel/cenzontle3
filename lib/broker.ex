defmodule Broker do
  @moduledoc """
  Abstract moule that contains the commonalities of all Brokers. Brokers are in charge of
  1. visiting pages
  1. checking that the structure of the div of interest has not changed
  1. extracting all the posts of that author
  1. visiting each post, extracting the information, and storing the information in files

  """

  @broker_registry %{
    "stackoverflow.com" => "StackOverflow",
    "hover.blog" => "Hover",
    "blog.appsignal.com" => "AppSignal",
    "www.reddit.com" => "Reddit",
    "devrant.com" => "DevRant"
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
