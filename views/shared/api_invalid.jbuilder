json._error do
  json.message @record.errors[:base].join(', ') if @record.errors.keys.include?(:base)
  json.reason reason if defined?(reason) && reason.present?
  json.detail detail if defined?(detail) && detail.present?
end

@record.errors.keys.each do |key|
  next if key == :base
  json.set! key, @record.errors.full_messages_for(key).join(', ')
end

if @other_records.present?

  if @other_records.is_a?(Array)
    @other_records.compact.each do |record|
      record.errors.keys.each do |key|
        next if key == :base
        json.set! key, record.errors.full_messages_for(key).join(', ')
      end
    end
  elsif @other_records.is_a?(Hash)
    @other_records.each do |attr, records|
      json.set! attr, records do |record|
        json.null! if record.errors.empty?
        record.errors.keys.each do |key|
          next if key == :base
          json.set! key, record.errors.full_messages_for(key).join(', ')
        end
      end # end of set!
    end
  end

end
