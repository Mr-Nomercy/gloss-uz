import { useState } from 'react';
import { Plus } from 'lucide-react';
import { Card, CardContent } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from '@/components/ui/table';
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogFooter } from '@/components/ui/dialog';
import { mockProducts, Product } from '@/lib/data';
import { formatCurrency } from '@/lib/utils';

export default function PlatformMarket() {
  const [products, setProducts] = useState(mockProducts);
  const [open, setOpen] = useState(false);
  const [form, setForm] = useState({ name: '', price: '', category: '' });

  const addProduct = () => {
    const p: Product = {
      id: `p${products.length + 1}`,
      name: form.name,
      price: Number(form.price),
      category: form.category,
      image: '📦',
    };
    setProducts([...products, p]);
    setForm({ name: '', price: '', category: '' });
    setOpen(false);
  };

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <h2 className="text-2xl font-bold text-gloss-text">Market</h2>
        <Button onClick={() => setOpen(true)}>
          <Plus className="mr-2 h-4 w-4" /> Qo'shish
        </Button>
      </div>
      <Card>
        <CardContent className="p-0">
          <Table>
            <TableHeader>
              <TableRow>
                <TableHead>Rasm</TableHead>
                <TableHead>Nomi</TableHead>
                <TableHead>Narx</TableHead>
                <TableHead>Kategoriya</TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              {products.map((p) => (
                <TableRow key={p.id}>
                  <TableCell className="text-2xl">{p.image}</TableCell>
                  <TableCell className="font-medium">{p.name}</TableCell>
                  <TableCell>{formatCurrency(p.price)}</TableCell>
                  <TableCell>{p.category}</TableCell>
                </TableRow>
              ))}
            </TableBody>
          </Table>
        </CardContent>
      </Card>

      <Dialog open={open} onOpenChange={setOpen}>
        <DialogContent>
          <DialogHeader>
            <DialogTitle>Yangi mahsulot qo'shish</DialogTitle>
          </DialogHeader>
          <div className="space-y-4">
            <div>
              <label className="text-sm font-medium">Nomi</label>
              <Input
                value={form.name}
                onChange={(e) => setForm({ ...form, name: e.target.value })}
                placeholder="Mahsulot nomi"
              />
            </div>
            <div>
              <label className="text-sm font-medium">Narx</label>
              <Input
                type="number"
                value={form.price}
                onChange={(e) => setForm({ ...form, price: e.target.value })}
                placeholder="25000"
              />
            </div>
            <div>
              <label className="text-sm font-medium">Kategoriya</label>
              <Input
                value={form.category}
                onChange={(e) => setForm({ ...form, category: e.target.value })}
                placeholder="Tozalash vositalari"
              />
            </div>
          </div>
          <DialogFooter>
            <Button variant="outline" onClick={() => setOpen(false)}>
              Bekor qilish
            </Button>
            <Button onClick={addProduct} disabled={!form.name}>
              Qo'shish
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>
    </div>
  );
}
