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
def parse(file_path) do
  case File.read(file_path) do #Le o arquivo
    {:ok, ""} -> {:error, "File is empty"} #Caso o arquivo esteja vazio
    {:ok, content} ->
    case String.split(content, "\n") do #Divide as linhas do arquivo
      [header | data_lines] -> #Separa a primeira linha do arquivo para o cabeçalho e o resto para os dados
      columns = String.split(String.trim_trailing(header, "\r"), ",") # Separa as colunas usando as virgulas
      case Enum.all?(data_lines, fn line -> length(String.split(line, ",")) == length(columns) end) do #Checa se tem a mesma quantidade de colunas em todas as linhas
        true ->
          parsed_data = data_lines
          |> Enum.map(&String.trim_trailing(&1, "\r"))
          |> Enum.map(&String.split(&1, ","))
          |> Enum.map(fn line -> Enum.zip(columns, line)
                               |> Enum.into(%{}) end) # Utiliza uma função anonima para juntar os headers com os dados e os coloca em tuplas
          {:ok, parsed_data}
        false ->
          {:error, "Invalid CSV"}
      end
    end
    {:error, _reason} -> {:error, "File not found"} #Arquivo Não encontrado
  end
end
end

# C:/Users/User/OneDrive/Área de Trabalho/csv_Vinicius/test/fixtures/cities.csv
