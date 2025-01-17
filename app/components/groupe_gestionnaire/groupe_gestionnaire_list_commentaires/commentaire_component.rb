class GroupeGestionnaire::GroupeGestionnaireListCommentaires::CommentaireComponent < ApplicationComponent
  include ApplicationHelper

  def initialize(groupe_gestionnaire:, commentaire:)
    @groupe_gestionnaire = groupe_gestionnaire
    @commentaire = commentaire
  end

  def email
    if @commentaire.sender == current_gestionnaire
      "Messages avec le groupe gestionnaire parent (#{@groupe_gestionnaire.parent.name})"
    else
      @commentaire.sender_email
    end
  end

  def created_at
    try_format_datetime(@commentaire.created_at)
  end

  def see_button
    link_to 'Voir',
      @commentaire.sender == current_gestionnaire ? parent_groupe_gestionnaire_gestionnaire_groupe_gestionnaire_commentaires_path(@groupe_gestionnaire) : gestionnaire_groupe_gestionnaire_commentaire_path(@groupe_gestionnaire, @commentaire),
      class: 'fr-btn fr-btn--sm fr-btn--tertiary'
  end

  def highlight?
    commentaire_seen_at = current_gestionnaire.commentaire_seen_at(@groupe_gestionnaire, @commentaire.sender_id, @commentaire.sender_type)
    commentaire_seen_at.nil? || commentaire_seen_at < @commentaire.created_at
  end
end
