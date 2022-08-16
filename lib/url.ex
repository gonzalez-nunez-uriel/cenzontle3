defmodule URL do
  def get_watchlist_w_domains([authorpage, rest], processed \\ []) do
    domain = extract_domain(authorpage)
    # The order of the list does not matter, so it is ok if it gets reversed
    get_watchlist_w_domains(rest, [domain | processed])
  end

  # Some examples
  ## Valid
  # https://hexdocs.pm/elixir/1.13/Regex.html
  # https://www.20i.com/support/domain-names/domain-name-restrictions
  # https://dockyard.com/blog/2016/08/05/understand-capture-operator-in-elixir
  ## Invalid
  # ht tps://hexdocs.pm/elixir/1.13/Regex.html
  # https://www.2 0i.com/supp ort/domain-names/domain-name-restrictions
  # https://dockyard.com/blog/2016/08/05/understand-c apture-operator-in-elixir
  # seihtikfmvdbktnhdiestkdhkifp
  # https://fseitiewfkdiekidekievdk/sutynuehd/fueptdhy/fptnehd
  def is_valid?(url_parts) do
    # Read this
    # https://stackoverflow.com/questions/44809846/a-good-regular-expression-for-an-uri-in-elixir
    # This is the kind of attitude that plagues the industry
    # It also shows that URLs are unnecesarily complex

    # This is just meant to catch something that is obviourly wrong, it doesn't have to be perfect. The HTTP Client can handle that with timeouts and status codes.

    # Regex are just too hard. There are entities that register domains. Those entities probably have rules on 1) the size of domain names, 2) rupported protocols, 3) symbols aoowed(reserved symbols), etc.
    # I found this page https://www.20i.com/support/domain-names/domain-name-restrictions
  end

  # {:error, reason} | {:ok, %URL{}}
  # Three scenarios
  # 1. https://www.youtube.com/
  #   1. https://www.youtube.com
  # 1. www.youtube.com/
  #   1. www.youtube.com
  # 1. youtube.com/
  #   1. youtube.com
  def break_up_url(url) do
    has_protocol = String.contains?(url, "://")

    if has_protocol do
      [protocol, rest] = String.split(url, "://")
      has_path = String.contains?(rest, "/")

      if has_path do
        [domain, path] = String.split(rest, "/", parts: 2)
      else
      end
    else
    end

    has_resource_path = String.contains?(url, "/")
  end

  defp extract_protocol(url) do
    if String.contains?(url, "://") do
      [protocol, _rest] = String.split(url, "://")
      protocol
    else
      {:error, "Missing '://'. No protocol found in #{url}"}
    end
  end

  defp remove_protocol(url) do
    if String.contains?(url, "://") do
      [_protocol, rest] = String.split(url, "://")
      rest
    else
      url
    end
  end

  # www.youtube.com
  # www.youtube.com/ --> Just a domain
  # /users/uriel --> Just a path
  defp extract_domain(url) do
    clean_url = remove_protocol(url)

    case String.split(clean_url, "/", parts: 2) do
      [x] -> {:error, "Missihg domain in #{url}"}
      [domain, _left_overs] -> domain
    end
  end

  defp extract_path(url) do
  end
end
