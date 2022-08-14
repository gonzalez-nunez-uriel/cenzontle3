defmodule Cenzontle3 do
  @moduledoc """
  Mock 3 of `Cenzontle`.

  Cenzontle is a personal rearch engine to help you discover information from a subset of the internet that you like. It is also an experimental search engine that artificial intelligence to perform informatioin discovery.

  This module does two things:
  1. This module fires up the Dispatcher
  1. Listens to the Phoenix app and delegates queries to the Librarian

  I have no clue what I am doing.

  I hate TDD. No one can explain it in simple terms.

  TDD requires that you have a clear idea what the architecture of the app is. I don't have that right now.
  """

  def on_watchlist_processed(pid, registry) do
    GenServer.cast(pid, {:watchlist_processed, registry})
  end
end
