import { useState, useCallback } from "react";
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

export interface Rating {
  id: string;
  client: string;
  rating: number;
  comment: string;
  date: string;
}

export interface Transaction {
  id: string;
  type: string;
  amount: number;
  date: string;
  isIncome: boolean;
}

export interface TenantSettings {
  companyName: string;
  phone: string;
  address: string;
  email: string;
}

export function useTenantOrders() {
  const [data, setData] = useState<Order[]>([]);
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  const fetch = useCallback(async () => {
    try {
      setIsLoading(true);
      const orders = await api.get<Order[]>("/tenant/orders");
      setData(orders);
      setError(null);
    } catch (e) {
      if (e instanceof ApiError) setError(e.message);
    } finally {
      setIsLoading(false);
    }
  }, []);

  fetch();

  return { data, isLoading, error, refetch: fetch };
}

export function useTenantWorkers() {
  const [data, setData] = useState<Worker[]>([]);
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  const fetch = useCallback(async () => {
    try {
      setIsLoading(true);
      const workers = await api.get<Worker[]>("/tenant/workers");
      setData(workers);
      setError(null);
    } catch (e) {
      if (e instanceof ApiError) setError(e.message);
    } finally {
      setIsLoading(false);
    }
  }, []);

  const create = useCallback(
    async (worker: Omit<Worker, "id" | "orders" | "rating">) => {
      const newWorker = await api.post<Worker>("/tenant/workers", worker);
      setData((prev) => [...prev, newWorker]);
      return newWorker;
    },
    [],
  );

  const update = useCallback(async (id: string, worker: Partial<Worker>) => {
    const updated = await api.patch<Worker>(`/tenant/workers/${id}`, worker);
    setData((prev) => prev.map((w) => (w.id === id ? updated : w)));
    return updated;
  }, []);

  fetch();

  return { data, isLoading, error, refetch: fetch, create, update };
}

export function useTenantRatings() {
  const [data, setData] = useState<Rating[]>([]);
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  const fetch = useCallback(async () => {
    try {
      setIsLoading(true);
      const ratings = await api.get<Rating[]>("/tenant/ratings");
      setData(ratings);
      setError(null);
    } catch (e) {
      if (e instanceof ApiError) setError(e.message);
    } finally {
      setIsLoading(false);
    }
  }, []);

  fetch();

  return { data, isLoading, error, refetch: fetch };
}

export function useTenantWallet() {
  const [data, setData] = useState<{
    balance: number;
    transactions: Transaction[];
  } | null>(null);
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  const fetch = useCallback(async () => {
    try {
      setIsLoading(true);
      const wallet = await api.get<{
        balance: number;
        transactions: Transaction[];
      }>("/tenant/wallet");
      setData(wallet);
      setError(null);
    } catch (e) {
      if (e instanceof ApiError) setError(e.message);
    } finally {
      setIsLoading(false);
    }
  }, []);

  const withdraw = useCallback(
    async (amount: number, cardNumber: string) => {
      await api.post("/tenant/wallet/withdraw", { amount, cardNumber });
      await fetch();
    },
    [fetch],
  );

  fetch();

  return { data, isLoading, error, refetch: fetch, withdraw };
}

export function useTenantSettings() {
  const [data, setData] = useState<TenantSettings | null>(null);
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  const fetch = useCallback(async () => {
    try {
      setIsLoading(true);
      const settings = await api.get<TenantSettings>("/tenant/settings");
      setData(settings);
      setError(null);
    } catch (e) {
      if (e instanceof ApiError) setError(e.message);
    } finally {
      setIsLoading(false);
    }
  }, []);

  const update = useCallback(async (settings: Partial<TenantSettings>) => {
    const updated = await api.patch<TenantSettings>(
      "/tenant/settings",
      settings,
    );
    setData(updated);
    return updated;
  }, []);

  fetch();

  return { data, isLoading, error, refetch: fetch, update };
}
