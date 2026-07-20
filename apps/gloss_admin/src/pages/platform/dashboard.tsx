import { useState } from "react";
import {
  DollarSign,
  ShoppingBag,
  Store,
  TrendingUp,
  ArrowUpRight,
  ArrowDownRight,
  ChevronRight,
} from "lucide-react";
import {
  Card,
  CardContent,
  CardDescription,
  CardFooter,
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
import { mockOrders, revenueData } from "@/lib/data";
import { formatCurrency, cn } from "@/lib/utils";
import {
  BarChart,
  Bar,
  XAxis,
  YAxis,
  CartesianGrid,
  Tooltip,
  ResponsiveContainer,
} from "recharts";

const dateRanges = [
  { key: "7d", label: "7 kun" },
  { key: "30d", label: "30 kun" },
  { key: "year", label: "Bu yil" },
];

const stats = [
  {
    label: "Umumiy daromad",
    value: formatCurrency(146500000),
    icon: DollarSign,
    iconBg: "bg-green-50",
    iconColor: "text-gloss-green",
    accent: "border-t-green-500",
    trend: "+12%",
    trendUp: true,
  },
  {
    label: "Bugungi buyurtmalar",
    value: "24 ta",
    icon: ShoppingBag,
    iconBg: "bg-blue-50",
    iconColor: "text-blue-600",
    accent: "border-t-blue-500",
    trend: "+8%",
    trendUp: true,
  },
  {
    label: "Aktiv tenantlar",
    value: "5 ta",
    icon: Store,
    iconBg: "bg-purple-50",
    iconColor: "text-purple-600",
    accent: "border-t-purple-500",
    trend: "-2%",
    trendUp: false,
  },
  {
    label: "Yig'ilgan komissiya",
    value: formatCurrency(14650000),
    icon: TrendingUp,
    iconBg: "bg-orange-50",
    iconColor: "text-gloss-orange",
    accent: "border-t-gloss-orange",
    trend: "+5%",
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

const totalRevenue = revenueData.reduce((sum, d) => sum + d.amount, 0);

export default function PlatformDashboard() {
  const [range, setRange] = useState("30d");

  return (
    <div className="animate-slide-up space-y-6">
      <div className="flex flex-col gap-2 sm:flex-row sm:items-center sm:justify-between">
        <div>
          <p className="text-sm text-gloss-hint mt-0.5">
            Platformangiz haqida umumiy ma'lumot
          </p>
        </div>
        <div className="inline-flex items-center rounded-lg border border-gloss-border bg-white p-1">
          {dateRanges.map((r) => (
            <button
              key={r.key}
              onClick={() => setRange(r.key)}
              className={cn(
                "rounded-md px-3 py-1.5 text-xs font-medium transition-all",
                range === r.key
                  ? "bg-gloss-green text-white shadow-sm"
                  : "text-gloss-hint hover:text-gloss-text",
              )}
            >
              {r.label}
            </button>
          ))}
        </div>
      </div>

      <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-4">
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
            <CardTitle>Daromad statistikasi</CardTitle>
            <CardDescription>Oylik daromad ko'rsatkichlari</CardDescription>
          </div>
          <span className="rounded-full bg-gloss-green-bg-light px-3 py-1 text-xs font-medium text-gloss-green">
            So'nggi 7 oy
          </span>
        </CardHeader>
        <CardContent>
          <ResponsiveContainer width="100%" height={320}>
            <BarChart data={revenueData} barCategoryGap="30%">
              <defs>
                <linearGradient
                  id="revenueGradient"
                  x1="0"
                  y1="0"
                  x2="0"
                  y2="1"
                >
                  <stop offset="0%" stopColor="#00AA13" stopOpacity={0.9} />
                  <stop offset="100%" stopColor="#00cc44" stopOpacity={0.4} />
                </linearGradient>
              </defs>
              <CartesianGrid
                strokeDasharray="3 3"
                stroke="#F0F0F0"
                vertical={false}
              />
              <XAxis
                dataKey="month"
                stroke="#BDBDBD"
                fontSize={12}
                tickLine={false}
                axisLine={false}
              />
              <YAxis
                stroke="#BDBDBD"
                fontSize={12}
                tickLine={false}
                axisLine={false}
                tickFormatter={(v) => `${(v / 1000000).toFixed(0)}M`}
              />
              <Tooltip
                cursor={{ fill: "rgba(0, 170, 19, 0.04)" }}
                contentStyle={{
                  borderRadius: "12px",
                  border: "1px solid #E0E0E0",
                  boxShadow: "0 4px 20px rgba(0,0,0,0.08)",
                  padding: "10px 14px",
                }}
                formatter={(value: number) => [
                  formatCurrency(value),
                  "Daromad",
                ]}
              />
              <Bar
                dataKey="amount"
                fill="url(#revenueGradient)"
                radius={[4, 4, 0, 0]}
                maxBarSize={48}
              />
            </BarChart>
          </ResponsiveContainer>
        </CardContent>
        <CardFooter className="flex items-center justify-between border-t border-gloss-border px-6 py-4">
          <div className="flex items-center gap-3">
            <div className="flex items-center gap-2">
              <div className="h-3 w-3 rounded-sm bg-gloss-green" />
              <span className="text-xs text-gloss-hint">Daromad</span>
            </div>
            <span className="text-xs text-gloss-hint">
              {revenueData[0].month} –{" "}
              {revenueData[revenueData.length - 1].month}
            </span>
          </div>
          <div className="text-right">
            <p className="text-xs text-gloss-hint">Jami daromad</p>
            <p className="text-lg font-bold text-gloss-text">
              {formatCurrency(totalRevenue)}
            </p>
          </div>
        </CardFooter>
      </Card>

      <Card>
        <CardHeader className="flex flex-row items-center justify-between">
          <div>
            <CardTitle>So'nggi buyurtmalar</CardTitle>
            <CardDescription>Oxirgi 7 ta buyurtma</CardDescription>
          </div>
          <a
            href="/platform/orders"
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
                <TableHead className="py-2.5">Tenant</TableHead>
                <TableHead className="py-2.5">Summa</TableHead>
                <TableHead className="py-2.5">Status</TableHead>
                <TableHead className="py-2.5">Sana</TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              {mockOrders.slice(0, 7).map((o) => (
                <TableRow key={o.id} className="group">
                  <TableCell className="py-2.5 font-mono text-xs font-medium text-gloss-hint">
                    {o.id}
                  </TableCell>
                  <TableCell className="py-2.5 font-medium text-gloss-text">
                    {o.service}
                  </TableCell>
                  <TableCell className="py-2.5">{o.tenant}</TableCell>
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
