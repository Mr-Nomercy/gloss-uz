/** @type {import('tailwindcss').Config} */
export default {
  content: ['./index.html', './src/**/*.{ts,tsx}'],
  theme: {
    extend: {
      colors: {
        gloss: {
          green: '#00AA13',
          'dark-green': '#004A00',
          bg: '#F5F5F5',
          card: '#FFFFFF',
          text: '#1A1A1A',
          hint: '#757575',
          'green-text': '#008A10',
          border: '#E0E0E0',
          red: '#E53935',
          orange: '#E65100',
          star: '#FFB300',
          'green-bg-light': '#F0FFF4',
          'green-bg-pale': '#E8F8E8',
        },
      },
      borderRadius: {
        'xl': '0.75rem',
        '2xl': '1rem',
        '3xl': '1.25rem',
      },
      boxShadow: {
        'gloss': '0 2px 10px rgba(0, 0, 0, 0.05)',
        'gloss-lg': '0 8px 30px rgba(0, 0, 0, 0.08)',
        'gloss-sm': '0 1px 4px rgba(0, 0, 0, 0.04)',
        'gloss-green': '0 4px 14px rgba(0, 170, 19, 0.2)',
      },
      animation: {
        'fade-in': 'fadeIn 0.3s ease-out',
        'slide-up': 'slideUp 0.35s ease-out',
        'slide-down': 'slideDown 0.3s ease-out',
        'scale-in': 'scaleIn 0.2s ease-out',
        'shimmer': 'shimmer 1.5s infinite',
      },
      keyframes: {
        fadeIn: {
          '0%': { opacity: '0' },
          '100%': { opacity: '1' },
        },
        slideUp: {
          '0%': { opacity: '0', transform: 'translateY(12px)' },
          '100%': { opacity: '1', transform: 'translateY(0)' },
        },
        slideDown: {
          '0%': { opacity: '0', transform: 'translateY(-8px)' },
          '100%': { opacity: '1', transform: 'translateY(0)' },
        },
        scaleIn: {
          '0%': { opacity: '0', transform: 'scale(0.95)' },
          '100%': { opacity: '1', transform: 'scale(1)' },
        },
        shimmer: {
          '0%': { backgroundPosition: '-200% 0' },
          '100%': { backgroundPosition: '200% 0' },
        },
      },
    },
  },
  plugins: [],
}