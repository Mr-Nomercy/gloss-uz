import { Card, CardContent } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table";

const users = [
  {
    id: "1",
    name: "Platform Admin",
    phone: "+998 90 000 00 01",
    role: "Platform admin",
    date: "2026-01-15",
  },
  {
    id: "2",
    name: "Firma MCHJ Admin",
    phone: "+998 90 111 22 33",
    role: "Tenant admin",
    date: "2026-02-20",
  },
  {
    id: "3",
    name: "Toza Xizmat Admin",
    phone: "+998 91 222 33 44",
    role: "Tenant admin",
    date: "2026-03-10",
  },
  {
    id: "4",
    name: "Jasur Qurbonov",
    phone: "+998 93 123 45 67",
    role: "Kuryer",
    date: "2026-04-05",
  },
  {
    id: "5",
    name: "Dilnoza Rahimova",
    phone: "+998 94 987 65 43",
    role: "Mijoz",
    date: "2026-05-12",
  },
  {
    id: "6",
    name: "Akbar Soliyev",
    phone: "+998 95 555 66 77",
    role: "Kuryer",
    date: "2026-06-01",
  },
  {
    id: "7",
    name: "Malika Toshmatova",
    phone: "+998 97 333 22 11",
    role: "Mijoz",
    date: "2026-06-15",
  },
];

const roleBadge = (role: string) => {
  const map: Record<
    string,
    {
      variant: "default" | "warning" | "destructive" | "secondary";
      className?: string;
    }
  > = {
    "Platform admin": { variant: "default" },
    "Tenant admin": {
      variant: "secondary",
      className: "bg-blue-100 text-blue-700 border-blue-200",
    },
    Kuryer: { variant: "warning" },
    Mijoz: { variant: "secondary" },
  };
  const cfg = map[role] ?? { variant: "secondary" as const };
  return (
    <Badge variant={cfg.variant} className={cfg.className}>
      {role}
    </Badge>
  );
};

export default function PlatformUsers() {
  return (
    <div className="animate-slide-up space-y-6">
      <Card className="shadow-gloss-sm border-gray-100">
        <CardContent className="p-0">
          <Table>
            <TableHeader>
              <TableRow>
                <TableHead className="py-2">Ism</TableHead>
                <TableHead className="py-2">Telefon</TableHead>
                <TableHead className="py-2">Role</TableHead>
                <TableHead className="py-2">Sana</TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              {users.map((u) => (
                <TableRow
                  key={u.id}
                  className="hover:bg-gloss-green-bg-light/50"
                >
                  <TableCell className="px-4 py-2 font-medium">
                    {u.name}
                  </TableCell>
                  <TableCell className="px-4 py-2">{u.phone}</TableCell>
                  <TableCell className="px-4 py-2">
                    {roleBadge(u.role)}
                  </TableCell>
                  <TableCell className="px-4 py-2">{u.date}</TableCell>
                </TableRow>
              ))}
            </TableBody>
          </Table>
        </CardContent>
      </Card>
    </div>
  );
}
