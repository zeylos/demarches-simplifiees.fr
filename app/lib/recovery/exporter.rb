module Recovery
  class Exporter
    FILE_PATH = Rails.root.join('lib', 'data', 'export.dump')

    attr_reader :dossiers
    def initialize(dossier_ids:, file_path: FILE_PATH)
      dossier_with_data = Dossier.where(id: dossier_ids)
        .preload(:user,
                 :individual,
                 :invites,
                 :traitements,
                 :transfer_logs,
                 commentaires: { piece_jointe_attachment: :blob },
                 avis: { introduction_file_attachment: :blob, piece_justificative_file_attachment: :blob },
                 dossier_operation_logs: { serialized_attachment: :blob },
                 attestation: { pdf_attachment: :blob },
                 justificatif_motivation_attachment: :blob,
                 etablissement: :exercices,
                 revision: :procedure)
      @dossiers = DossierPreloader.new(dossier_with_data).all
      @file_path = file_path
    end

    def dump
      File.open(@file_path, 'wb') { _1.write(Marshal.dump(@dossiers)) }
    end
  end
end
