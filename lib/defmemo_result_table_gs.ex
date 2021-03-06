defmodule DefMemo.ResultTable.GS do
  @behaviour DefMemo.ResultTable

  @moduledoc """
    GenServer backing store for the results of the function calls.
  """
  use GenServer
   
  def start_link do 
    GenServer.start_link(__MODULE__, HashDict.new, name: :result_table)
  end
   
  def get(fun, args) do
    GenServer.call(:result_table, { :get, fun, args })
  end
    
  def put(fun, args, result) do
    GenServer.cast(:result_table, { :put, fun, args, result })
    result
  end

  def handle_call({ :get, fun, args }, _sender, dict) do
    reply(HashDict.fetch(dict, { fun, args }), dict)
  end
   
  def handle_cast({ :put, fun, args, result }, dict) do
    { :noreply,  HashDict.put(dict, { fun, args }, result) }
  end

  defp reply(:error, dict) do
    { :reply, { :miss, nil }, dict }
  end

  defp reply({:ok, val}, dict) do
   { :reply, { :hit, val }, dict }
  end

end
