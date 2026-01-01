import { type Configuration, type PopupRequest } from "@azure/msal-browser";

export const msalConfig: Configuration = {
    auth: {
        clientId: import.meta.env.VITE_CLIENTID,
        authority: "https://login.microsoftonline.com/" + import.meta.env.VITE_TENANTID,
        redirectUri: "/",
        postLogoutRedirectUri: "/"
    }
};

export const loginRequest: PopupRequest = {
    scopes: [`api://${import.meta.env.VITE_CLIENTID}/ourapi`]
};
