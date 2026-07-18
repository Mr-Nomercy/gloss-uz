import { Bell, User } from "lucide-react";
import { useAuth } from "@/lib/auth";

export default function Header() {
  const { user } = useAuth();

  return (
    <header className="flex h-16 items-center justify-between border-b border-gloss-border bg-white px-6">
      <h1 className="text-lg font-semibold text-gloss-text">
        {user?.role === "platform-admin"
          ? "Platforma boshqaruvi"
          : user?.tenantName || "Tenant boshqaruvi"}
      </h1>
      <div className="flex items-center gap-4">
        <button className="relative rounded-lg p-2 text-gloss-hint hover:bg-gloss-bg hover:text-gloss-text">
          <Bell className="h-5 w-5" />
          <span className="absolute right-1 top-1 flex h-2 w-2 rounded-full bg-gloss-red" />
        </button>
        <div className="flex items-center gap-2 text-sm text-gloss-text">
          <div className="flex h-8 w-8 items-center justify-center rounded-full bg-gloss-green-bg-light">
            <User className="h-4 w-4 text-gloss-green" />
          </div>
          <span className="font-medium">{user?.name || "Admin"}</span>
        </div>
      </div>
    </header>
  );
}
