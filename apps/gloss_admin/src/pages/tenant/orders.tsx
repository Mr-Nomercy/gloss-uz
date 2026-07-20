import { useState } from "react";
import { Search } from "lucide-react";
import { Card, CardContent } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Badge } from "@/components/ui/badge";
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import { mockOrders } from "@/lib/data";
import { formatCurrency } from "@/lib/utils";

export default function TenantOrders() {
  const [search, setSearch] = useState("");
  const [statusFilter, setStatusFilter] = useState("all");

  const tenantOrders = mockOrders.filter((o) => o.tenant === "Firma MCHJ");
  const filtered = tenantOrders.filter((o) => {
    if (statusFilter !== "all" && o.status !== statusFilter) return false;
    if (
      search &&
      !o.service.toLowerCase().includes(search.toLowerCase()) &&
      !o.id.includes(search)
    )
      return false;
    return true;
  });

  return (
    <div className="space-y-6">
      <div className="flex flex-wrap gap-4">
        <div className="relative flex-1 max-w-sm">
          <Search className="absolute left-3 top-1/2 h-4 w-4 -translate-y-1/2 text-gloss-hint" />
          <Input
            placeholder="Qidirish..."
            value={search}
            onChange={(e) => setSearch(e.target.value)}
            className="pl-10"
          />
        </div>
        <Select value={statusFilter} onValueChange={setStatusFilter}>
          <SelectTrigger className="w-[180px]">
            <SelectValue placeholder="Status" />
          </SelectTrigger>
          <SelectContent>
            <SelectItem value="all">Barcha status</SelectItem>
            <SelectItem value="Yangi">Yangi</SelectItem>
            <SelectItem value="Jarayonda">Jarayonda</SelectItem>
            <SelectItem value="Yetkazilgan">Yetkazilgan</SelectItem>
            <SelectItem value="Bekor qilingan">Bekor qilingan</SelectItem>
          </SelectContent>
        </Select>
      </div>
      <Card>
        <CardContent className="p-0">
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
              {filtered.map((o) => (
                <TableRow key={o.id}>
                  <TableCell className="font-medium">{o.id}</TableCell>
                  <TableCell>{o.service}</TableCell>
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
