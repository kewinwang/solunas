class FreeRoom < ActionWebService::Struct
  member :id, :int
  member :name, :string
  member :property, :string
  member :price, :float
  #member :addons, :string
end