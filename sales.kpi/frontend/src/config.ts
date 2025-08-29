// In production, use relative URLs since frontend and backend are served from same origin
export const API_BASE_URL = import.meta.env.VITE_API_URL || 
  (window.location.hostname === 'localhost' ? 'http://localhost:5001' : '');