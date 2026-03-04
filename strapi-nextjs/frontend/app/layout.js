import "./globals.css";

export const metadata = {
  title: "Strapi-NextJS Stack",
  description: "A premium stack skeleton",
};

export default function RootLayout({ children }) {
  return (
    <html lang="en">
      <body className="antialiased">{children}</body>
    </html>
  );
}
