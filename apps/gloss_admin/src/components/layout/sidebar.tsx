import { NavLink, useLocation } from "react-router-dom";
import {
  LayoutDashboard,
  Users,
  Percent,
  ShoppingBag,
  Store,
  Wallet,
  Star,
  Truck,
  ChevronLeft,
  ChevronRight,
} from "lucide-react";
import { useAuth } from "@/lib/auth";
import { cn } from "@/lib/utils";

interface MenuItem {
  label: string;
  path: string;
  icon: React.ReactNode;
  badge?: number;
}

interface MenuGroup {
  label: string;
  items: MenuItem[];
}

const platformGroups: MenuGroup[] = [
  {
    label: "Dashboard",
    items: [
      {
        label: "Dashboard",
        path: "/platform",
        icon: <LayoutDashboard className="h-5 w-5" />,
      },
    ],
  },
  {
    label: "Management",
    items: [
      {
        label: "Tenantlar",
        path: "/platform/tenants",
        icon: <Store className="h-5 w-5" />,
        badge: 24,
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
        badge: 12,
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
    ],
  },
  {
    label: "Billing",
    items: [
      {
        label: "To'lovlar",
        path: "/platform/payouts",
        icon: <Wallet className="h-5 w-5" />,
        badge: 5,
      },
    ],
  },
];

const tenantGroups: MenuGroup[] = [
  {
    label: "Dashboard",
    items: [
      {
        label: "Dashboard",
        path: "/tenant",
        icon: <LayoutDashboard className="h-5 w-5" />,
      },
    ],
  },
  {
    label: "Management",
    items: [
      {
        label: "Ishchilar",
        path: "/tenant/workers",
        icon: <Users className="h-5 w-5" />,
      },
      {
        label: "Buyurtmalar",
        path: "/tenant/orders",
        icon: <ShoppingBag className="h-5 w-5" />,
        badge: 8,
      },
    ],
  },
  {
    label: "Billing",
    items: [
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
    ],
  },
];

interface SidebarProps {
  className?: string;
  collapsed: boolean;
  onToggle: () => void;
  mobileOpen?: boolean;
  onMobileClose?: () => void;
}

function CollapsedTooltip({ label }: { label: string }) {
  return (
    <div className="pointer-events-none absolute left-full top-1/2 z-[100] ml-3 -translate-y-1/2 whitespace-nowrap rounded-lg bg-gray-900 px-2.5 py-1.5 text-xs text-white opacity-0 shadow-lg transition-opacity duration-150 group-hover:opacity-100">
      {label}
    </div>
  );
}

export default function Sidebar({
  className,
  collapsed,
  onToggle,
  mobileOpen,
  onMobileClose,
}: SidebarProps) {
  const { user } = useAuth();
  const location = useLocation();

  const groups =
    user?.role === "platform-admin" ? platformGroups : tenantGroups;

  const sidebar = (
    <div
      className={cn(
        "flex h-full flex-col bg-white border-r border-gray-100 shadow-gloss-sm relative",
        "transition-[width] duration-300 ease-in-out",
        collapsed ? "w-16" : "w-64",
        className,
      )}
    >
      {/* Logo + Toggle */}
      <div
        className={cn(
          "flex h-16 flex-shrink-0 items-center border-b border-gray-100 relative",
          collapsed ? "justify-center px-2" : "justify-between px-4",
        )}
      >
        <div
          className={cn(
            "flex items-center gap-2 overflow-hidden",
            collapsed ? "w-0 opacity-0" : "w-auto opacity-100",
            "transition-[width,opacity] duration-200",
          )}
        >
          <div className="flex h-8 w-8 flex-shrink-0 items-center justify-center rounded-lg bg-gloss-green shadow-gloss-green">
            <span className="text-sm font-bold text-white">G</span>
          </div>
          <span className="text-lg font-bold text-gloss-green whitespace-nowrap">
            Gloss Admin
          </span>
        </div>

        <button
          onClick={onToggle}
          className={cn(
            "flex h-7 w-7 flex-shrink-0 items-center justify-center rounded-lg text-gloss-hint",
            "hover:bg-gloss-bg hover:text-gloss-text transition-colors",
            collapsed
              ? "absolute left-1/2 top-1/2 -translate-x-1/2 -translate-y-1/2 bg-gloss-green text-white hover:bg-gloss-green-text rounded-full h-8 w-8"
              : "z-10",
          )}
        >
          {collapsed ? (
            <ChevronRight className="h-4 w-4" />
          ) : (
            <ChevronLeft className="h-4 w-4" />
          )}
        </button>
      </div>

      {/* Navigation — scrollable */}
      <nav className="flex-1 overflow-y-auto overflow-x-hidden py-3">
        {groups.map((group, groupIndex) => (
          <div key={group.label} className="mb-1">
            {!collapsed ? (
              <div className="px-4 py-2">
                <span className="text-[10px] font-semibold uppercase tracking-wider text-gloss-hint">
                  {group.label}
                </span>
              </div>
            ) : (
              groupIndex > 0 && (
                <div className="mx-4 my-2 border-t border-gray-100" />
              )
            )}
            {group.items.map((item) => {
              const rootPath =
                user?.role === "platform-admin" ? "/platform" : "/tenant";
              const isActive =
                location.pathname === item.path ||
                (item.path !== rootPath &&
                  location.pathname.startsWith(item.path));
              return (
                <div
                  key={item.path}
                  className={cn("group relative", collapsed ? "px-2" : "px-3")}
                >
                  <NavLink
                    to={item.path}
                    onClick={onMobileClose}
                    className={cn(
                      "flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm font-medium",
                      "transition-all duration-200",
                      isActive
                        ? "bg-gloss-green-bg-light text-gloss-green-text border-l-2 border-gloss-green rounded-l-none"
                        : "text-gloss-hint hover:bg-gloss-bg hover:text-gloss-text",
                      collapsed && "justify-center px-2",
                    )}
                  >
                    <span
                      className={cn(
                        "flex-shrink-0",
                        isActive && "text-gloss-green",
                      )}
                    >
                      {item.icon}
                    </span>
                    {!collapsed && (
                      <span className="flex-1 truncate">{item.label}</span>
                    )}
                    {!collapsed && item.badge != null && (
                      <span className="flex h-5 min-w-[20px] items-center justify-center rounded-full bg-gloss-green px-1.5 text-[10px] font-semibold text-white animate-scale-in">
                        {item.badge}
                      </span>
                    )}
                  </NavLink>
                  {collapsed && item.badge != null && (
                    <span className="pointer-events-none absolute right-1 top-1 flex h-4 w-4 items-center justify-center rounded-full bg-gloss-red text-[8px] font-bold text-white">
                      {item.badge > 9 ? "9+" : item.badge}
                    </span>
                  )}
                  {collapsed && <CollapsedTooltip label={item.label} />}
                </div>
              );
            })}
          </div>
        ))}
      </nav>
    </div>
  );

  return (
    <>
      {/* Desktop */}
      <div className="relative hidden lg:block h-full flex-shrink-0">
        {sidebar}
      </div>

      {/* Mobile overlay */}
      {mobileOpen !== undefined && (
        <>
          <div
            className={cn(
              "fixed inset-0 z-40 bg-black/50 transition-opacity duration-300 lg:hidden",
              mobileOpen ? "opacity-100" : "opacity-0 pointer-events-none",
            )}
            onClick={onMobileClose}
          />
          <div
            className={cn(
              "fixed left-0 top-0 z-50 h-full transition-transform duration-300 ease-in-out lg:hidden",
              mobileOpen ? "translate-x-0" : "-translate-x-full",
            )}
          >
            {sidebar}
          </div>
        </>
      )}
    </>
  );
}
