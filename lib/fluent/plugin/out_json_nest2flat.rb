module Fluent
    class JsonNestToFlatOutput < Fluent::Output

        Fluent::Plugin.register_output('json_nest2flat', self)

        config_param :tag, :string, :default => 'json_nest2flat'
        config_param :json_keys, :string, :default => nil

        def configure(conf)
            super

            @json_keys = conf['json_keys']
            if @json_keys.nil?
                raise Fluent::ConfigError, "json_keys is undefined!"
            end

            @tag = conf['tag']
            @json_keys = @json_keys.split(",")
        end

        def emit(tag, es, chain)
            es.each { |time, record|
                chain.next

                new_record = _convert_record(record);

                Fluent::Engine.emit(@tag, time, new_record)
            }
        end

        # ネストされたJSONをフラットな構造に変換します。
        # ネストされた元のJSONは削除し、フラットな構造にした値群に差し替えます。
        # @param [Hash] old_record 元のレコード
        # @return [Hash] ネストされたJSONをフラットな構造に変換したレコード
        private
        def _convert_record(old_record)
            new_record = Hash.new([])
            json_keys_exist_count = 0

            old_record.each { |old_record_k, old_record_v|
                if (@json_keys.include?(old_record_k))
                    json_data = old_record[old_record_k]
                    JSON.parse(json_data).each { |json_k, json_v|
                        new_record[json_k] = json_v
                    }

                    json_keys_exist_count += 1
                else
                    new_record[old_record_k] = old_record_v
                end
            }

            unless json_keys_exist_count == 0
                $log.warn "json_keys is not found."
            end

            return new_record
        end

    end
end