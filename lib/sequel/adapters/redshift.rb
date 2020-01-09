require 'sequel/adapters/postgres'

module Sequel
  module Redshift
    include Postgres

    class Dataset < Postgres::Dataset

      # Redshift doesn't support RETURNING statement
      def insert_returning_sql(sql)
        # do nothing here
        sql
      end
    end

    class Database < Postgres::Database
      set_adapter_scheme :redshift

      def column_definition_primary_key_sql(sql, column)
        result = super
        result << ' IDENTITY' if result
        result
      end

      def serial_primary_key_options
        # redshift doesn't support serial type
        super.merge(serial: false)
      end

      private

      def dataset_class_default
        Sequel::Redshift::Dataset
      end
    end
  end
end
