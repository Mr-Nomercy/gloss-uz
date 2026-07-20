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
    <Badge variant={cfg.variant} className={cfg.className}>
      {status}
    </Badge>
  );
};

export default function PlatformOrders() {
  const [search, setSearch] = useState("");
  const [statusFilter, setStatusFilter] = useState("all");
  const [tenantFilter, setTenantFilter] = useState("all");

  const tenants = Array.from(new Set(mockOrders.map((o) => o.tenant)));
  const filtered = mockOrders.filter((o) => {
    if (statusFilter !== "all" && o.status !== statusFilter) return false;
    if (tenantFilter !== "all" && o.tenant !== tenantFilter) return false;
    if (
      search &&
      !o.service.toLowerCase().includes(search.toLowerCase()) &&
      !o.id.includes(search)
    )
      return false;
    return true;
  });

  return (
    <div className="animate-slide-up space-y-6">
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
        <Select value={tenantFilter} onValueChange={setTenantFilter}>
          <SelectTrigger className="w-[180px]">
            <SelectValue placeholder="Tenant" />
          </SelectTrigger>
          <SelectContent>
            <SelectItem value="all">Barcha tenantlar</SelectItem>
            {tenants.map((t) => (
              <SelectItem key={t} value={t}>
                {t}
              </SelectItem>
            ))}
          </SelectContent>
        </Select>
      </div>
      <Card className="shadow-gloss-sm border-gray-100">
        <CardContent className="p-0">
          <Table>
            <TableHeader>
              <TableRow>
                <TableHead className="py-2">ID</TableHead>
                <TableHead className="py-2">Xizmat</TableHead>
                <TableHead className="py-2">Tenant</TableHead>
                <TableHead className="py-2">Mijoz</TableHead>
                <TableHead className="py-2">Summa</TableHead>
                <TableHead className="py-2">Status</TableHead>
                <TableHead className="py-2">Sana</TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              {filtered.map((o) => (
                <TableRow
                  key={o.id}
                  className="hover:bg-gloss-green-bg-light/50"
                >
                  <TableCell className="px-4 py-2 font-medium">
                    {o.id}
                  </TableCell>
                  <TableCell className="px-4 py-2">{o.service}</TableCell>
                  <TableCell className="px-4 py-2">{o.tenant}</TableCell>
                  <TableCell className="px-4 py-2">{o.client}</TableCell>
                  <TableCell className="px-4 py-2">
                    {formatCurrency(o.amount)}
                  </TableCell>
                  <TableCell className="px-4 py-2">
                    {statusBadge(o.status)}
                  </TableCell>
                  <TableCell className="px-4 py-2">{o.date}</TableCell>
                </TableRow>
              ))}
            </TableBody>
          </Table>
        </CardContent>
      </Card>
    </div>
  );
}
