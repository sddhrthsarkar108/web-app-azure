<script setup lang="ts">
  import { useAuth } from "@/auth";

  const auth = useAuth();

  async function login() {
    await auth.msalInstance.initialize();
    const loginResponse = await auth.msalInstance.loginPopup();
    auth.account = loginResponse.account;

    const response = await auth.msalInstance.acquireTokenSilent({
      account: auth.account,
      scopes: [import.meta.env.VITE_API_SCOPE_URI]
    });

    auth.token = response.accessToken;
  }

</script> 

<template>
  <div>
    <p>
      <div v-if="auth.account">{{ auth.account.name }}</div>
      <button v-if="!auth.account" @click="login" class="btn">Click here to login</button>
    </p>
  </div>
</template>