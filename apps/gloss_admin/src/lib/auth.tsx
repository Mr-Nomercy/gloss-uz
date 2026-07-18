import React, { createContext, useContext, useState, useCallback } from "react";
import { api, ApiError } from "./api";

export interface User {
  id: string;
  email: string;
  name: string;
  role: "platform-admin" | "tenant-admin";
  tenantId?: string;
  tenantName?: string;
}

interface AuthContextType {
  user: User | null;
  isLoading: boolean;
  login: (email: string, password: string) => Promise<boolean>;
  logout: () => void;
  refreshUser: () => Promise<void>;
}

const AuthContext = createContext<AuthContextType>({
  user: null,
  isLoading: true,
  login: async () => false,
  logout: () => {},
  refreshUser: async () => {},
});

export function AuthProvider({ children }: { children: React.ReactNode }) {
  const [user, setUser] = useState<User | null>(null);
  const [isLoading, setIsLoading] = useState(true);

  const refreshUser = useCallback(async () => {
    const token = localStorage.getItem("gloss_admin_token");
    if (!token) {
      setIsLoading(false);
      return;
    }
    try {
      const userData = await api.get<User>("/users/me");
      setUser(userData);
    } catch {
      localStorage.removeItem("gloss_admin_token");
      setUser(null);
    } finally {
      setIsLoading(false);
    }
  }, []);

  refreshUser();

  const login = useCallback(
    async (email: string, password: string): Promise<boolean> => {
      try {
        const response = await api.post<{
          accessToken: string;
          refreshToken: string;
          user: User;
        }>("/auth/login", { email, password });

        localStorage.setItem("gloss_admin_token", response.accessToken);
        localStorage.setItem("gloss_admin_refresh", response.refreshToken);
        setUser(response.user);
        return true;
      } catch (e) {
        if (e instanceof ApiError) {
          return false;
        }
        return false;
      }
    },
    [],
  );

  const logout = useCallback(() => {
    localStorage.removeItem("gloss_admin_token");
    localStorage.removeItem("gloss_admin_refresh");
    setUser(null);
  }, []);

  return (
    <AuthContext.Provider
      value={{ user, isLoading, login, logout, refreshUser }}
    >
      {children}
    </AuthContext.Provider>
  );
}

export function useAuth() {
  return useContext(AuthContext);
}
