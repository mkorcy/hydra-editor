module RecordsHelperBehavior
  
  def metadata_help(key)
    I18n.t("hydra_editor.form.metadata_help.#{key}", default: key.to_s.humanize)
  end

  def field_label(key)
    I18n.t("hydra_editor.form.field_label.#{key}", default: key.to_s.humanize)
  end

  def model_label(key)
    I18n.t("hydra_editor.form.model_label.#{key}", default: key.to_s.humanize)
  end

  def object_type_options
    @object_type_options ||= HydraEditor.models.inject({}) do |h, model|
        label = model_label(model)
        h["#{label[0].upcase}#{label[1..-1]}"] = model
        h
    end
  end

  def render_edit_field_partial(key, locals)
    render_edit_field_partial_with_action('records', key, locals)
  end

  def add_field (key)
    more_or_less_button(key, 'adder', '+')
  end

  def subtract_field (key)
    more_or_less_button(key, 'remover', '-')
  end

  def record_form_action_url(record)
    router = respond_to?(:hydra_editor) ? hydra_editor : self
    record.new_record? ? router.records_path : router.record_path(record)
  end

  def new_record_title
    I18n.t('hydra_editor.new.title') % model_label(params[:type])
  end

  def edit_record_title
    I18n.t('hydra_editor.edit.title') % render_record_title
  end

  def render_record_title
    Array(@record.title).first
  end

 private 

  def render_edit_field_partial_with_action(action, key, locals)
    if lookup_context.find_all("#{action}/edit_fields/_#{key}").any?
      render :partial => "#{action}/edit_fields/#{key}", :locals=>locals.merge({key: key})
    else
      render :partial => "#{action}/edit_fields/default", :locals=>locals.merge({key: key})
    end
  end
  
  def more_or_less_button(key, html_class, symbol)
    # TODO, there could be more than one element with this id on the page, but the fuctionality doesn't work without it.
    content_tag('button', class: "#{html_class} btn", id: "additional_#{key}_submit", name: "additional_#{key}") do
      (symbol + 
      content_tag('span', class: 'accessible-hidden') do
        "add another #{key.to_s}"
      end).html_safe
    end
  end
  
end
