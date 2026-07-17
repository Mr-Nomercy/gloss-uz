import { Wallet, ShoppingBag, Users, Star } from 'lucide-react';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from '@/components/ui/table';
import { Badge } from '@/components/ui/badge';
import { mockOrders } from '@/lib/data';
import { formatCurrency } from '@/lib/utils';

export default function TenantDashboard() {
  const stats = [
    {
      label: 'Balans',
      value: "8 450 000 so'm",
      icon: Wallet,
      color: 'text-gloss-green',
      bg: 'bg-gloss-green-bg-light',
    },
    { label: 'Buyurtmalar', value: '234 ta', icon: ShoppingBag, color: 'text-blue-600', bg: 'bg-blue-50' },
    { label: 'Ishchilar', value: '4 ta', icon: Users, color: 'text-purple-600', bg: 'bg-purple-50' },
    { label: 'Reyting', value: '4.8 ⭐', icon: Star, color: 'text-gloss-star', bg: 'bg-yellow-50' },
  ];

  const tenantOrders = mockOrders.filter((o) => o.tenant === 'Firma MCHJ');

  return (
    <div className="space-y-6">
      <h2 className="text-2xl font-bold text-gloss-text">Dashboard</h2>
      <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-4">
        {stats.map((s) => (
          <Card key={s.label}>
            <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
              <CardTitle className="text-sm font-medium text-gloss-hint">{s.label}</CardTitle>
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
          <CardTitle>So'nggi buyurtmalar</CardTitle>
        </CardHeader>
        <CardContent>
          <Table>
            <TableHeader>
              <TableRow>
                <TableHead>ID</TableHead>
                <TableHead>Xizmat</TableHead>
                <TableHead>Mijoz</TableHead>
                <TableHead>Summa</TableHead>
                <TableHead>Status</TableHead>
                <TableHead>Sana</TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              {tenantOrders.map((o) => (
                <TableRow key={o.id}>
                  <TableCell className="font-medium">{o.id}</TableCell>
                  <TableCell>{o.service}</TableCell>
                  <TableCell>{o.client}</TableCell>
                  <TableCell>{formatCurrency(o.amount)}</TableCell>
                  <TableCell>
                    <Badge
                      variant={
                        o.status === 'Yetkazilgan'
                          ? 'default'
                          : o.status === 'Jarayonda'
                            ? 'warning'
                            : o.status === 'Bekor qilingan'
                              ? 'destructive'
                              : 'secondary'
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
