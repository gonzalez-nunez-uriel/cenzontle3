defmodule URL do
  def get_watchlist_w_domains([authorpage, rest], processed \\ []) do
    domain = extract_domain(authorpage)
    # The order of the list does not matter, so it is ok if it gets reversed
    get_watchlist_w_domains(rest, [domain | processed])
  end
end
