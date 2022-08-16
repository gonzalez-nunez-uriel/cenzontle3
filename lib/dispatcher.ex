defmodule Dispatcher do
  @moduledoc """
  This module is in charge of reading the list of authorpages from a file and sending them to the right domain broker.
  """

  use GenServer

  @watchlist_path "../data/watchlist.txt"

  defp get_watchlist(contents) do
    String.split(contents, "\n", trim: true)
  end

  def start() do
    case File.read(@watchlist_path) do
      {:ok, contents} ->
        watchlist = get_watchlist(contents)
        # Should I add checks on properties of the watchlist?
        start(watchlist)

      {:error, reason} ->
        # Tell supervisor that an error ocurred by sending a msg?
        # For now, just an atom
        {:error, reason}
    end
  end

  # For the sake of testing
  defp start(watchlist) do
    {:ok, GenServer.start(__MODULE__, {watchlist, %{}})}
  end

  def init(init_arg) do
    {:ok, init_arg}
  end

  def begin(pid) do
    GenServer.cast(pid, {:begin, self()})
  end

  def handle_cast({:begin, sup_pid}, {watchlist, registry}) do
    # There needs to be a way to notify the user that there is some error with the URL that is registered in the watchlist
    filtered_watchlist = URL.get_watchlist_w_domains(watchlist)
    registry = dispatch_watchlist(filtered_watchlist, registry)
    # HOW DO I SHUT IT DOWN?!?!?!?!?!?!?!?
    # Maybe let the supevisor know so that it can shut it down
    Cenzontle3.on_watchlist_processed(sup_pid, registry)
    # After this point state doesn't matter
    # Is it ok to lose the registry with all the pids?
    {:noreply, []}
  end

  def dispatch_watchlist([], registry) do
    # Not necesarry. For the sake of testing
    registry
  end

  def dispatch_watchlist([{domain, authorpage} | rest], registry) do
    new_registry =
      case Map.get(registry, domain) do
        # Broker for that domain is not   in the registry
        nil ->
          new_broker = Broker.start(domain, authorpage)
          Map.put(domain, new_broker)

        broker ->
          Broker.process(broker, authorpage)
          registry
      end

    dispatch_watchlist(rest, new_registry)
  end
end
