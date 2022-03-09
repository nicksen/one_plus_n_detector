defmodule OnePlusNDetector.ConfigUtils do
  defmacro __using__(opts) do
    quote bind_quoted: [opts: opts] do
      import OnePlusNDetector.ConfigUtils
      @otp_app Keyword.fetch!(opts, :otp_app)

      def env, do: app_env(:env)

      def app_env(key) do
        OnePlusNDetector.ConfigUtils.app_env(@otp_app, key)
      end

      defmacro env_specific!(conf) do
        quote do
          unquote(
            Keyword.get_lazy(
              conf,
              Mix.env(),
              fn -> Keyword.fetch!(conf, :else) end
            )
          )
        end
      end
    end
  end

  defdelegate app_env(app, key), to: Application, as: :get_env
  defdelegate app_env(app, key, default), to: Application, as: :get_env

  defdelegate os_env(name), to: System, as: :get_env
  defdelegate os_env(name, default), to: System, as: :get_env

  defdelegate os_env!(name), to: System, as: :fetch_env!
end
