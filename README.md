# Suno Analytics Demo

A React-based portfolio website showcasing an analytics engineering project for Suno, featuring interactive dashboards with data visualizations using Recharts.

## Features

- Interactive analytics dashboards
- Data transformation pipeline visualization
- Interactive charts using Recharts
- Modern UI with Tailwind CSS
- Responsive design

## Getting Started

### Prerequisites

- Node.js (v16 or higher)
- npm or yarn

### Installation

1. Install dependencies:
```bash
npm install
```

2. Start the development server:
```bash
npm run dev
```

3. Open your browser and navigate to the URL shown in the terminal (typically `http://localhost:5173`)

### Build for Production

To create a production build:

```bash
npm run build
```

The built files will be in the `dist` directory. You can preview the production build with:

```bash
npm run preview
```

## Tech Stack

- **React** - UI library
- **Vite** - Build tool and dev server
- **Tailwind CSS** - Styling
- **Recharts** - Chart library
- **Lucide React** - Icons

## Project Structure

```
├── src/
│   ├── components/
│   │   └── SunoAnalyticsPipeline.jsx  # Main component
│   ├── App.jsx                         # App wrapper
│   ├── main.jsx                        # Entry point
│   └── index.css                       # Global styles
├── index.html                          # HTML template
├── package.json                        # Dependencies
├── vite.config.js                      # Vite configuration
├── tailwind.config.js                  # Tailwind configuration
└── postcss.config.js                   # PostCSS configuration
```

## Deployment

### Deploy to Vercel

This project is ready to deploy on Vercel. Here are three options:

#### Option 1: Vercel CLI (Recommended)
```bash
# Install Vercel CLI globally
npm i -g vercel

# Login to Vercel
vercel login

# Deploy
vercel
# For production: vercel --prod
```

#### Option 2: GitHub Integration
1. Push your code to GitHub
2. Go to [vercel.com](https://vercel.com)
3. Click "Add New..." → "Project"
4. Import your GitHub repository
5. Vercel will auto-detect Vite settings
6. Click "Deploy"

#### Option 3: Vercel Dashboard
1. Go to [vercel.com](https://vercel.com)
2. Click "Add New..." → "Project"
3. Import your Git repository
4. Configure (auto-detected):
   - Framework: Vite
   - Build Command: `npm run build`
   - Output Directory: `dist`
5. Click "Deploy"

Vercel will automatically:
- Detect your Vite project
- Build and deploy your app
- Provide HTTPS and a custom domain
- Create preview URLs for each deployment

## License

MIT

