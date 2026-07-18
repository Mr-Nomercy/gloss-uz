import { DollarSign, ShoppingBag, Store, TrendingUp } from "lucide-react";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
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
import { formatCurrency } from "@/lib/utils";
import {
  BarChart,
  Bar,
  XAxis,
  YAxis,
  CartesianGrid,
  Tooltip,
  ResponsiveContainer,
} from "recharts";

export default function PlatformDashboard() {
  const stats = [
    {
      label: "Umumiy daromad",
      value: "146 500 000 so'm",
      icon: DollarSign,
      color: "text-gloss-green",
      bg: "bg-gloss-green-bg-light",
    },
    {
      label: "Bugungi buyurtmalar",
      value: "24 ta",
      icon: ShoppingBag,
      color: "text-blue-600",
      bg: "bg-blue-50",
    },
    {
      label: "Aktiv tenantlar",
      value: "5 ta",
      icon: Store,
      color: "text-purple-600",
      bg: "bg-purple-50",
    },
    {
      label: "Yig'ilgan komissiya",
      value: "14 650 000 so'm",
      icon: TrendingUp,
      color: "text-gloss-orange",
      bg: "bg-orange-50",
    },
  ];

  return (
    <div className="space-y-6">
      <h2 className="text-2xl font-bold text-gloss-text">Dashboard</h2>
      <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-4">
        {stats.map((s) => (
          <Card key={s.label}>
            <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
              <CardTitle className="text-sm font-medium text-gloss-hint">
                {s.label}
              </CardTitle>
              <div className={`rounded-lg p-2 ${s.bg}`}>
                <s.icon className={`h-4 w-4 ${s.color}`} />
              </div>
            </CardHeader>
            <CardContent>
              <div className="text-lg font-bold">{s.value}</div>
            </CardContent>
          </Card>
        ))}
      </div>

      <Card>
        <CardHeader>
          <CardTitle>Daromad statistikasi</CardTitle>
        </CardHeader>
        <CardContent>
          <ResponsiveContainer width="100%" height={300}>
            <BarChart data={revenueData}>
              <CartesianGrid strokeDasharray="3 3" stroke="#E0E0E0" />
              <XAxis dataKey="month" stroke="#757575" fontSize={12} />
              <YAxis
                stroke="#757575"
                fontSize={12}
                tickFormatter={(v) => `${(v / 1000000).toFixed(0)}M`}
              />
              <Tooltip
                formatter={(value: number) => [
                  formatCurrency(value),
                  "Daromad",
                ]}
              />
              <Bar dataKey="amount" fill="#00AA13" radius={[4, 4, 0, 0]} />
            </BarChart>
          </ResponsiveContainer>
        </CardContent>
      </Card>

      <Card>
        <CardHeader>
          <CardTitle>So'nggi buyurtmalar</CardTitle>
        </CardHeader>
        <CardContent>
          <Table>
            <TableHeader>
              <TableRow>
                <TableHead>ID</TableHead>
                <TableHead>Xizmat</TableHead>
                <TableHead>Tenant</TableHead>
                <TableHead>Mijoz</TableHead>
                <TableHead>Summa</TableHead>
                <TableHead>Status</TableHead>
                <TableHead>Sana</TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              {mockOrders.slice(0, 5).map((o) => (
                <TableRow key={o.id}>
                  <TableCell className="font-medium">{o.id}</TableCell>
                  <TableCell>{o.service}</TableCell>
                  <TableCell>{o.tenant}</TableCell>
                  <TableCell>{o.client}</TableCell>
                  <TableCell>{formatCurrency(o.amount)}</TableCell>
                  <TableCell>
                    <Badge
                      variant={
                        o.status === "Yetkazilgan"
                          ? "default"
                          : o.status === "Jarayonda"
                            ? "warning"
                            : o.status === "Bekor qilingan"
                              ? "destructive"
                              : "secondary"
                      }
                    >
                      {o.status}
                    </Badge>
                  </TableCell>
                  <TableCell>{o.date}</TableCell>
                </TableRow>
              ))}
            </TableBody>
          </Table>
        </CardContent>
      </Card>
    </div>
  );
}
