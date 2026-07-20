import {
  Wallet,
  ShoppingBag,
  Star,
  ArrowUpRight,
  ArrowDownRight,
  ChevronRight,
} from "lucide-react";
import {
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from "@/components/ui/card";
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table";
import { Badge } from "@/components/ui/badge";
import { mockOrders } from "@/lib/data";
import { formatCurrency, cn } from "@/lib/utils";

const stats = [
  {
    label: "Balans",
    value: "8 450 000 so'm",
    icon: Wallet,
    iconBg: "bg-green-50",
    iconColor: "text-gloss-green",
    accent: "border-t-green-500",
    trend: "+5%",
    trendUp: true,
  },
  {
    label: "Buyurtmalar",
    value: "234 ta",
    icon: ShoppingBag,
    iconBg: "bg-blue-50",
    iconColor: "text-blue-600",
    accent: "border-t-blue-500",
    trend: "+12%",
    trendUp: true,
  },
  {
    label: "Reyting",
    value: "4.8",
    icon: Star,
    iconBg: "bg-yellow-50",
    iconColor: "text-gloss-star",
    accent: "border-t-gloss-star",
    trend: "+0.2",
    trendUp: true,
  },
];

const statusBadge = (status: string) => {
  const map: Record<
    string,
    {
      variant: "default" | "warning" | "destructive" | "secondary";
      className?: string;
    }
  > = {
    Yetkazilgan: { variant: "default" },
    Jarayonda: { variant: "warning" },
    Yangi: {
      variant: "secondary",
      className: "bg-blue-100 text-blue-700 border-blue-200",
    },
    "Bekor qilingan": { variant: "destructive" },
  };
  const cfg = map[status] ?? { variant: "secondary" as const };
  return (
    <Badge variant={cfg.variant} className={cn(cfg.className)}>
      {status}
    </Badge>
  );
};

export default function TenantDashboard() {
  const tenantOrders = mockOrders.filter((o) => o.tenant === "Firma MCHJ");

  return (
    <div className="animate-slide-up space-y-6">
      <div className="flex flex-col gap-2 sm:flex-row sm:items-center sm:justify-between">
        <div>
          <p className="text-sm text-gloss-hint mt-0.5">
            Kompaniyangiz haqida umumiy ma'lumot
          </p>
        </div>
      </div>

      <div className="grid gap-4 md:grid-cols-3">
        {stats.map((s) => (
          <Card
            key={s.label}
            className={cn(
              "relative overflow-hidden border-t-[3px] transition-all duration-200 hover:-translate-y-0.5 hover:shadow-lg",
              s.accent,
            )}
          >
            <CardContent className="p-5">
              <div className="flex items-start justify-between">
                <div
                  className={`flex h-12 w-12 items-center justify-center rounded-xl ${s.iconBg}`}
                >
                  <s.icon className={`h-6 w-6 ${s.iconColor}`} />
                </div>
                <div
                  className={cn(
                    "flex items-center gap-0.5 rounded-full px-2 py-0.5 text-xs font-semibold",
                    s.trendUp
                      ? "bg-green-50 text-green-600"
                      : "bg-red-50 text-gloss-red",
                  )}
                >
                  {s.trendUp ? (
                    <ArrowUpRight className="h-3 w-3" />
                  ) : (
                    <ArrowDownRight className="h-3 w-3" />
                  )}
                  {s.trend}
                </div>
              </div>
              <div className="mt-4">
                <div className="text-2xl font-bold text-gloss-text">
                  {s.value}
                </div>
                <p className="mt-0.5 text-sm text-gloss-hint">{s.label}</p>
              </div>
            </CardContent>
          </Card>
        ))}
      </div>

      <Card>
        <CardHeader className="flex flex-row items-center justify-between">
          <div>
            <CardTitle>So'nggi buyurtmalar</CardTitle>
            <CardDescription>
              Firma MCHJ bo'yicha oxirgi buyurtmalar
            </CardDescription>
          </div>
          <a
            href="/tenant/orders"
            className="inline-flex items-center gap-1 text-sm font-medium text-gloss-green hover:underline"
          >
            Barchasi
            <ChevronRight className="h-4 w-4" />
          </a>
        </CardHeader>
        <CardContent className="p-0">
          <Table>
            <TableHeader>
              <TableRow>
                <TableHead className="py-2.5">ID</TableHead>
                <TableHead className="py-2.5">Xizmat</TableHead>
                <TableHead className="py-2.5">Mijoz</TableHead>
                <TableHead className="py-2.5">Summa</TableHead>
                <TableHead className="py-2.5">Status</TableHead>
                <TableHead className="py-2.5">Sana</TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              {tenantOrders.map((o) => (
                <TableRow key={o.id} className="group">
                  <TableCell className="py-2.5 font-mono text-xs font-medium text-gloss-hint">
                    {o.id}
                  </TableCell>
                  <TableCell className="py-2.5 font-medium text-gloss-text">
                    {o.service}
                  </TableCell>
                  <TableCell className="py-2.5">{o.client}</TableCell>
                  <TableCell className="py-2.5 font-medium">
                    {formatCurrency(o.amount)}
                  </TableCell>
                  <TableCell className="py-2.5">
                    {statusBadge(o.status)}
                  </TableCell>
                  <TableCell className="py-2.5 text-gloss-hint">
                    {o.date}
                  </TableCell>
                </TableRow>
              ))}
            </TableBody>
          </Table>
        </CardContent>
      </Card>
    </div>
  );
}
