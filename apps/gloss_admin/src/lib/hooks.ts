import { useState, useEffect, useCallback } from "react";
import { api, ApiError } from "./api";

export interface DashboardMetrics {
  totalRevenue: number;
  todayOrders: number;
  activeProviders: number;
  collectedCommission: number;
  monthlyRevenue: { month: string; amount: number }[];
}

export interface Tenant {
  id: string;
  name: string;
  phone: string;
  email?: string;
  status: "active" | "inactive" | "pending" | "blocked";
  orders: number;
  rating: number;
  commissionRate: number;
  createdAt: string;
}

export interface Order {
  id: string;
  orderNumber: string;
  service: string;
  provider: string;
  client: string;
  amount: number;
  status: "new" | "in_progress" | "completed" | "cancelled";
  date: string;
  providerId: string;
}

export interface Commission {
  id: string;
  service: string;
  percent: number;
}

export interface Product {
  id: string;
  name: string;
  price: number;
  category: string;
  status: "active" | "inactive" | "pending";
  seller: string;
  stock: number;
}

export interface Payout {
  id: string;
  provider: string;
  amount: number;
  date: string;
  status: "paid" | "pending" | "rejected";
}

export interface User {
  id: string;
  name: string;
  email: string;
  phone: string;
  role: "client" | "provider" | "courier" | "seller" | "admin";
  orders: number;
  createdAt: string;
}

export interface PlatformSettings {
  platformName: string;
  platformPhone: string;
  platformEmail: string;
  minOrderAmount: number;
}

export function useDashboardMetrics() {
  const [data, setData] = useState<DashboardMetrics | null>(null);
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  const fetch = useCallback(async () => {
    try {
      setIsLoading(true);
      const metrics = await api.get<DashboardMetrics>("/admin/dashboard");
      setData(metrics);
      setError(null);
    } catch (e) {
      if (e instanceof ApiError) setError(e.message);
    } finally {
      setIsLoading(false);
    }
  }, []);

  useEffect(() => {
    fetch();
  }, [fetch]);

  return { data, isLoading, error, refetch: fetch };
}

export function useTenants() {
  const [data, setData] = useState<Tenant[]>([]);
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  const fetch = useCallback(async () => {
    try {
      setIsLoading(true);
      const tenants = await api.get<Tenant[]>("/admin/tenants");
      setData(tenants);
      setError(null);
    } catch (e) {
      if (e instanceof ApiError) setError(e.message);
    } finally {
      setIsLoading(false);
    }
  }, []);

  const create = useCallback(async (tenant: Omit<Tenant, "id">) => {
    const newTenant = await api.post<Tenant>("/admin/tenants", tenant);
    setData((prev) => [newTenant, ...prev]);
    return newTenant;
  }, []);

  const update = useCallback(async (id: string, data: Partial<Tenant>) => {
    const updated = await api.patch<Tenant>(`/admin/tenants/${id}`, data);
    setData((prev) => prev.map((t) => (t.id === id ? updated : t)));
    return updated;
  }, []);

  useEffect(() => {
    fetch();
  }, [fetch]);

  return { data, isLoading, error, refetch: fetch, create, update };
}

export function useOrders() {
  const [data, setData] = useState<Order[]>([]);
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  const fetch = useCallback(async (params: { status?: string; providerId?: string } = {}) => {
    try {
      setIsLoading(true);
      const query = new URLSearchParams();
      if (params.status) query.set("status", params.status);
      if (params.providerId) query.set("providerId", params.providerId);
      const orders = await api.get<Order[]>(`/admin/orders?${query.toString()}`);
      setData(orders);
      setError(null);
    } catch (e) {
      if (e instanceof ApiError) setError(e.message);
    } finally {
      setIsLoading(false);
    }
  }, []);

  useEffect(() => {
    fetch();
  }, [fetch]);

  return { data, isLoading, error, refetch: fetch };
}

export function useCommissions() {
  const [data, setData] = useState<Commission[]>([]);
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  const fetch = useCallback(async () => {
    try {
      setIsLoading(true);
      const commissions = await api.get<Commission[]>("/admin/commissions");
      setData(commissions);
      setError(null);
    } catch (e) {
      if (e instanceof ApiError) setError(e.message);
    } finally {
      setIsLoading(false);
    }
  }, []);

  const update = useCallback(async (id: string, percent: number) => {
    const updated = await api.patch<Commission>(`/admin/commissions/${id}`, { percent });
    setData((prev) => prev.map((c) => (c.id === id ? updated : c)));
    return updated;
  }, []);

  useEffect(() => {
    fetch();
  }, [fetch]);

  return { data, isLoading, error, refetch: fetch, update };
}

export function useProducts() {
  const [data, setData] = useState<Product[]>([]);
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  const fetch = useCallback(async () => {
    try {
      setIsLoading(true);
      const products = await api.get<Product[]>("/admin/products");
      setData(products);
      setError(null);
    } catch (e) {
      if (e instanceof ApiError) setError(e.message);
    } finally {
      setIsLoading(false);
    }
  }, []);

  const create = useCallback(async (product: Omit<Product, "id">) => {
    const newProduct = await api.post<Product>("/admin/products", product);
    setData((prev) => [newProduct, ...prev]);
    return newProduct;
  }, []);

  const update = useCallback(async (id: string, data: Partial<Product>) => {
    const updated = await api.patch<Product>(`/admin/products/${id}`, data);
    setData((prev) => prev.map((p) => (p.id === id ? updated : p)));
    return updated;
  }, []);

  const remove = useCallback(async (id: string) => {
    await api.delete(`/admin/products/${id}`);
    setData((prev) => prev.filter((p) => p.id !== id));
  }, []);

  useEffect(() => {
    fetch();
  }, [fetch]);

  return { data, isLoading, error, refetch: fetch, create, update, remove };
}

export function usePayouts() {
  const [data, setData] = useState<Payout[]>([]);
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  const fetch = useCallback(async () => {
    try {
      setIsLoading(true);
      const payouts = await api.get<Payout[]>("/admin/payouts");
      setData(payouts);
      setError(null);
    } catch (e) {
      if (e instanceof ApiError) setError(e.message);
    } finally {
      setIsLoading(false);
    }
  }, []);

  const pay = useCallback(async (id: string) => {
    const updated = await api.post<Payout>(`/admin/payouts/${id}/pay`, {});
    setData((prev) => prev.map((p) => (p.id === id ? updated : p)));
    return updated;
  }, []);

  useEffect(() => {
    fetch();
  }, [fetch]);

  return { data, isLoading, error, refetch: fetch, pay };
}

export function useUsers() {
  const [data, setData] = useState<User[]>([]);
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  const fetch = useCallback(async () => {
    try {
      setIsLoading(true);
      const users = await api.get<User[]>("/admin/users");
      setData(users);
      setError(null);
    } catch (e) {
      if (e instanceof ApiError) setError(e.message);
    } finally {
      setIsLoading(false);
    }
  }, []);

  useEffect(() => {
    fetch();
  }, [fetch]);

  return { data, isLoading, error, refetch: fetch };
}

export function useSettings() {
  const [data, setData] = useState<PlatformSettings | null>(null);
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  const fetch = useCallback(async () => {
    try {
      setIsLoading(true);
      const settings = await api.get<PlatformSettings>("/admin/settings");
      setData(settings);
      setError(null);
    } catch (e) {
      if (e instanceof ApiError) setError(e.message);
    } finally {
      setIsLoading(false);
    }
  }, []);

  const update = useCallback(async (settings: Partial<PlatformSettings>) => {
    const updated = await api.patch<PlatformSettings>("/admin/settings", settings);
    setData(updated);
    return updated;
  }, []);

  useEffect(() => {
    fetch();
  }, [fetch]);

  return { data, isLoading, error, refetch: fetch, update };
}