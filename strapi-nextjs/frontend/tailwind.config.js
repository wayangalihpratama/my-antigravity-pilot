/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    "./pages/**/*.{js,ts,jsx,tsx,mdx}",
    "./components/**/*.{js,ts,jsx,tsx,mdx}",
    "./app/**/*.{js,ts,jsx,tsx,mdx}",
  ],
  theme: {
    extend: {
      colors: {
        primary: {
          50: "#f0f9f9",
          100: "#d9f2f2",
          200: "#b7e4e4",
          300: "#8aced0",
          400: "#58adb1",
          500: "#3d9196",
          600: "#32767b",
          700: "#2c6165",
          800: "#284f53",
          900: "#254447",
          950: "#11282b",
        },
      },
    },
  },
  plugins: [],
};
