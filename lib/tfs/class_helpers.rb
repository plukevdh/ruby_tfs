module TFS
  module ClassHelpers
    def base_class(for_class=self)
      name = (Class === for_class) ? for_class.name : for_class
      name.split("::").last
    end

    def method_name_from_class(name=self.name)
      base_class(name).downcase
    end
  end
end