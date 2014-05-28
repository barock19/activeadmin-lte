module ActiveAdmin
  module LTE
    module Injectors
      module ViewHelpers
        # Helper method to render a filter form
        def active_admin_filters_form_for(search, filters, options = {})
          puts "ActiveAdminFilerFromFor- LTE"
          defaults = { builder: ActiveAdmin::Filters::FormBuilder,
                       url: collection_path,
                       html: {class: 'filter_form'} }
          required = { html: {method: :get},
                       as: :q }
          options  = defaults.deep_merge(options).deep_merge(required)

          form_for search, options do |f|
            filters.each do |attribute, opts|
              next if opts.key?(:if)     && !call_method_or_proc_on(self, opts[:if])
              next if opts.key?(:unless) &&  call_method_or_proc_on(self, opts[:unless])
              f.filter attribute, opts.except(:if, :unless)
            end

            clear_filter = url_for(params.except(:q, :page, :commit,:utf8))
            buttons = content_tag :div, class: "actions" do
              f.submit(I18n.t('active_admin.filters.buttons.filter'), class: 'btn btn-info') +
                link_to(I18n.t('active_admin.filters.buttons.clear'), clear_filter, class: 'clear_filters_btn btn btn-default') +
                hidden_field_tags_for(params, except: [:q, :page])
            end

            final_buffer = <<-END.strip_heredoc.html_safe
              <div class="filter-wrapper">
                #{f.form_buffers.last}
              </div>
              #{buttons}
            END
            final_buffer
          end
        end
      end
    end
  end
end

ActiveAdmin::ViewHelpers.send :include, ActiveAdmin::LTE::Injectors::ViewHelpers