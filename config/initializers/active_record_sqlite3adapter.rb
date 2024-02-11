module RailsExt
  module SQLite3Adapter
    # Perform any necessary initialization upon the newly-established
    # @raw_connection -- this is the place to modify the adapter's
    # connection settings, run queries to configure any application-global
    # "session" variables, etc.
    #
    # Implementations may assume this method will only be called while
    # holding @lock (or from #initialize).
    #
    # https://github.com/rails/rails/blob/main/activerecord/lib/active_record/connection_adapters/sqlite3_adapter.rb#L691
    def configure_connection
      if @config[:timeout] && @config[:retries]
        raise ArgumentError, "Cannot specify both timeout and retries arguments"
      elsif @config[:retries]
        # https://www.sqlite.org/c3ref/busy_handler.html
        # https://sqlite.org/forum/info/3fd33f0b9be72353
        # sqliteDefaultBusyCallback
        # https://sqlite.org/src/file?name=src/main.c&ci=trunk
        @raw_connection.busy_handler do |count|
          count <= @config[:retries]
        end
      end

      super

      @config[:pragmas].each do |key, value|
        raw_execute("PRAGMA #{key} = #{value}", "SCHEMA")
      end
    end
  end
end

# Enhance the SQLite3 ActiveRecord adapter with optimized defaults and extensions
ActiveSupport.on_load(:active_record_sqlite3adapter) do
  # self refers to `SQLite3Adapter` here,
  # so we can call .prepend
  prepend RailsExt::SQLite3Adapter
end
