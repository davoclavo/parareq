defmodule CCUtils do
   @headers [:host, :path_or_url]

  def split(line) do
    line
    |> String.strip
    |> String.replace("&amp;", "&")
    |> String.split("\t")
    |> Enum.map(&String.strip/1)
  end

  def clean(line, bad) do
    test =
      cond do
        2 != length(line) -> false
        true -> true
      end

    if not test do
      IO.write bad, "unclean " <> List.to_string(line) <> "\n"
    end
    test
  end

  def construct(line) do
    xs = Enum.zip(@headers, line)
    url =
      cond do
        # //example.com/page.html -> http://example.com/page.html
        String.starts_with?(xs[:path_or_url], "//") ->
          "http:" <> xs[:path_or_url]
        # http://example.com/page.html -> http://example.com/page.html
        String.starts_with?(xs[:path_or_url], "http") ->
          xs[:path_or_url]
        # /example.com/page.html -> http://example.com/page.html
        String.starts_with?(xs[:path_or_url], "/") ->
          "http://" <> xs[:host] <> xs[:path_or_url]
        # page.html -> http://example.com/page.html
        true ->
          "http://" <> xs[:host] <> "/" <> xs[:path_or_url]
      end
    url
  end
end