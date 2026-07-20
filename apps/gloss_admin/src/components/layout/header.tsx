import { useLocation, Link, useNavigate } from "react-router-dom";
import { Search, Menu, Bell, User, LogOut, Settings } from "lucide-react";
import { useState, useRef, useEffect } from "react";
import { useAuth } from "@/lib/auth";

interface HeaderProps {
  onMobileMenuToggle: () => void;
}

function buildBreadcrumbs(pathname: string) {
  const segments = pathname.split("/").filter(Boolean);
  const crumbs: { label: string; path?: string }[] = [];

  for (let i = 0; i < segments.length; i++) {
    const segment = segments[i];
    const label =
      segment.charAt(0).toUpperCase() + segment.slice(1).replace(/-/g, " ");
    const path =
      i === segments.length - 1
        ? undefined
        : `/${segments.slice(0, i + 1).join("/")}`;
    crumbs.push({ label, path });
  }

  return crumbs;
}

export default function Header({ onMobileMenuToggle }: HeaderProps) {
  const location = useLocation();
  const navigate = useNavigate();
  const breadcrumbs = buildBreadcrumbs(location.pathname);
  const { user, logout } = useAuth();
  const [dropdownOpen, setDropdownOpen] = useState(false);
  const dropdownRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    const handleClickOutside = (event: MouseEvent) => {
      if (
        dropdownRef.current &&
        !dropdownRef.current.contains(event.target as Node)
      ) {
        setDropdownOpen(false);
      }
    };

    if (dropdownOpen) {
      document.addEventListener("mousedown", handleClickOutside);
    }

    return () => {
      document.removeEventListener("mousedown", handleClickOutside);
    };
  }, [dropdownOpen]);

  return (
    <header className="flex h-16 items-center justify-between border-b border-gray-100 bg-white/80 backdrop-blur-md px-4 lg:px-6 flex-shrink-0 z-30">
      {/* Left */}
      <div className="flex items-center gap-3 min-w-0">
        <button
          onClick={onMobileMenuToggle}
          className="flex h-8 w-8 items-center justify-center rounded-lg text-gloss-hint hover:bg-gloss-bg hover:text-gloss-text transition-colors lg:hidden"
        >
          <Menu className="h-5 w-5" />
        </button>

        {/* Breadcrumb */}
        <nav className="hidden sm:flex items-center gap-1.5 text-sm min-w-0">
          {breadcrumbs.map((crumb, i) => (
            <span key={i} className="flex items-center gap-1.5 min-w-0">
              {i > 0 && <span className="text-gloss-hint select-none">/</span>}
              {crumb.path ? (
                <Link
                  to={crumb.path}
                  className="text-gloss-hint hover:text-gloss-text transition-colors truncate"
                >
                  {crumb.label}
                </Link>
              ) : (
                <span className="font-semibold text-gloss-text truncate">
                  {crumb.label}
                </span>
              )}
            </span>
          ))}
          {breadcrumbs.length === 0 && (
            <span className="font-semibold text-gloss-text">Dashboard</span>
          )}
        </nav>
      </div>

      {/* Right */}
      <div className="flex items-center gap-2">
        {/* Search */}
        <div className="hidden md:flex items-center gap-2 rounded-xl border border-gray-100 bg-gloss-bg px-3 py-1.5 transition-all duration-200 focus-within:border-gloss-green focus-within:ring-2 focus-within:ring-gloss-green/20">
          <Search className="h-4 w-4 text-gloss-hint" />
          <input
            type="text"
            placeholder="Qidirish..."
            className="w-40 bg-transparent text-sm text-gloss-text placeholder:text-gloss-hint outline-none"
          />
        </div>

        {/* Notification bell */}
        <button className="relative flex h-8 w-8 items-center justify-center rounded-lg text-gloss-hint hover:bg-gloss-bg hover:text-gloss-text transition-colors">
          <Bell className="h-5 w-5" />
          <span className="absolute right-1 top-1 flex h-4 w-4 items-center justify-center rounded-full bg-gloss-red text-[8px] font-bold text-white">
            3
          </span>
        </button>

        {/* User avatar dropdown */}
        {user && (
          <div ref={dropdownRef} className="relative">
            <button
              onClick={() => setDropdownOpen((prev) => !prev)}
              className="flex h-8 w-8 items-center justify-center rounded-full bg-gloss-green-bg-light hover:bg-gloss-green/10 transition-colors"
            >
              <User className="h-4 w-4 text-gloss-green" />
            </button>
            {dropdownOpen && (
              <div className="absolute right-0 top-full mt-2 w-56 rounded-xl bg-white border border-gray-100 shadow-gloss-lg animate-scale-in z-50 overflow-hidden">
                <div className="px-4 py-3 border-b border-gray-100">
                  <p className="text-sm font-semibold text-gloss-text">
                    {user?.name}
                  </p>
                  <p className="text-xs text-gloss-hint mt-0.5">
                    {user?.email}
                  </p>
                </div>
                <div className="p-1.5">
                  <button
                    onClick={() => {
                      setDropdownOpen(false);
                      navigate(
                        user.role === "platform-admin"
                          ? "/platform/settings"
                          : "/tenant/settings",
                      );
                    }}
                    className="flex w-full items-center gap-2.5 rounded-lg px-3 py-2 text-sm text-gloss-text hover:bg-gloss-bg transition-colors"
                  >
                    <Settings className="h-4 w-4" /> Sozlamalar
                  </button>
                  <button
                    onClick={() => {
                      setDropdownOpen(false);
                      logout();
                    }}
                    className="flex w-full items-center gap-2.5 rounded-lg px-3 py-2 text-sm text-gloss-red hover:bg-red-50 transition-colors"
                  >
                    <LogOut className="h-4 w-4" /> Chiqish
                  </button>
                </div>
              </div>
            )}
          </div>
        )}
      </div>
    </header>
  );
}
