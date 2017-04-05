# frozen_string_literals: true
require "openxml/elements/common_slide_data"

module OpenXml
  module Pptx
    module Parts
      class SlideLayout < OpenXml::Part
        attr_accessor :relationships, :master
        private :relationships=, :master=

        def self.default_relationships
          @default_relationships ||= {}
        end

        def self.relationship(type, target)
          self.default_relationships.store(type, target)
        end

        relationship("http://schemas.openxmlformats.org/officeDocument/2006/relationships/slideMaster",
                     "../slideMasters/slideMasterBasic.xml")

        def initialize(master)
          self.relationships = OpenXml::Parts::Rels.new
          self.master = master

          self.class.default_relationships.each_pair do |type, target|
            add_relationship type, target
          end
        end

        def add_relationship(type, target)
          relationships.add_relationship(type, target)
        end

        def add_to(ancestors)
          parent, *rest = ancestors

          master.add_to(ancestors)

          parent.add_part rest, "slideLayouts/slideLayoutBasic.xml", self
          parent.add_part rest, "slideLayouts/_rels/slideLayoutBasic.xml.rels", relationships
          parent.add_override rest, "slideLayouts/slideLayoutBasic.xml", "application/vnd.openxmlformats-officedocument.presentationml.slideLayout+xml"
        end

        def common_slide_data
          OpenXml::Pptx::Elements::CommonSlideData.new.tap do |common_slide_data|
            common_slide_data.name = "Blank"
          end
        end

        def to_xml
          build_standalone_xml do |xml|
            xml.sldLayout(namespaces) do
              xml.parent.namespace = :p
              common_slide_data.to_xml(xml)
            end
          end
        end

        private def namespaces
          {
            "xmlns:a": "http://schemas.openxmlformats.org/drawingml/2006/main",
            "xmlns:r": "http://schemas.openxmlformats.org/officeDocument/2006/relationships",
            "xmlns:p": "http://schemas.openxmlformats.org/presentationml/2006/main",
            "type": "blank",
            "preserve": "1",
          }
        end
      end
    end
  end
end