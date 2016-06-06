defmodule Kv do
  use Application
  import Supervisor.Spec, warn: false

  def start(_type, _args) do
    children = [
      supervisor(Kv.Repo, []),
      worker(Kv.Worker, [])
    ]
    options = [strategy: :one_for_one, name: Kv.Supervisor]
    Supervisor.start_link(children, options)
  end

  defdelegate set(k, v), to: Kv.Worker
  defdelegate get(k), to: Kv.Worker
  defdelegate clear, to: Kv.Worker
end
