module PDC::V1
  class Arch < PDC::Base
    self.primary_key = :name
    attributes :name
  end
end
