defmodule Dispatcher do
  @moduledoc """
  This module is in charge of reading the lnist of authorpages from a file and sending them to the right domain broker.
  """

  use GenServer

  @watchlist_path "../data/watchlist.txt"

  def start(_supervisor_pid) do
    case File.read(@watchlist_path) do
      {:ok, contents} ->
        watchlist = String.split(contents, "\n", trim: true)
        # Should I add checks on properties of the watchlist
        GenServer.start(__MODULE__, watchlist)

      {:error, _reason} ->
        # Tell supervisor that an error ocurred by sending a msg?
        # For now, jurt an atom
        :error
    end
  end

  def init(init_arg) do
    {:ok, init_arg}
  end
end
