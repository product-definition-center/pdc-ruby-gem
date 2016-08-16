
# module PDC
#   class Base
#     include ActiveAttr::Model
#     include Resource::Identity
#   end
# end
#
# module PDC::V1
#   class Release < PDC::Base
#     attribute :first_name
#     attribute :last_name
#   end
# end
#
#
#
#
# describe PDC::V1::Release do
#   let(:release_class) { PDC::V1::Release }
#   it 'works' do
#     person = release_class.new
#     person.first_name = "Chris"
#     person.last_name = "Griego"
#     person.attributes #=> {"first_name"=>"Chris", "last_name"=>"Griego"}
#     person.first_name = "Chris"
#     person.last_name = "Griego"
#     require 'pry'; binding.pry
#     person.attributes #=> {"first_name"=>"Chris", "last_name"=>"Griego"}
#   end
# end
#
#
