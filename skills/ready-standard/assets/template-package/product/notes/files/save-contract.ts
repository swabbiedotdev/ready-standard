// Supplementary file: payload types for notes.save (operation notes.op.save).
export interface SaveNoteRequest {
  text: string;
}

export interface SaveNoteResponse {
  note_id: string;
  created_at: string;
}
