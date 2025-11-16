import { createRoot } from "react-dom/client";
import { store } from "./store/store";
import { Provider } from "react-redux";
import DashboardApp from "./DashboardApp";
import React from "react";

const container = document.getElementById("react-dashboard-root");

if (container) {
  const root = createRoot(container);

  root.render(
    <React.StrictMode>
      <Provider store={store}>
        <DashboardApp />
      </Provider>
    </React.StrictMode>
  );
} else {
  throw new Error(
    "Root element with ID 'react-dashboard-root' was not found in the document. Ensure there is a corresponding HTML element with the ID 'react-dashboard-root' in your HTML file."
  );
}
