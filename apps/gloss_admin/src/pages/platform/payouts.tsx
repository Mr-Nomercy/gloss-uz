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
    <div className="animate-slide-up space-y-6">
      <Card className="shadow-gloss-sm border-gray-100">
        <CardContent className="p-0">
          <Table>
            <TableHeader>
              <TableRow>
                <TableHead className="py-2">Tenant</TableHead>
                <TableHead className="py-2">Summa</TableHead>
                <TableHead className="py-2">Sana</TableHead>
                <TableHead className="py-2">Status</TableHead>
                <TableHead className="w-[100px] py-2"></TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              {mockPayouts.map((p) => (
                <TableRow
                  key={p.id}
                  className="hover:bg-gloss-green-bg-light/50"
                >
                  <TableCell className="px-4 py-2 font-medium">
                    {p.tenant}
                  </TableCell>
                  <TableCell className="px-4 py-2">
                    {formatCurrency(p.amount)}
                  </TableCell>
                  <TableCell className="px-4 py-2">{p.date}</TableCell>
                  <TableCell className="px-4 py-2">
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
                  <TableCell className="px-4 py-2">
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
