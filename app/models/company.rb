class AbstractCompany < ApplicationRecord
  self.abstract_class = true
end

class Company < AbstractCompany

end


class DependentFirm < Company
  has_many :companies, foreign_key: "client_of", dependent: :nullify
end

class Client < Company
end
