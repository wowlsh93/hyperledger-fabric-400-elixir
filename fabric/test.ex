defmodule Benchmark do
  def measure(function) do
    function
    |> :timer.tc
    |> elem(0)
    |> Kernel./(1_000_000)
  end
end

defmodule ForLoop do

  def for_loop(count) when is_integer(count) do
    acc = 0
    IO.puts("start-1")
    start_time = System.system_time(:second)
    loop(count, acc)
    end_time = System.system_time(:second)
    IO.puts(to_string(end_time - start_time))
    IO.puts("start-2")

  end

  def start_transaction(key, value) do

  end

  defp loop(count, acc) do
    if acc <= count do
      start_transaction(to_string(acc),to_string(acc))
      loop(count, acc+1)
    end
  end

end

ForLoop.for_loop(32000000)