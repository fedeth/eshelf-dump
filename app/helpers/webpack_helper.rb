module WebpackHelper

  def get_vue_components_registration
    code = ""
    execute_for_each_vue_component do |component_name, component_path|
      code += "
          import #{component_name} from \"#{component_path}\"
          Vue.component(\"#{component_name}\", #{component_name})
          "
    end
    code.html_safe
  end

  def execute_for_each_vue_component
    components_dir = get_components_dir
    component_basenames = [] # Prevent vue_component multiple registration.
    components_dir.each do |component_path|
      component_basename = File.basename(component_path)
      component_name = component_basename.gsub(/-/, "_").gsub(/\.(vue|vue.erb)$/, "").camelize

      unless component_basenames.include? component_basename
        component_basenames << component_basename
        yield(component_name, component_path) if block_given?
      end
    end
  end

  def get_components_dir
    components_dir = []
    eshelf_components_dir = Dir["./app/javascript/src/vue_components/eshelf_layouts/*.{vue,vue.erb}"]
    eshelf_components_dir += Dir["./app/javascript/src/vue_components/support_components/*.{vue,vue.erb}"]
    eshelf_components_dir += Dir["./app/javascript/src/vue_components/eshelf_static_layouts/*.{vue,vue.erb}"]
    eshelf_components_dir += Dir["./app/javascript/src/vue_components/eshelf_collection_layouts/*.{vue,vue.erb}"]
    components_dir += eshelf_components_dir.map do |eshelf_component_path|
      eshelf_component_path.gsub(/\.\/app\/javascript\//, "")
    end
    components_dir
  end

end