defmodule Benchmark do
  def measure(function) do
    function
    |> :timer.tc
    |> elem(0)
    |> Kernel./(1_000_000)
  end
end

defmodule Fabric do
  def start() do
    spawn(__MODULE__, :endorsor, [])
  end

  def add_trans(fabric, key, value ) do
    ref = make_ref()
    send(fabric,{:proposal, self(), ref, key, value})
    receive do
      {:ok, ^ref, rwset} -> rwset
    end

  end

  def endorsor() do
    receive do
      {:proposal, sender, ref, key, value} ->
        send(sender, {:ok, ref , key})
        endorsor()
    end
  end

end

defmodule Middleware do

  def start(count) when is_integer(count) do
    fabric = Fabric.start()
    acc = 0
    IO.puts("start-1")
    start_time = System.system_time(:second)
    loop(fabric, count, acc)
    end_time = System.system_time(:second)
    IO.puts(to_string(end_time - start_time))
    IO.puts("start-2")

  end

  def start_transaction(fabric, key, value) do
    Fabric.add_trans(fabric, key,value)
  end

  defp loop( fabric, count, acc) do
    if acc <= count do
      start_transaction(fabric, to_string(acc),to_string(acc))
      loop(fabric, count, acc+1)
    end
  end

end

Middleware.start(32000000)