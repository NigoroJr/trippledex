models = %w( payment_debtor debt person payment )

models.each do |model|
  path = File.join(Rails.root, "db/seeds/#{model}.rb")

  require path
end
