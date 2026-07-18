import { useState } from "react";
import { Save } from "lucide-react";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";

export default function TenantSettings() {
  const [settings, setSettings] = useState({
    name: "Firma MCHJ",
    phone: "+998 90 111 22 33",
    address: "Toshkent sh., Amir Temur ko'chasi, 45",
  });

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <h2 className="text-2xl font-bold text-gloss-text">Sozlamalar</h2>
        <Button onClick={() => alert("Sozlamalar saqlandi!")}>
          <Save className="mr-2 h-4 w-4" /> Saqlash
        </Button>
      </div>
      <Card>
        <CardHeader>
          <CardTitle>Firma ma'lumotlari</CardTitle>
        </CardHeader>
        <CardContent className="space-y-4">
          <div className="space-y-2">
            <label className="text-sm font-medium">Firma nomi</label>
            <Input
              value={settings.name}
              onChange={(e) =>
                setSettings({ ...settings, name: e.target.value })
              }
            />
          </div>
          <div className="space-y-2">
            <label className="text-sm font-medium">Telefon</label>
            <Input
              value={settings.phone}
              onChange={(e) =>
                setSettings({ ...settings, phone: e.target.value })
              }
            />
          </div>
          <div className="space-y-2">
            <label className="text-sm font-medium">Manzil</label>
            <Input
              value={settings.address}
              onChange={(e) =>
                setSettings({ ...settings, address: e.target.value })
              }
            />
          </div>
        </CardContent>
      </Card>
    </div>
  );
}
