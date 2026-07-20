import { useState, useCallback } from "react";
import Sidebar from "./sidebar";
import Header from "./header";

const STORAGE_KEY = "gloss_sidebar_collapsed";

function loadCollapsed(): boolean {
  try {
    return localStorage.getItem(STORAGE_KEY) === "true";
  } catch {
    return false;
  }
}

export default function DashboardLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  const [collapsed, setCollapsed] = useState(loadCollapsed);
  const [mobileOpen, setMobileOpen] = useState(false);

  const handleToggleCollapse = useCallback(() => {
    setCollapsed((prev) => {
      const next = !prev;
      localStorage.setItem(STORAGE_KEY, String(next));
      return next;
    });
  }, []);

  const handleMobileToggle = useCallback(() => {
    setMobileOpen((prev) => !prev);
  }, []);

  const handleMobileClose = useCallback(() => {
    setMobileOpen(false);
  }, []);

  return (
    <div className="flex h-screen bg-gloss-bg">
      <Sidebar
        collapsed={collapsed}
        onToggle={handleToggleCollapse}
        mobileOpen={mobileOpen}
        onMobileClose={handleMobileClose}
      />

      <div className="flex flex-1 flex-col overflow-hidden min-w-0">
        <Header onMobileMenuToggle={handleMobileToggle} />

        <main className="flex-1 overflow-y-auto">
          <div className="p-4 lg:p-6 animate-fade-in">{children}</div>
        </main>
      </div>
    </div>
  );
}
