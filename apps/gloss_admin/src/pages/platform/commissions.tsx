import { useState } from 'react';
import { Card, CardContent } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from '@/components/ui/table';
import { mockCommissions } from '@/lib/data';

export default function PlatformCommissions() {
  const [commissions, setCommissions] = useState(mockCommissions);
  const [editId, setEditId] = useState<string | null>(null);
  const [editVal, setEditVal] = useState(0);

  const saveEdit = (id: string) => {
    setCommissions(commissions.map((c) => (c.id === id ? { ...c, percent: editVal } : c)));
    setEditId(null);
  };

  return (
    <div className="space-y-6">
      <h2 className="text-2xl font-bold text-gloss-text">Komissiyalar</h2>
      <Card>
        <CardContent className="p-0">
          <Table>
            <TableHeader>
              <TableRow>
                <TableHead>Xizmat</TableHead>
                <TableHead>Komissiya %</TableHead>
                <TableHead className="w-[100px]"></TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              {commissions.map((c) => (
                <TableRow key={c.id}>
                  <TableCell className="font-medium">{c.service}</TableCell>
                  <TableCell>
                    {editId === c.id ? (
                      <Input
                        type="number"
                        value={editVal}
                        onChange={(e) => setEditVal(Number(e.target.value))}
                        className="w-24"
                      />
                    ) : (
                      <span className="font-semibold text-gloss-green">{c.percent}%</span>
                    )}
                  </TableCell>
                  <TableCell>
                    {editId === c.id ? (
                      <Button size="sm" onClick={() => saveEdit(c.id)}>
                        Saqlash
                      </Button>
                    ) : (
                      <Button
                        size="sm"
                        variant="outline"
                        onClick={() => {
                          setEditId(c.id);
                          setEditVal(c.percent);
                        }}
                      >
                        Tahrirlash
                      </Button>
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
