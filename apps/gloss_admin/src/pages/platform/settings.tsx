import { useState } from "react";
import { Save } from "lucide-react";
import { Card, CardContent } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";

export default function PlatformSettings() {
  const [settings, setSettings] = useState({
    name: "Gloss",
    phone: "+998 71 200 00 00",
    email: "info@gloss.uz",
    minOrder: "30000",
  });

  const handleSave = () => {
    alert("Sozlamalar saqlandi!");
  };

  return (
    <div className="animate-slide-up space-y-6">
      <div className="flex items-center justify-between">
        <Button onClick={handleSave}>
          <Save className="mr-2 h-4 w-4" /> Saqlash
        </Button>
      </div>
      <Card className="shadow-gloss-sm border-gray-100">
        <CardContent className="space-y-4 pt-6">
          <div className="grid gap-4 md:grid-cols-2">
            <div className="space-y-2">
              <label className="text-sm font-medium">Platforma nomi</label>
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
              <label className="text-sm font-medium">Email</label>
              <Input
                value={settings.email}
                onChange={(e) =>
                  setSettings({ ...settings, email: e.target.value })
                }
              />
            </div>
            <div className="space-y-2">
              <label className="text-sm font-medium">
                Minimal buyurtma summasi
              </label>
              <Input
                value={settings.minOrder}
                onChange={(e) =>
                  setSettings({ ...settings, minOrder: e.target.value })
                }
              />
            </div>
          </div>
        </CardContent>
      </Card>
    </div>
  );
}
