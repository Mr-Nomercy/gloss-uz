import { useState } from "react";
import { Card, CardContent } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table";
import { mockCommissions } from "@/lib/data";

export default function PlatformCommissions() {
  const [commissions, setCommissions] = useState(mockCommissions);
  const [editId, setEditId] = useState<string | null>(null);
  const [editVal, setEditVal] = useState(0);

  const saveEdit = (id: string) => {
    setCommissions(
      commissions.map((c) => (c.id === id ? { ...c, percent: editVal } : c)),
    );
    setEditId(null);
  };

  return (
    <div className="animate-slide-up space-y-6">
      <Card className="shadow-gloss-sm border-gray-100">
        <CardContent className="p-0">
          <Table>
            <TableHeader>
              <TableRow>
                <TableHead className="py-2">Xizmat</TableHead>
                <TableHead className="py-2">Komissiya %</TableHead>
                <TableHead className="w-[100px] py-2"></TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              {commissions.map((c) => (
                <TableRow
                  key={c.id}
                  className="hover:bg-gloss-green-bg-light/50"
                >
                  <TableCell className="px-4 py-2 font-medium">
                    {c.service}
                  </TableCell>
                  <TableCell className="px-4 py-2">
                    {editId === c.id ? (
                      <Input
                        type="number"
                        value={editVal}
                        onChange={(e) => setEditVal(Number(e.target.value))}
                        className="w-24"
                      />
                    ) : (
                      <span className="font-semibold text-gloss-green">
                        {c.percent}%
                      </span>
                    )}
                  </TableCell>
                  <TableCell className="px-4 py-2">
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
