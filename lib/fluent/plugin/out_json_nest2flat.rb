module Fluent
    class JsonNestToFlatOutput < Fluent::Output
        Fluent::Plugin.register_output('json_nest2flat', self)

        config_param :tag, :string, :default => nil
        config_param :add_tag_prefix, :string, :default => nil
        config_param :json_keys, :string, :default => nil
        config_param :ignore_item_keys, :string, :default => nil

        def configure(conf)
            super

            @json_keys = conf['json_keys']
            if @json_keys.nil?
                raise Fluent::ConfigError, "json_keys is required!"
            end

            @tag = conf['tag']
            @add_tag_prefix = conf['add_tag_prefix']
            if @tag.nil? && @add_tag_prefix.nil?
                raise Fluent::ConfigError, "tag or add_tag_prefix is required!"
            end

            @enabled_tag = false
            if !@tag.nil?
                @enabled_tag = true
            end

            @json_keys = @json_keys.split(",")

            @ignore_item_keys = conf['ignore_item_keys']

            if !@ignore_item_keys.nil?
                begin
                    @ignore_item_keys = JSON.parse(@ignore_item_keys)
                rescue => e
                   raise Fluent::ConfigError, "ignore_item_keys is illegal! ignore_item_keys=#{@ignore_item_keys}"
                end
            end
        end

        def emit(tag, es, chain)
            es.each { |time, record|
                chain.next

                new_record = _convert_record(record);

                if @enabled_tag
                    Fluent::Engine.emit(@tag, time, new_record)
                else
                    Fluent::Engine.emit("#{@add_tag_prefix}.#{tag}", time, new_record)
                end 
            }
        end

        # ネストされたJSONをフラットな構造に変換します。
        # ネストされた元のJSONは削除し、フラットな構造にした値群に差し替えます。
        # @param [Hash] old_record 元のレコード
        # @return [Hash] ネストされたJSONをフラットな構造に変換したレコード
        private
        def _convert_record(old_record)
            new_record = {}
            json_keys_exist_count = 0

            old_record.each { |old_record_k, old_record_v|
                if @json_keys.include?(old_record_k)
                    json_data = old_record[old_record_k]
                    begin
                        JSON.parse(json_data).each { |json_k, json_v|
                            if @ignore_item_keys.include?(old_record_k)
                                # 無視するキーに該当
                                ignore_items = @ignore_item_keys[old_record_k]
                                if ignore_items.include?(json_k)
                                    # 無視するアイテムに該当するのでハッシュに含まない
                                    next
                                end
                            end
                            new_record[json_k] = json_v
                        }
                    rescue => e
                        $log.error "json_data is parse error.json_data=#{json_data}", :error=>e.to_s
                        raise
                    end

                    json_keys_exist_count += 1
                else
                    new_record[old_record_k] = old_record_v
                end
            }

            unless json_keys_exist_count > 0
                $log.warn "json_keys is not found."
            end

            return new_record
        end
    end
end