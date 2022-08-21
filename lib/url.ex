defmodule URL do
  # There is a way to make fields mandatory
  # Do all fields need default values?
  # How do you specify the types of a struct?
  # How many subdomains can there be?
  # For the params, do I really neeed to parse them into params?
  # I am not going to use them, so why bother? The same for path
  # Optional binary, Optional binary, binary, binary, Optional List binary, Optional Map
  # Instead Optional binary, Optional binary, binary, binary, Optional binary, Optional binary
  defstruct protocol: nil, domain: nil, path: nil, params: nil

  def make_watchlist_w_domains([authorpage, rest], processed_watchlist \\ []) do
    new_processed_watchlist =
      case make_URL(authorpage) do
        # This is not possible because the watchlist only contains valid URLs. Soft ignore
        :error ->
          processed_watchlist

        {:ok, preprocessed_authorpage} ->
          domain = Map.get(preprocessed_authorpage, :domain)
          # The order of the list does not matter, so it is ok if it gets reversed
          [{domain, authorpage} | processed_watchlist]
      end

    make_watchlist_w_domains(rest, new_processed_watchlist)
  end

  # There is no need to implement is_valid? because if that is the case, it returns an error
  def make_URL(url) do
    case extract_protocol_and_more(url) do
      :error ->
        :error

      {protocol, domain, path, params} ->
        {:ok, %URL{protocol: protocol, domain: domain, path: path, params: params}}
    end
  end

  def extract_protocol_and_more(url) do
    case String.split(url, "://") do
      # without protocol
      [x] -> extract_params(nil, x)
      # with protocol
      [protocol, x] -> extract_params(protocol, x)
      # multiple protocol delimeters. Multiple urls in one line?
      _ -> :error
    end
  end

  def extract_params(protocol, url) do
    case String.split(url, "?", parts: 2) do
      # without params
      [x] -> extract_resource_path(nil, protocol, x)
      # missing a domain
      ["", _params] -> :error
      # Trailing '?'. Super weird case
      [x, ""] -> extract_resource_path(nil, protocol, x)
      # with params
      [x, params] -> extract_resource_path(params, protocol, x)
    end
  end

  def extract_resource_path(params, protocol, url) do
    case String.split(url, "/", parts: 2) do
      # without path
      [domain] -> extract_domain(nil, params, protocol, domain)
      # missing domain
      ["", _path] -> :error
      # Trailing '/'. Common case
      [domain, ""] -> extract_domain(nil, params, protocol, domain)
      # with path
      [domain, path] -> extract_domain(path, params, protocol, domain)
    end
  end

  def extract_domain(path, params, protocol, domain) do
    # validation on domain
    {protocol, domain, path, params}
  end
end
