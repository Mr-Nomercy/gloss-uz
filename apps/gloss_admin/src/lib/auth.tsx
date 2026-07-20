import React, {
  createContext,
  useContext,
  useState,
  useCallback,
  useEffect,
} from "react";
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
    // Demo token handling
    if (token.startsWith("demo-token-")) {
      const email = localStorage.getItem("gloss_admin_email");
      if (email) {
        const DEMO_USERS = {
          "admin@gloss.uz": {
            id: "1",
            email: "admin@gloss.uz",
            name: "Platform Administrator",
            role: "platform-admin" as const,
          },
          "firma@gloss.uz": {
            id: "2",
            email: "firma@gloss.uz",
            name: "Firma MCHJ",
            role: "tenant-admin" as const,
            tenantId: "t1",
            tenantName: "Firma MCHJ",
          },
        };
        const user = DEMO_USERS[email as keyof typeof DEMO_USERS];
        if (user) {
          setUser({ ...user, email });
          setIsLoading(false);
          return;
        }
      }
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

  // Load user on mount if token exists
  useEffect(() => {
    refreshUser();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  const login = useCallback(
    async (email: string, password: string): Promise<boolean> => {
      // Demo credentials for development
      type DemoCred = {
        password: string;
        role: "platform-admin" | "tenant-admin";
        name: string;
        tenantId?: string;
        tenantName?: string;
      };

      const DEMO_CREDENTIALS: Record<string, DemoCred> = {
        "admin@gloss.uz": {
          password: "admin123",
          role: "platform-admin",
          name: "Platform Administrator",
        },
        "firma@gloss.uz": {
          password: "firma123",
          role: "tenant-admin",
          name: "Firma MCHJ",
          tenantId: "t1",
          tenantName: "Firma MCHJ",
        },
      };

      const demo = DEMO_CREDENTIALS[email];
      if (demo && demo.password === password) {
        const user: User = {
          id: email === "admin@gloss.uz" ? "1" : "2",
          email,
          name: demo.name,
          role: demo.role,
          tenantId: demo.tenantId,
          tenantName: demo.tenantName,
        };
        const accessToken = "demo-token-" + Date.now();
        const refreshToken = "demo-refresh-" + Date.now();
        localStorage.setItem("gloss_admin_token", accessToken);
        localStorage.setItem("gloss_admin_refresh", refreshToken);
        localStorage.setItem("gloss_admin_email", email); // Save for refresh
        setUser(user);
        return true;
      }

      // Fallback to real API (will fail if no backend)
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
