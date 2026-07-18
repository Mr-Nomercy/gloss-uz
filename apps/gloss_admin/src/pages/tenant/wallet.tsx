import { Wallet, TrendingUp, TrendingDown } from "lucide-react";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table";
import { mockTransactions } from "@/lib/data";
import { formatCurrency } from "@/lib/utils";

export default function TenantWallet() {
  const balance = 8450000;
  const totalIncome = mockTransactions
    .filter((t) => t.isIncome)
    .reduce((s, t) => s + t.amount, 0);
  const totalExpense = mockTransactions
    .filter((t) => !t.isIncome)
    .reduce((s, t) => s + t.amount, 0);

  return (
    <div className="space-y-6">
      <h2 className="text-2xl font-bold text-gloss-text">Hamyon</h2>

      <Card className="bg-gradient-to-r from-gloss-green to-gloss-dark-green text-white">
        <CardContent className="p-8">
          <div className="flex items-center gap-4">
            <div className="rounded-xl bg-white/20 p-4">
              <Wallet className="h-8 w-8" />
            </div>
            <div>
              <p className="text-sm text-white/70">Joriy balans</p>
              <p className="text-3xl font-bold">{formatCurrency(balance)}</p>
            </div>
          </div>
        </CardContent>
      </Card>

      <div className="grid gap-4 md:grid-cols-2">
        <Card>
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium text-gloss-hint">
              Kirim
            </CardTitle>
            <TrendingUp className="h-4 w-4 text-gloss-green" />
          </CardHeader>
          <CardContent>
            <div className="text-xl font-bold text-gloss-green">
              {formatCurrency(totalIncome)}
            </div>
          </CardContent>
        </Card>
        <Card>
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium text-gloss-hint">
              Chiqim
            </CardTitle>
            <TrendingDown className="h-4 w-4 text-gloss-red" />
          </CardHeader>
          <CardContent>
            <div className="text-xl font-bold text-gloss-red">
              {formatCurrency(totalExpense)}
            </div>
          </CardContent>
        </Card>
      </div>

      <Card>
        <CardHeader>
          <CardTitle>Oxirgi tranzaksiyalar</CardTitle>
        </CardHeader>
        <CardContent>
          <Table>
            <TableHeader>
              <TableRow>
                <TableHead>Tur</TableHead>
                <TableHead>Summa</TableHead>
                <TableHead>Sana</TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              {mockTransactions.map((t) => (
                <TableRow key={t.id}>
                  <TableCell className="font-medium">{t.type}</TableCell>
                  <TableCell
                    className={
                      t.isIncome
                        ? "text-gloss-green font-semibold"
                        : "text-gloss-red font-semibold"
                    }
                  >
                    {t.isIncome ? "+" : "-"}
                    {formatCurrency(t.amount)}
                  </TableCell>
                  <TableCell>{t.date}</TableCell>
                </TableRow>
              ))}
            </TableBody>
          </Table>
        </CardContent>
      </Card>
    </div>
  );
}
