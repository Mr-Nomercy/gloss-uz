import { Card, CardContent } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table";
import { mockPayouts } from "@/lib/data";
import { formatCurrency } from "@/lib/utils";

export default function PlatformPayouts() {
  return (
    <div className="space-y-6">
      <h2 className="text-2xl font-bold text-gloss-text">To'lovlar</h2>
      <Card>
        <CardContent className="p-0">
          <Table>
            <TableHeader>
              <TableRow>
                <TableHead>Tenant</TableHead>
                <TableHead>Summa</TableHead>
                <TableHead>Sana</TableHead>
                <TableHead>Status</TableHead>
                <TableHead className="w-[100px]"></TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              {mockPayouts.map((p) => (
                <TableRow key={p.id}>
                  <TableCell className="font-medium">{p.tenant}</TableCell>
                  <TableCell>{formatCurrency(p.amount)}</TableCell>
                  <TableCell>{p.date}</TableCell>
                  <TableCell>
                    <Badge
                      variant={
                        p.status === "To'langan"
                          ? "default"
                          : p.status === "Kutilmoqda"
                            ? "warning"
                            : "destructive"
                      }
                    >
                      {p.status}
                    </Badge>
                  </TableCell>
                  <TableCell>
                    {p.status === "Kutilmoqda" && (
                      <Button size="sm">To'lash</Button>
                    )}
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
