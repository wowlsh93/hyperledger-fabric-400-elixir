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

  def add_trans(key,value) do
    ref = make_ref()
    send(key,value,{:proposal, self(), ref})
    receive do
      {:ok, ^ref, rwset} -> IO.puts(rwset)
    end
  end

  def endorsor() do
    receive do
      {:proposal, sender, ref} ->
        sned(sender, {:ok, ref , "rwset"})
        endorsor()
    end
  end

end

defmodule Middleware do

  def start(count) when is_integer(count) do
    Fabric.start("org1")
    acc = 0
    IO.puts("start-1")
    start_time = System.system_time(:second)
    loop(count, acc)
    end_time = System.system_time(:second)
    IO.puts(to_string(end_time - start_time))
    IO.puts("start-2")

  end

  def start_transaction(key, value) do
    Fabric.add_trans(key,value)
  end

  defp loop(count, acc) do
    if acc <= count do
      start_transaction(to_string(acc),to_string(acc))
      loop(count, acc+1)
    end
  end

end

Middleware.start(32000000)