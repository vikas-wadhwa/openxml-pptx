module OpenXml
  module Elements
    class Latin < OpenXml::Element
      namespace :a
      tag :latin
      attribute :typeface, expects: :string

      def initialize(typeface)
        self.typeface = typeface
      end
    end
  end
end