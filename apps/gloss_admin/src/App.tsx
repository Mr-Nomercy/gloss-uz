import { Routes, Route, Navigate } from "react-router-dom";
import Login from "./pages/login";
import PlatformDashboard from "./pages/platform/dashboard";
import PlatformTenants from "./pages/platform/tenants";
import PlatformCommissions from "./pages/platform/commissions";
import PlatformOrders from "./pages/platform/orders";
import PlatformUsers from "./pages/platform/users";
import PlatformMarket from "./pages/platform/market";
import PlatformPayouts from "./pages/platform/payouts";
import PlatformSettings from "./pages/platform/settings";
import TenantDashboard from "./pages/tenant/dashboard";
import TenantWorkers from "./pages/tenant/workers";
import TenantOrders from "./pages/tenant/orders";
import TenantWallet from "./pages/tenant/wallet";
import TenantRatings from "./pages/tenant/ratings";
import TenantSettings from "./pages/tenant/settings";
import DashboardLayout from "./components/layout/dashboard-layout";
import { AuthProvider, useAuth } from "./lib/auth";

function ProtectedRoute({ children }: { children: React.ReactNode }) {
  const { user } = useAuth();
  if (!user) return <Navigate to="/login" replace />;
  return <>{children}</>;
}

function PlatformRoutes() {
  return (
    <DashboardLayout>
      <Routes>
        <Route index element={<PlatformDashboard />} />
        <Route path="tenants" element={<PlatformTenants />} />
        <Route path="commissions" element={<PlatformCommissions />} />
        <Route path="orders" element={<PlatformOrders />} />
        <Route path="users" element={<PlatformUsers />} />
        <Route path="market" element={<PlatformMarket />} />
        <Route path="payouts" element={<PlatformPayouts />} />
        <Route path="settings" element={<PlatformSettings />} />
      </Routes>
    </DashboardLayout>
  );
}

function TenantRoutes() {
  return (
    <DashboardLayout>
      <Routes>
        <Route index element={<TenantDashboard />} />
        <Route path="workers" element={<TenantWorkers />} />
        <Route path="orders" element={<TenantOrders />} />
        <Route path="wallet" element={<TenantWallet />} />
        <Route path="ratings" element={<TenantRatings />} />
        <Route path="settings" element={<TenantSettings />} />
      </Routes>
    </DashboardLayout>
  );
}

export default function App() {
  return (
    <AuthProvider>
      <Routes>
        <Route path="/login" element={<Login />} />
        <Route
          path="/platform/*"
          element={
            <ProtectedRoute>
              <PlatformRoutes />
            </ProtectedRoute>
          }
        />
        <Route
          path="/tenant/*"
          element={
            <ProtectedRoute>
              <TenantRoutes />
            </ProtectedRoute>
          }
        />
        <Route path="*" element={<Navigate to="/login" replace />} />
      </Routes>
    </AuthProvider>
  );
}
