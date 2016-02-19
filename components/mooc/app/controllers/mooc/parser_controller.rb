module Mooc
  class ParserController < Shared::ApplicationController

    def parser
      status_case = 'nothing'
      saved_flags = { course: false, section: false, subsection: false, unit: false }
      content     = params[:content]

      Shared::Category.transaction do
        unit_by_lti = Shared::Category.where({ lti_id: params[:lti_id] }).first

        if unit_by_lti.nil? || unit_by_lti.parent.nil?
          root                                 = Shared::Category.where({ name: 'root' }).first
          course, saved_flags[:course]         = create_category_if_not_exist(params[:course_id], params[:course_name], root)
          section, saved_flags[:section]       = create_category_if_not_exist(params[:section_id], params[:section_name], course)
          subsection, saved_flags[:subsection] = create_category_if_not_exist(params[:subsection_id], params[:subsection_name], section)
        end

        if unit_by_lti.nil?
          status_case        = 'no_lti'
          unit               = Shared::Category.create({ uuid: params[:unit_id], lti_id: params[:lti_id], name: params[:unit_name], parent: subsection, askable: true })
          saved_flags[:unit] = unit.save
        elsif unit_by_lti.parent.nil?
          status_case        = 'lti_but_no_parent'

          unit_by_lti.update({ uuid: params[:unit_id], name: params[:unit_name], parent: subsection })
          saved_unit         = unit_by_lti.save
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
