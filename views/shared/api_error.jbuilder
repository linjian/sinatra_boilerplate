json._error do
  json.code code if defined?(code) && code.present?
  json.message message
  json.reason reason if defined?(reason) && reason.present?
  json.detail detail if defined?(detail) && detail.present?
end
