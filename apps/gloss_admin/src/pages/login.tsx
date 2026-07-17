import { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { LogIn, AlertCircle } from 'lucide-react';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Card, CardContent, CardHeader, CardTitle, CardDescription } from '@/components/ui/card';
import { useAuth } from '@/lib/auth';

export default function Login() {
  const [email, setEmail] = useState('admin@gloss.uz');
  const [password, setPassword] = useState('admin123');
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(false);
  const { login } = useAuth();
  const navigate = useNavigate();

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setError('');
    setLoading(true);
    const ok = await login(email, password);
    setLoading(false);
    if (ok) {
      if (email === 'admin@gloss.uz') {
        navigate('/platform', { replace: true });
      } else {
        navigate('/tenant', { replace: true });
      }
    } else {
      setError("Email yoki parol noto'g'ri");
    }
  };

  return (
    <div className="flex min-h-screen items-center justify-center bg-gradient-to-br from-gloss-green to-gloss-dark-green p-4">
      <Card className="w-full max-w-md">
        <CardHeader className="text-center">
          <div className="mx-auto mb-4 flex h-14 w-14 items-center justify-center rounded-xl bg-gloss-green">
            <span className="text-2xl font-bold text-white">G</span>
          </div>
          <CardTitle className="text-2xl font-bold">Gloss Admin</CardTitle>
          <CardDescription>Platformaga kirish uchun ma'lumotlarni kiriting</CardDescription>
        </CardHeader>
        <CardContent>
          <form onSubmit={handleSubmit} className="space-y-4">
            {error && (
              <div className="flex items-center gap-2 rounded-lg bg-red-50 p-3 text-sm text-gloss-red">
                <AlertCircle className="h-4 w-4" />
                {error}
              </div>
            )}
            <div className="space-y-2">
              <label className="text-sm font-medium text-gloss-text">Email</label>
              <Input
                type="email"
                placeholder="admin@gloss.uz"
                value={email}
                onChange={(e) => setEmail(e.target.value)}
                required
              />
            </div>
            <div className="space-y-2">
              <label className="text-sm font-medium text-gloss-text">Parol</label>
              <Input
                type="password"
                placeholder="********"
                value={password}
                onChange={(e) => setPassword(e.target.value)}
                required
              />
            </div>
            <Button type="submit" className="w-full" size="lg" disabled={loading}>
              {loading ? (
                'Kutilmoqda...'
              ) : (
                <>
                  <LogIn className="mr-2 h-4 w-4" />
                  Kirish
                </>
              )}
            </Button>
            <div className="mt-4 rounded-lg bg-gloss-green-bg-light p-3 text-xs text-gloss-green-text">
              <p className="font-semibold mb-1">Test hisoblari:</p>
              <p>Admin: admin@gloss.uz / admin123</p>
              <p>Tenant: firma@gloss.uz / firma123</p>
            </div>
          </form>
        </CardContent>
      </Card>
    </div>
  );
}
