module Mooc
  class ParserController < ::Shared::ApplicationController
    skip_before_filter :verify_authenticity_token
    skip_before_filter :login_required

    def parser
      status_case = 'nothing'
      saved_flags = { course: false, section: false, subsection: false, unit: false }
      content     = params[:content]

      Shared::Category.transaction do
        unit = Shared::Category.where({ lti_id: params[:lti_id] }).first

        if unit.nil? || unit.parent.nil?
          course, saved_flags[:course]         = create_category_if_not_exist(params[:course_id], params[:course_name], nil)
          section, saved_flags[:section]       = create_category_if_not_exist(params[:section_id], params[:section_name], course)
          subsection, saved_flags[:subsection] = create_category_if_not_exist(params[:subsection_id], params[:subsection_name], section)
        end

        if unit.nil?
          status_case        = 'no_lti'
          unit               = Shared::Category.create({ uuid: params[:unit_id], lti_id: params[:lti_id], name: params[:unit_name], parent: subsection, askable: true })
          saved_flags[:unit] = unit.save
        elsif unit.parent.nil?
          status_case        = 'lti_but_no_parent'

          unit.update({ uuid: params[:unit_id], name: params[:unit_name], parent: subsection })
          unit.save
        end

        category_content = Mooc::CategoryContent.find_by_category_id(unit.id)
        if category_content.nil?
          Mooc::CategoryContent.create(category: unit, content: content)
        end
      end

      render json: {
                 status: 'success',
                 case: status_case,
                 flags: saved_flags
             }
    end

    def options
      render :nothing => true, :status => 200, :content_type => 'text/html'
    end

    private

    def create_category_if_not_exist(uuid, name, parent)
      category = Shared::Category.where({ uuid: uuid }).first

      if category.nil?
        category = Shared::Category.create({ uuid: uuid, name: name, parent: parent })
        saved_category = category.save
      end

      [category, saved_category]
    end
  end
end
