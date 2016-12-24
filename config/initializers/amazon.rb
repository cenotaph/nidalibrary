Amazon::Ecs.configure do |options|
  options[:AWS_access_key_id] = Figaro.env.amazon_access_key
  options[:AWS_secret_key] = Figaro.env.amazon_secret_key
  options[:associate_tag] = Figaro.env.amazon_associate_tag
end
