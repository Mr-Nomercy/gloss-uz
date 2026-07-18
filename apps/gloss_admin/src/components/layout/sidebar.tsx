import { NavLink, useLocation } from "react-router-dom";
import {
  LayoutDashboard,
  Users,
  Percent,
  ShoppingBag,
  Store,
  Wallet,
  Settings,
  Star,
  LogOut,
  Truck,
} from "lucide-react";
import { useAuth } from "@/lib/auth";
import { cn } from "@/lib/utils";

interface MenuItem {
  label: string;
  path: string;
  icon: React.ReactNode;
}

const platformMenu: MenuItem[] = [
  {
    label: "Dashboard",
    path: "/platform",
    icon: <LayoutDashboard className="h-5 w-5" />,
  },
  {
    label: "Tenantlar",
    path: "/platform/tenants",
    icon: <Store className="h-5 w-5" />,
  },
  {
    label: "Komissiyalar",
    path: "/platform/commissions",
    icon: <Percent className="h-5 w-5" />,
  },
  {
    label: "Buyurtmalar",
    path: "/platform/orders",
    icon: <ShoppingBag className="h-5 w-5" />,
  },
  {
    label: "Foydalanuvchilar",
    path: "/platform/users",
    icon: <Users className="h-5 w-5" />,
  },
  {
    label: "Market",
    path: "/platform/market",
    icon: <Truck className="h-5 w-5" />,
  },
  {
    label: "To'lovlar",
    path: "/platform/payouts",
    icon: <Wallet className="h-5 w-5" />,
  },
  {
    label: "Sozlamalar",
    path: "/platform/settings",
    icon: <Settings className="h-5 w-5" />,
  },
];

const tenantMenu: MenuItem[] = [
  {
    label: "Dashboard",
    path: "/tenant",
    icon: <LayoutDashboard className="h-5 w-5" />,
  },
  {
    label: "Ishchilar",
    path: "/tenant/workers",
    icon: <Users className="h-5 w-5" />,
  },
  {
    label: "Buyurtmalar",
    path: "/tenant/orders",
    icon: <ShoppingBag className="h-5 w-5" />,
  },
  {
    label: "Hamyon",
    path: "/tenant/wallet",
    icon: <Wallet className="h-5 w-5" />,
  },
  {
    label: "Reytinglar",
    path: "/tenant/ratings",
    icon: <Star className="h-5 w-5" />,
  },
  {
    label: "Sozlamalar",
    path: "/tenant/settings",
    icon: <Settings className="h-5 w-5" />,
  },
];

export default function Sidebar({ className }: { className?: string }) {
  const { user, logout } = useAuth();
  const location = useLocation();

  const menu = user?.role === "platform-admin" ? platformMenu : tenantMenu;

  return (
    <div
      className={cn(
        "flex h-full flex-col border-r border-gloss-border bg-white",
        className,
      )}
    >
      <div className="flex h-16 items-center gap-2 border-b border-gloss-border px-6">
        <div className="flex h-8 w-8 items-center justify-center rounded-lg bg-gloss-green">
          <span className="text-sm font-bold text-white">G</span>
        </div>
        <span className="text-lg font-bold text-gloss-green">Gloss Admin</span>
      </div>
      <nav className="flex-1 space-y-1 overflow-y-auto p-3">
        {menu.map((item) => {
          const isActive =
            location.pathname === item.path ||
            (item.path !==
              `/${user?.role === "platform-admin" ? "platform" : "tenant"}` &&
              location.pathname.startsWith(item.path));
          return (
            <NavLink
              key={item.path}
              to={item.path}
              className={cn(
                "flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm font-medium transition-colors",
                isActive
                  ? "bg-gloss-green-bg-light text-gloss-green"
                  : "text-gloss-hint hover:bg-gloss-bg hover:text-gloss-text",
              )}
            >
              {item.icon}
              {item.label}
            </NavLink>
          );
        })}
      </nav>
      <div className="border-t border-gloss-border p-3">
        <button
          onClick={logout}
          className="flex w-full items-center gap-3 rounded-lg px-3 py-2.5 text-sm font-medium text-gloss-red transition-colors hover:bg-red-50"
        >
          <LogOut className="h-5 w-5" />
          Chiqish
        </button>
      </div>
    </div>
  );
}
