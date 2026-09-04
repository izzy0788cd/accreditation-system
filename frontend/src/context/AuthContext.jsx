import { createContext, useContext, useState } from "react";
import { login as loginRequest, setAuthToken, getOwnProfile } from "../api/api";

const AuthContext = createContext(null);

export function AuthProvider({ children }) {
  const [auth, setAuth] = useState(null);
  const [hasProfile, setHasProfile] = useState(false);

  const checkProfile = async () => {
    try {
      await getOwnProfile();
      setHasProfile(true);
      return true;
    } catch {
      setHasProfile(false);
      return false;
    }
  };

  const login = async (username, password) => {
    const response = await loginRequest(username, password);
    const { token, username: name, roleName } = response.data;
    setAuthToken(token);
    setAuth({ token, username: name, roleName });
    return checkProfile();
  };

  const logout = () => {
    setAuthToken(null);
    setAuth(null);
    setHasProfile(false);
  };

  return (
    <AuthContext.Provider
      value={{ auth, login, logout, checkProfile, hasProfile, isAuthenticated: !!auth }}
    >
      {children}
    </AuthContext.Provider>
  );
}

export const useAuth = () => useContext(AuthContext);