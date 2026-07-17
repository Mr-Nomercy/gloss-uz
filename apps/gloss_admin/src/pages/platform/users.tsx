import { Card, CardContent } from '@/components/ui/card';
import { Badge } from '@/components/ui/badge';
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from '@/components/ui/table';

const users = [
  { id: '1', name: 'Platform Admin', phone: '+998 90 000 00 01', role: 'Platform admin', date: '2026-01-15' },
  { id: '2', name: 'Firma MCHJ Admin', phone: '+998 90 111 22 33', role: 'Tenant admin', date: '2026-02-20' },
  { id: '3', name: 'Toza Xizmat Admin', phone: '+998 91 222 33 44', role: 'Tenant admin', date: '2026-03-10' },
  { id: '4', name: 'Jasur Qurbonov', phone: '+998 93 123 45 67', role: 'Kuryer', date: '2026-04-05' },
  { id: '5', name: 'Dilnoza Rahimova', phone: '+998 94 987 65 43', role: 'Mijoz', date: '2026-05-12' },
  { id: '6', name: 'Akbar Soliyev', phone: '+998 95 555 66 77', role: 'Kuryer', date: '2026-06-01' },
  { id: '7', name: 'Malika Toshmatova', phone: '+998 97 333 22 11', role: 'Mijoz', date: '2026-06-15' },
];

export default function PlatformUsers() {
  return (
    <div className="space-y-6">
      <h2 className="text-2xl font-bold text-gloss-text">Foydalanuvchilar</h2>
      <Card>
        <CardContent className="p-0">
          <Table>
            <TableHeader>
              <TableRow>
                <TableHead>Ism</TableHead>
                <TableHead>Telefon</TableHead>
                <TableHead>Role</TableHead>
                <TableHead>Sana</TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              {users.map((u) => (
                <TableRow key={u.id}>
                  <TableCell className="font-medium">{u.name}</TableCell>
                  <TableCell>{u.phone}</TableCell>
                  <TableCell>
                    <Badge variant={u.role === 'Platform admin' ? 'default' : 'secondary'}>{u.role}</Badge>
                  </TableCell>
                  <TableCell>{u.date}</TableCell>
                </TableRow>
              ))}
            </TableBody>
          </Table>
        </CardContent>
      </Card>
    </div>
  );
}
