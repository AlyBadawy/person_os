import { createEntityAdapter } from "@reduxjs/toolkit";
import { apiSlice } from "./ApiSlice";

export type Status = {
  id: string;
  status: string;
};

const statusAdapter = createEntityAdapter<Status>();

const initialState = statusAdapter.getInitialState();

type StatusState = ReturnType<typeof statusAdapter.getInitialState>;

export const statusApiSlice = apiSlice.injectEndpoints({
  endpoints: (build) => ({
    getStatus: build.query<StatusState, void>({
      query: () => "/status",
      transformResponse: (response: { status: string }) => {
        // server returns a single status object (no id). Normalize into an entity with a fixed id.
        const entity: Status = { id: "app_status", status: response.status };
        return statusAdapter.setOne(initialState, entity);
      },
      providesTags: [{ type: "Status", id: "app_status" }],
    }),
  }),
});

export const { useGetStatusQuery } = statusApiSlice;
