class GroupeGestionnaire::GroupeGestionnaireAdministrateurs::AdministrateurComponent < ApplicationComponent
  include ApplicationHelper

  def initialize(groupe_gestionnaire:, administrateur:, is_gestionnaire: true)
    @groupe_gestionnaire = groupe_gestionnaire
    @administrateur = administrateur
    @is_gestionnaire = is_gestionnaire
  end

  def email
    if @administrateur == current_gestionnaire
      "#{@administrateur.email} (C’est vous !)"
    else
      @administrateur.email
    end
  end

  def created_at
    try_format_datetime(@administrateur.created_at)
  end

  def registration_state
    @administrateur.registration_state
  end

  def remove_button
    button_to 'Retirer',
      remove_gestionnaire_groupe_gestionnaire_administrateur_path(@groupe_gestionnaire, @administrateur),
      method: :delete,
      class: 'fr-btn fr-btn--sm fr-btn--tertiary',
      form: { data: { turbo: true, turbo_confirm: "Retirer « #{@administrateur.email} » des administrateurs de « #{@groupe_gestionnaire.name} » ?" } }
  end

  def destroy_button
    button_to 'Supprimer',
      gestionnaire_groupe_gestionnaire_administrateur_path(@groupe_gestionnaire, @administrateur),
      method: :delete,
      class: 'fr-btn fr-btn--sm fr-btn--tertiary',
      form: { data: { turbo: true, turbo_confirm: "Supprimer « #{@administrateur.email} » en tant qu'administrateurs ?" } }
  end
end
