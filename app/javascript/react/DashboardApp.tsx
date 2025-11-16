import React from "react";
import { useGetStatusQuery } from "./store/api/statusApiSlice";

interface DashboardAppProps {
  message?: string;
}

const DashboardApp: React.FC<DashboardAppProps> = ({
  message = "Hello from React + TypeScript!",
}) => {
  const { isLoading, isSuccess, isError, error, data } = useGetStatusQuery();

  return (
    <div className="bg-gradient-to-br from-blue-800 to-purple-200 rounded-md shadow-lg p-8 text-white">
      <h2 className="text-3xl font-bold mb-4">React Dashboard Component</h2>
      <p className="text-lg mb-12">{message}</p>
      <p className="text-sm opacity-90">
        This component is compiled with TypeScript and styled with TailwindCSS!
      </p>
      <div className="mt-6 p-4 bg-white bg-opacity-20 rounded-md">
        <h3 className="text-xl font-semibold mb-2">API Status Check</h3>
      </div>
      {isLoading && <p>Loading status...</p>}
      {isError && error && (
        <p className="text-red-300">
          Error fetching status{": "}
          {typeof error === "string" ? error : JSON.stringify(error)}
        </p>
      )}
      {isSuccess && data && (
        <p className="text-green-300">
          API Status: <strong>{data.entities.app_status?.status}</strong>
        </p>
      )}
    </div>
  );
};

export default DashboardApp;
