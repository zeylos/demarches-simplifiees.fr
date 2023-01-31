class TypesDeChamp::PrefillRepetitionTypeDeChamp < TypesDeChamp::PrefillTypeDeChamp
  include ActionView::Helpers::UrlHelper
  include ApplicationHelper

  def possible_values
    prefillable_subchamps.map do |prefill_type_de_champ|
      if prefill_type_de_champ.too_many_possible_values?
        link = link_to I18n.t("views.prefill_descriptions.edit.possible_values.link.text"), Rails.application.routes.url_helpers.prefill_type_de_champ_path(prefill_type_de_champ.path, prefill_type_de_champ), title: ActionController::Base.helpers.sanitize(new_tab_suffix(I18n.t("views.prefill_descriptions.edit.possible_values.link.title"))), **external_link_attributes
        "#{prefill_type_de_champ.libelle}: #{link}"
      else
        "#{prefill_type_de_champ.libelle}: #{prefill_type_de_champ.possible_values_sentence}"
      end
    end
  end

  def possible_values_sentence
    "#{I18n.t("views.prefill_descriptions.edit.possible_values.#{type_champ}_html")}<br>#{possible_values.join("<br>")}".html_safe # rubocop:disable Rails/OutputSafety
  end

  def example_value
    [row_values_format, row_values_format].map { |row| row.to_s.gsub("=>", ":") }
  end

  private

  def row_values_format
    @row_example_value ||=
      prefillable_subchamps.map do |prefill_type_de_champ|
      [prefill_type_de_champ.libelle, prefill_type_de_champ.example_value.to_s]
    end.to_h
  end

  def prefillable_subchamps
    return [] unless active_revision_type_de_champ

    TypesDeChamp::PrefillTypeDeChamp.wrap(active_revision_type_de_champ.revision_types_de_champ.map(&:type_de_champ).filter(&:prefillable?))
  end
end
