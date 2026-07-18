import { useState, useEffect, useCallback } from "react";
import { api, ApiError } from "./api";

export interface Tenant {
  id: string;
  name: string;
  phone: string;
  city: string;
  status: "Aktiv" | "Nofaol";
  orders: number;
  rating: number;
}

export interface Order {
  id: string;
  service: string;
  tenant: string;
  client: string;
  amount: number;
  status: "Yangi" | "Jarayonda" | "Yetkazilgan" | "Bekor qilingan";
  date: string;
}

export interface Worker {
  id: string;
  name: string;
  phone: string;
  status: "Aktiv" | "Nofaol";
  orders: number;
  rating: number;
}

export interface Product {
  id: string;
  name: string;
  price: number;
  category: string;
  image: string;
}

export interface Commission {
  id: string;
  service: string;
  percent: number;
}

export interface Payout {
  id: string;
  tenant: string;
  amount: number;
  date: string;
  status: "Kutilmoqda" | "To'langan" | "Rad etilgan";
}

export interface Transaction {
  id: string;
  type: string;
  amount: number;
  date: string;
  isIncome: boolean;
}

export interface Review {
  id: string;
  client: string;
  rating: number;
  comment: string;
  date: string;
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

  const create = useCallback(async (tenant: Omit<Tenant, "id" | "orders" | "rating">) => {
    const newTenant = await api.post<Tenant>("/admin/tenants", tenant);
    setData((prev) => [...prev, newTenant]);
    return newTenant;
  }, []);

  const update = useCallback(async (id: string, tenant: Partial<Tenant>) => {
    const updated = await api.patch<Tenant>(`/admin/tenants/${id}`, tenant);
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

  const fetch = useCallback(async (params?: { tenantId?: string; status?: string }) => {
    try {
      setIsLoading(true);
      const query = new URLSearchParams(params as Record<string, string>).toString();
      const orders = await api.get<Order[]>(`/admin/orders?${query}`);
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

export function useWorkers(tenantId?: string) {
  const [data, setData] = useState<Worker[]>([]);
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  const fetch = useCallback(async () => {
    if (!tenantId) return;
    try {
      setIsLoading(true);
      const workers = await api.get<Worker[]>(`/admin/tenants/${tenantId}/workers`);
      setData(workers);
      setError(null);
    } catch (e) {
      if (e instanceof ApiError) setError(e.message);
    } finally {
      setIsLoading(false);
    }
  }, [tenantId]);

  const create = useCallback(async (worker: Omit<Worker, "id" | "orders" | "rating">) => {
    if (!tenantId) return;
    const newWorker = await api.post<Worker>(`/admin/tenants/${tenantId}/workers`, worker);
    setData((prev) => [...prev, newWorker]);
    return newWorker;
  }, [tenantId]);

  const update = useCallback(async (id: string, worker: Partial<Worker>) => {
    const updated = await api.patch<Worker>(`/admin/workers/${id}`, worker);
    setData((prev) => prev.map((w) => (w.id === id ? updated : w)));
    return updated;
  }, []);

  useEffect(() => {
    fetch();
  }, [fetch]);

  return { data, isLoading, error, refetch: fetch, create, update };
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
    setData((prev) => [...prev, newProduct]);
    return newProduct;
  }, []);

  const update = useCallback(async (id: string, product: Partial<Product>) => {
    const updated = await api.patch<Product>(`/admin/products/${id}`, product);
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
    const updated = await api.patch<Payout>(`/admin/payouts/${id}/pay`, { status: "paid" });
    setData((prev) => prev.map((p) => (p.id === id ? updated : p)));
    return updated;
  }, []);

  useEffect(() => {
    fetch();
  }, [fetch]);

  return { data, isLoading, error, refetch: fetch, pay };
}

export function useDashboard() {
  const [data, setData] = useState<{
    totalRevenue: number;
    todayOrders: number;
    activeTenants: number;
    collectedCommission: number;
    revenueChart: { month: string; amount: number }[];
  } | null>(null);
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  const fetch = useCallback(async () => {
    try {
      setIsLoading(true);
      const dashboard = await api.get<{
        totalRevenue: number;
        todayOrders: number;
        activeTenants: number;
        collectedCommission: number;
        revenueChart: { month: string; amount: number }[];
      }>("/admin/dashboard");
      setData(dashboard);
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