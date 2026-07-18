import { useState } from "react";
import { Plus, Star } from "lucide-react";
import { Card, CardContent } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
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
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
  DialogFooter,
} from "@/components/ui/dialog";
import { mockWorkers, Worker } from "@/lib/data";

export default function TenantWorkers() {
  const [workers, setWorkers] = useState(mockWorkers);
  const [open, setOpen] = useState(false);
  const [form, setForm] = useState({ name: "", phone: "" });

  const addWorker = () => {
    const w: Worker = {
      id: `w${workers.length + 1}`,
      name: form.name,
      phone: form.phone,
      status: "Aktiv",
      orders: 0,
      rating: 0,
    };
    setWorkers([...workers, w]);
    setForm({ name: "", phone: "" });
    setOpen(false);
  };

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <h2 className="text-2xl font-bold text-gloss-text">Ishchilar</h2>
        <Button onClick={() => setOpen(true)}>
          <Plus className="mr-2 h-4 w-4" /> Qo'shish
        </Button>
      </div>
      <Card>
        <CardContent className="p-0">
          <Table>
            <TableHeader>
              <TableRow>
                <TableHead>Ism</TableHead>
                <TableHead>Telefon</TableHead>
                <TableHead>Status</TableHead>
                <TableHead>Buyurtmalar</TableHead>
                <TableHead>Reyting</TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              {workers.map((w) => (
                <TableRow key={w.id}>
                  <TableCell className="font-medium">{w.name}</TableCell>
                  <TableCell>{w.phone}</TableCell>
                  <TableCell>
                    <Badge
                      variant={w.status === "Aktiv" ? "default" : "secondary"}
                    >
                      {w.status}
                    </Badge>
                  </TableCell>
                  <TableCell>{w.orders}</TableCell>
                  <TableCell className="flex items-center gap-1">
                    <Star className="h-3 w-3 fill-gloss-star text-gloss-star" />
                    {w.rating}
                  </TableCell>
                </TableRow>
              ))}
            </TableBody>
          </Table>
        </CardContent>
      </Card>

      <Dialog open={open} onOpenChange={setOpen}>
        <DialogContent>
          <DialogHeader>
            <DialogTitle>Yangi ishchi qo'shish</DialogTitle>
          </DialogHeader>
          <div className="space-y-4">
            <div>
              <label className="text-sm font-medium">Ism</label>
              <Input
                value={form.name}
                onChange={(e) => setForm({ ...form, name: e.target.value })}
                placeholder="Ism familiya"
              />
            </div>
            <div>
              <label className="text-sm font-medium">Telefon</label>
              <Input
                value={form.phone}
                onChange={(e) => setForm({ ...form, phone: e.target.value })}
                placeholder="+998 90 123 45 67"
              />
            </div>
          </div>
          <DialogFooter>
            <Button variant="outline" onClick={() => setOpen(false)}>
              Bekor qilish
            </Button>
            <Button onClick={addWorker} disabled={!form.name}>
              Qo'shish
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>
    </div>
  );
}
