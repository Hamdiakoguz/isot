module Isot
  module CoreExt
    module String

      def self.snakecase(str)
        str.dup
           .gsub(/::/, "/")
           .gsub(/([A-Z]+)([A-Z][a-z])/, "\\1_\\2")
           .gsub(/([a-z\d])([A-Z])/, "\\1_\\2")
           .tr(".", "_")
           .tr("-", "_")
           .downcase
      end

    end
  end
end
