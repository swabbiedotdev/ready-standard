// Supplementary file: payload types for the save endpoint (IF-SAVE-NOTE).
export interface SaveNoteRequest {
  text: string;
}

export interface SaveNoteResponse {
  note_id: string;
  created_at: string;
}
