defmodule Csv do
  @moduledoc """
  A função parse/1 deve receber o nome de um arquivo CSV no disco.

  Um arquivo CSV é formado por:
  - Uma linha de cabeçalho, que contém o nome das colunas
  - Uma ou mais linhas de dados, onde cada linha contém os valores das colunas

  Após a leitura do arquivo, a função deve retornar uma lista de mapas, onde cada mapa representa uma linha de dados.

  Para isso, a função deve detectar a primeira linha, separar em vírgulas, e depois criar um mapa com
  as chaves sendo os nomes das colunas e os valores sendo os valores das colunas.

  Se o arquivo não existir, a função deve retornar {:error, "File not found"}

  Se o arquivo estiver vazio, a função deve retornar {:error, "File is empty"}

  Se o arquivo não estiver no formato correto, ou seja, se alguma das linhas tiver um número diferente de colunas,
  a função deve retornar {:error, "Invalid CSV"}.

  Você pode assumir que o valor das colunas não contém nenhuma vírgula.
  """

  @spec parse(binary()) :: {:ok, [map()]} | {:error, String.t()}
  def parse(_file) do

    #check if file exits and if its empty
    case File.stat(_file) do
      {:ok, %{:size => size}} ->
        if size == 0 do
          raise "File is empty"
        end
      {:error, _} ->
        raise "File not found"
    end

    #transform file data into a list of lists
    rawData = _file
    |> File.stream!()
    |> Enum.map(&String.trim/1)
    |> Enum.map(&String.split(&1, ","))

    #check if all lines have the same length
    Enum.all?(rawData, fn sublist -> length(sublist) == length(Enum.at(rawData, 0)) end) || raise "Invalid CSV"

    #maps the names of the columns
    mapColumnNames = rawData
    |> Enum.fetch!(0)
    |> Enum.with_index()
    |> Map.new(fn {val, num} -> {num, val} end)


  end

end
