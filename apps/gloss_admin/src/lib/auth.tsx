import React, { createContext, useContext, useState, useCallback } from 'react';

export interface User {
  id: string;
  email: string;
  name: string;
  role: 'platform-admin' | 'tenant-admin';
  tenantId?: string;
  tenantName?: string;
}

interface AuthContextType {
  user: User | null;
  login: (email: string, password: string) => Promise<boolean>;
  logout: () => void;
}

const AuthContext = createContext<AuthContextType>({
  user: null,
  login: async () => false,
  logout: () => {},
});

const MOCK_USERS: Record<string, User> = {
  'admin@gloss.uz': {
    id: '1',
    email: 'admin@gloss.uz',
    name: 'Platform Administrator',
    role: 'platform-admin',
  },
  'firma@gloss.uz': {
    id: '2',
    email: 'firma@gloss.uz',
    name: 'Firma MCHJ',
    role: 'tenant-admin',
    tenantId: 't1',
    tenantName: 'Firma MCHJ',
  },
};

export function AuthProvider({ children }: { children: React.ReactNode }) {
  const [user, setUser] = useState<User | null>(() => {
    const stored = localStorage.getItem('gloss_admin_user');
    return stored ? JSON.parse(stored) : null;
  });

  const login = useCallback(async (email: string, password: string): Promise<boolean> => {
    const mockPasswords: Record<string, string> = {
      'admin@gloss.uz': 'admin123',
      'firma@gloss.uz': 'firma123',
    };
    if (mockPasswords[email] === password && MOCK_USERS[email]) {
      const u = MOCK_USERS[email];
      setUser(u);
      localStorage.setItem('gloss_admin_user', JSON.stringify(u));
      return true;
    }
    return false;
  }, []);

  const logout = useCallback(() => {
    setUser(null);
    localStorage.removeItem('gloss_admin_user');
  }, []);

  return <AuthContext.Provider value={{ user, login, logout }}>{children}</AuthContext.Provider>;
}

export function useAuth() {
  return useContext(AuthContext);
}
