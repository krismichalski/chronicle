json.array!(@books) do |book|
  json.extract! book, :id, :title, :publisher, :author
  json.url book_url(book, format: :json)
end
