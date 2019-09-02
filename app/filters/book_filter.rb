class BookFilter
  include Minidusen::Filter

  filter :text do |scope, phrases|
    columns = [:title, :author, :subtitle, :catno]
    scope.where_like(columns => phrases)
  end

end