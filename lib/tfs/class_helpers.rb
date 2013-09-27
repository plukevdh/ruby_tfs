module TFS
  module ClassHelpers
    def base_class(for_class=self)
      name = (Class === for_class) ? for_class.name : for_class
      name.split("::").last
    end

    def method_name_from_class(name=self.name)
      base_class(name).downcase
    end

    SPECIAL_CASES = { workitems: "WorkItems", areapaths: "AreaPaths", changesetmerges: "ChangesetMerges" }

    def odata_class_from_method_name(method_name)
      return SPECIAL_CASES[method_name] if SPECIAL_CASES.has_key? method_name
      method_name.to_s.capitalize
    end
  end
end