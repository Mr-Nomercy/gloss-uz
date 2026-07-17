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
        },
      },
    },
  },
  plugins: [],
}
