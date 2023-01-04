class AbstractCompany < ApplicationRecord
  self.abstract_class = true
end

class Company < AbstractCompany

end


class DependentFirm < Company
  has_many :companies, foreign_key: "client_of", dependent: :nullify
end

class Client < Company
  belongs_to :firm, foreign_key: "client_of"
end

class Firm < Company
  has_many :clients, -> { order :id }
  has_many :clients_of_firm, foreign_key: "client_of", class_name: :Client
  has_many :plain_clients, class_name: :Client
  has_many :limited_clients, -> { limit 1 }, class_name: :Client
  has_many :clients_sorted_desc, -> { order "id DESC" }, class_name: :Client
end