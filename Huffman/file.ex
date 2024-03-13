defmodule FileWriter do
  def write_to_file(filename, charlist) do
    case File.open(filename, [:write]) do
      {:ok, file} ->
        :file.write(file, charlist)
        File.close(file)
        {:ok, "Data successfully written to #{filename}"}
      {:error, reason} ->
        {:error, reason}
    end
  end
end
