  # Ensure generators use UUID columns for PKs and references
  Rails.application.config.generators do |g|
    g.orm :active_record, primary_key_type: :uuid
  end

  # When migrations call create_table with id: :uuid, make the DB default uuidv7()
  module UuidV7PrimaryKeyDefault
    def primary_key(name, type = :primary_key, **options)
      if type == :uuid
        options[:default] ||= -> { "uuidv7()" }  # PG 18 builtin
      end
      super
    end
  end

  # Patch the PostgreSQL table definition class once ActiveRecord (and the
  # adapter) have been loaded. Doing this at boot time caused NameError when
  # ActiveRecord constants were not yet defined.
  ActiveSupport.on_load(:active_record) do
    begin
      if defined?(ActiveRecord::ConnectionAdapters::PostgreSQL::TableDefinition)
        ActiveRecord::ConnectionAdapters::PostgreSQL::TableDefinition.prepend(UuidV7PrimaryKeyDefault)
      end
    rescue NameError
      # Adapter not available; skip patching.
    end
  end
