Exception.class_eval do
  def hint
    "#{self.class}: #{message}\n" \
    "from #{backtrace.try(:first)}"
  end
end
