# React Authentication Sample

This project is a React replication of the Vue authentication sample, built with Vite and Tailwind CSS.
It demonstrates using `@azure/msal-react` for authenticating with Azure AD.

## Features

- **React + Vite**: Fast and modern development experience.
- **Tailwind CSS**: Utility-first CSS framework (matching the Vue app styles).
- **MSAL React**: Microsoft Authentication Library for React.
- **Routing**: Client-side routing with `react-router-dom`.

## Setup

1.  **Install dependencies**:
    ```bash
    npm install
    ```

2.  **Environment Variables**:
    Ensure you have a `.env` or `.env.local` file with:
    ```
    VITE_CLIENTID=your_client_id
    VITE_TENANTID=your_tenant_id
    ```

3.  **Run Locally**:
    ```bash
    npm run dev
    ```

4.  **Build**:
    ```bash
    npm run build
    ```
