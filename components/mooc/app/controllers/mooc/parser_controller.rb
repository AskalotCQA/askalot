module Mooc
  class ParserController < ::Shared::ApplicationController
    skip_before_filter :verify_authenticity_token
    skip_before_filter :login_required

    def parser
      status_case = 'nothing'
      saved_flags = { course: false, section: false, subsection: false, unit: false }

      unit = Shared::Category.in_contexts(Shared::Context::Manager.current_context_id).where({ lti_id: params[:lti_id] }).first

      if !unit.nil? && unit.name == 'unknown'
        course, saved_flags[:course]         = create_category_if_not_exist(params[:course_id], params[:course_name], nil)
        section, saved_flags[:section]       = create_category_if_not_exist(params[:section_id], params[:section_name], course)
        subsection, saved_flags[:subsection] = create_category_if_not_exist(params[:subsection_id], params[:subsection_name], section)

        unit.update({ uuid: params[:unit_id], name: params[:unit_name], parent: subsection })
        unit.save

        status_case = 'unit_updated'
      end

      category_content = Mooc::CategoryContent.where(category: unit).first

      Mooc::CategoryContent.create(category: unit, content: params[:content]) if category_content.nil?
      category_content.update(content: params[:content]) if category_content && category_content.content.empty?

      render json: { status: 'success', case: status_case, flags: saved_flags }
    end

    def options
      render nothing: true, status: 200, content_type: 'text/html'
    end

    private

    def create_category_if_not_exist(uuid, name, parent)
      category = Shared::Category.in_contexts(Shared::Context::Manager.current_context_id).where({ uuid: uuid }).first

      if category.nil?
        category = Shared::Category.create({ uuid: uuid, name: name, parent: parent, visible: false })
        saved_category = category.save
      elsif category.name == 'unknown'
        category.update({ name: name, parent: parent })
        saved_category = category.save
      end

      [category, saved_category]
    end
  end
end
