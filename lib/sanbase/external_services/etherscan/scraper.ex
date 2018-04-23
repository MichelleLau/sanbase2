defmodule Sanbase.ExternalServices.Etherscan.Scraper do
  use Tesla

  alias Decimal, as: D
  alias Sanbase.ExternalServices.RateLimiting
  alias Sanbase.ExternalServices.ProjectInfo
  alias Sanbase.ExternalServices.ErrorCatcher

  require Logger

  plug(RateLimiting.Middleware, name: :etherscan_rate_limiter)
  plug(ErrorCatcher.Middleware)
  plug(Tesla.Middleware.BaseUrl, "https://etherscan.io")
  plug(Tesla.Middleware.FollowRedirects, max_redirects: 10)
  plug(Tesla.Middleware.Logger)

  def fetch_address_page(address) do
    case get("/address/#{address}") do
      %Tesla.Env{status: 200, body: body} ->
        body

      %Tesla.Env{status: status, body: body} ->
        Logger.warn(
          "Invalid response from etherscan for address #{address}. Status: #{status}, body: #{
            inspect(body)
          }"
        )

        nil

      %Tesla.Error{message: error_msg} ->
        Logger.warn("Error response from etherscan for address #{address}. #{error_msg}")
        nil
    end
  end

  def fetch_token_page(token_name) do
    case get("/token/#{token_name}") do
      %Tesla.Env{status: 200, body: body} ->
        body

      %Tesla.Env{status: status, body: body} ->
        Logger.warn(
          "Invalid response from etherscan for #{token_name}. Status: #{status}, body: #{
            inspect(body)
          }"
        )

        nil

      %Tesla.Error{message: error_msg} ->
        Logger.warn("Error response from etherscan for #{token_name}. #{error_msg}")
        nil
    end
  end

  def parse_address_page!(nil, project_info), do: project_info

  def parse_address_page!(html, project_info) do
    %ProjectInfo{project_info | creation_transaction: creation_transaction(html)}
  end

  def parse_token_page!(nil, project_info), do: project_info

  def parse_token_page!(html, project_info) do
    %ProjectInfo{
      project_info
      | total_supply: total_supply(html) || project_info.total_supply,
        main_contract_address: main_contract_address(html) || project_info.main_contract_address,
        token_decimals: token_decimals(html) || project_info.token_decimals,
        website_link: official_link(html, "Website") || project_info.website_link,
        email: official_link(html, "Email") |> email() || project_info.email,
        reddit_link: official_link(html, "Reddit") || project_info.reddit_link,
        twitter_link: official_link(html, "Twitter") || project_info.twitter_link,
        btt_link: official_link(html, "Bitcointalk") || project_info.btt_link,
        blog_link: official_link(html, "Blog") || project_info.blog_link,
        github_link: official_link(html, "Github") || project_info.github_link,
        telegram_link: official_link(html, "Telegram") || project_info.telegram_link,
        slack_link: official_link(html, "Slack") || project_info.slack_link,
        facebook_link: official_link(html, "Facebook") || project_info.facebook_link,
        whitepaper_link: official_link(html, "Whitepaper") || project_info.whitepaper_link
    }
  end

  defp official_link(html, media) do
    Floki.find(html, ~s/a[data-original-title^="#{media}:"]/)
    |> Floki.attribute("href")
    |> List.first()
  end

  defp email("mailto:" <> email), do: email

  defp email(_) do
    nil
  end

  defp creation_transaction(html) do
    Floki.find(html, ~s/a[title="Creator Transaction Hash"]/)
    |> List.first()
    |> case do
      nil -> nil
      match -> Floki.text(match)
    end
  end

  defp total_supply(html) do
    Floki.find(html, ~s/td:fl-contains('Total Supply') + td/)
    |> List.first()
    |> case do
      nil ->
        nil

      match ->
        Floki.text(match)
        |> parse_total_supply
        |> D.mult(D.new(:math.pow(10, token_decimals(html))))
        |> D.to_integer()
    end
  end

  defp main_contract_address(html) do
    Floki.find(html, ~s/td:fl-contains('ERC20 Contract') + td/)
    |> List.first()
    |> case do
      nil -> nil
      match -> Floki.text(match)
    end
  end

  defp token_decimals(html) do
    Floki.find(html, ~s/td:fl-contains('Decimals') + td/)
    |> List.first()
    |> case do
      nil -> nil
      match -> Floki.text(match) |> parse_token_decimals
    end
  end

  defp parse_token_decimals(nil), do: 0

  defp parse_token_decimals(token_decimals) do
    token_decimals
    |> String.trim()
    |> String.to_integer()
  end

  defp parse_total_supply(nil), do: D.new(0)

  defp parse_total_supply(total_supply) do
    total_supply
    |> String.trim()
    |> String.replace(",", "")
    |> String.split()
    |> List.first()
    |> D.new()
  end
end
