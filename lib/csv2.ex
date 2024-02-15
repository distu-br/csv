defmodule Csv2 do
  @spec parse2(binary()) :: {:ok, [map()]} | {:error, String.t()}
  def parse2(file_path) do
     case csv_Validation(file_path) do
       {:ok, content} -> tuple_creator(content)
       {:error, reason} -> {:error, reason}
     end
  end


defp csv_Validation(file_path) do
  case File.read(file_path) do
    {:ok, ""} -> {:error, "File is empty"} #Caso o arquivo esteja vazio
    {:ok, content} -> {:ok, content}
    {:error, _reason} -> {:error, "File not found"} #Arquivo Não encontrado
  end
end

defp tuple_creator(content) do
  case String.split(content, "\n") do #Divide as linhas do arquivo
  [header | data_lines] -> #Separa a primeira linha do arquivo para o cabeçalho e o resto para os dados
    columns = String.split(String.trim_trailing(header, "\r"), ",") # Separa as colunas usando as virgulas
    case Enum.all?(data_lines, fn line -> length(String.split(line, ",")) == length(columns) end) do #Checa se tem a mesma quantidade de linhas e colunas
      true ->
        parsed_data = data_lines
        |> Enum.map(&String.trim_trailing(&1, "\r")) #Retira o caracter de retorno do resultado final (/r)
        |> Enum.map(&String.split(&1, ","))
        |> Enum.map(fn line -> Enum.zip(columns, line)
                               |> Enum.into(%{}) end) # Utiliza uma função anonima para juntar os headers com os dados e os coloca em tuplas
        {:ok, parsed_data}
      false ->
        {:error, "Invalid CSV"}
    end
  end
end
end
