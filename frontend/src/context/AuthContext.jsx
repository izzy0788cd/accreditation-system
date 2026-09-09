import { createContext, useContext, useEffect, useState } from "react";
import { login as loginRequest, logoutSession, refreshSession, setAuthToken, getOwnProfile } from "../api/api";

const AuthContext = createContext(null);
const TAB_SESSION_KEY = "accreditation-auth-tab";

export function AuthProvider({ children }) {
  const [auth, setAuth] = useState(null);
  const [hasProfile, setHasProfile] = useState(false);
  const [profile, setProfile] = useState(null);
  const [isInitializing, setIsInitializing] = useState(true);

  const checkProfile = async () => {
    try {
      const response = await getOwnProfile();
      setProfile(response.data);
      setHasProfile(true);
      return true;
    } catch {
      setHasProfile(false);
      setProfile(null);
      return false;
    }
  };

  useEffect(() => {
    if (sessionStorage.getItem(TAB_SESSION_KEY) !== "active") {
      // A new tab must not revive a previous tab's refresh session. sessionStorage
      // survives reloads, but is cleared when the tab is closed.
      logoutSession().catch(() => {});
      setIsInitializing(false);
      return;
    }

    refreshSession()
      .then(({ data }) => { setAuthToken(data.token); setAuth({ token: data.token, username: data.username, roleName: data.roleName }); return checkProfile(); })
      .catch(() => {})
      .finally(() => setIsInitializing(false));
  }, []);

  const login = async (username, password) => {
    const response = await loginRequest(username, password);
    const { token, username: name, roleName } = response.data;
    setAuthToken(token);
    sessionStorage.setItem(TAB_SESSION_KEY, "active");
    setAuth({ token, username: name, roleName });
    return checkProfile();
  };

  const logout = () => {
    logoutSession().catch(() => {});
    sessionStorage.removeItem(TAB_SESSION_KEY);
    setAuthToken(null);
    setAuth(null);
    setHasProfile(false);
    setProfile(null);
  };

  return (
    <AuthContext.Provider
      value={{ auth, profile, setProfile, login, logout, checkProfile, hasProfile, isAuthenticated: !!auth, isInitializing }}
    >
      {children}
    </AuthContext.Provider>
  );
}

export const useAuth = () => useContext(AuthContext);
