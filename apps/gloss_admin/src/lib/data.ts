export interface Tenant {
  id: string;
  name: string;
  phone: string;
  city: string;
  status: 'Aktiv' | 'Nofaol';
  orders: number;
  rating: number;
}

export interface Order {
  id: string;
  service: string;
  tenant: string;
  client: string;
  amount: number;
  status: 'Yangi' | 'Jarayonda' | 'Yetkazilgan' | 'Bekor qilingan';
  date: string;
}

export interface Worker {
  id: string;
  name: string;
  phone: string;
  status: 'Aktiv' | 'Nofaol';
  orders: number;
  rating: number;
}

export interface Product {
  id: string;
  name: string;
  price: number;
  category: string;
  image: string;
}

export interface Commission {
  id: string;
  service: string;
  percent: number;
}

export interface Payout {
  id: string;
  tenant: string;
  amount: number;
  date: string;
  status: 'Kutilmoqda' | "To'langan" | 'Rad etilgan';
}

export interface Transaction {
  id: string;
  type: string;
  amount: number;
  date: string;
  isIncome: boolean;
}

export interface Review {
  id: string;
  client: string;
  rating: number;
  comment: string;
  date: string;
}

export const mockTenants: Tenant[] = [
  {
    id: '1',
    name: 'Firma MCHJ',
    phone: '+998 90 111 22 33',
    city: 'Toshkent',
    status: 'Aktiv',
    orders: 234,
    rating: 4.8,
  },
  {
    id: '2',
    name: 'Toza Xizmat',
    phone: '+998 91 222 33 44',
    city: 'Samarqand',
    status: 'Aktiv',
    orders: 156,
    rating: 4.5,
  },
  {
    id: '3',
    name: 'Best Service',
    phone: '+998 93 333 44 55',
    city: 'Buxoro',
    status: 'Nofaol',
    orders: 89,
    rating: 4.2,
  },
  {
    id: '4',
    name: 'Clean Pro',
    phone: '+998 94 444 55 66',
    city: 'Toshkent',
    status: 'Aktiv',
    orders: 312,
    rating: 4.9,
  },
  {
    id: '5',
    name: 'Elite Clean',
    phone: '+998 95 555 66 77',
    city: 'Namangan',
    status: 'Aktiv',
    orders: 178,
    rating: 4.6,
  },
];

export const mockOrders: Order[] = [
  {
    id: '#1001',
    service: 'Uy tozalash',
    tenant: 'Firma MCHJ',
    client: 'Jasur Q.',
    amount: 250000,
    status: 'Yetkazilgan',
    date: '2026-07-15',
  },
  {
    id: '#1002',
    service: 'Gilam yuvish',
    tenant: 'Firma MCHJ',
    client: 'Dilnoza R.',
    amount: 180000,
    status: 'Jarayonda',
    date: '2026-07-16',
  },
  {
    id: '#1003',
    service: 'Avto yuvish',
    tenant: 'Toza Xizmat',
    client: 'Akbar S.',
    amount: 120000,
    status: 'Yangi',
    date: '2026-07-16',
  },
  {
    id: '#1004',
    service: 'Deraza tozalash',
    tenant: 'Best Service',
    client: 'Malika T.',
    amount: 300000,
    status: 'Bekor qilingan',
    date: '2026-07-14',
  },
  {
    id: '#1005',
    service: 'Mebel tozalash',
    tenant: 'Clean Pro',
    client: 'Timur A.',
    amount: 450000,
    status: 'Yetkazilgan',
    date: '2026-07-15',
  },
  {
    id: '#1006',
    service: 'Uy tozalash',
    tenant: 'Elite Clean',
    client: 'Shahnoza K.',
    amount: 200000,
    status: 'Jarayonda',
    date: '2026-07-16',
  },
  {
    id: '#1007',
    service: 'Gilam yuvish',
    tenant: 'Clean Pro',
    client: 'Botir M.',
    amount: 350000,
    status: 'Yangi',
    date: '2026-07-16',
  },
  {
    id: '#1008',
    service: 'Avto yuvish',
    tenant: 'Firma MCHJ',
    client: 'Otabek N.',
    amount: 100000,
    status: 'Yetkazilgan',
    date: '2026-07-15',
  },
];

export const mockWorkers: Worker[] = [
  { id: 'w1', name: 'Akbar Soliyev', phone: '+998 90 111 22 33', status: 'Aktiv', orders: 87, rating: 4.9 },
  { id: 'w2', name: 'Dilshod Karimov', phone: '+998 91 222 33 44', status: 'Aktiv', orders: 65, rating: 4.7 },
  { id: 'w3', name: 'Sardor Toshmatov', phone: '+998 93 333 44 55', status: 'Nofaol', orders: 42, rating: 4.3 },
  { id: 'w4', name: 'Jasur Aliyev', phone: '+998 94 444 55 66', status: 'Aktiv', orders: 103, rating: 4.8 },
];

export const mockProducts: Product[] = [
  { id: 'p1', name: 'Universal tozalash vositasi', price: 25000, category: 'Tozalash vositalari', image: '🧴' },
  { id: 'p2', name: 'Gilam shampuni', price: 45000, category: 'Tozalash vositalari', image: '🧪' },
  { id: 'p3', name: 'Mikrofibra salfetka', price: 12000, category: 'Inventar', image: '🧻' },
  { id: 'p4', name: 'Changyutgich filtri', price: 35000, category: 'Ehtiyot qismlar', image: '🔧' },
  { id: 'p5', name: 'Deraza tozalash spreyi', price: 18000, category: 'Tozalash vositalari', image: '🧴' },
];

export const mockCommissions: Commission[] = [
  { id: 'c1', service: 'Uy tozalash', percent: 10 },
  { id: 'c2', service: 'Gilam yuvish', percent: 12 },
  { id: 'c3', service: 'Avto yuvish', percent: 15 },
  { id: 'c4', service: 'Mebel tozalash', percent: 8 },
  { id: 'c5', service: 'Deraza tozalash', percent: 10 },
];

export const mockPayouts: Payout[] = [
  { id: 'py1', tenant: 'Firma MCHJ', amount: 1250000, date: '2026-07-10', status: "To'langan" },
  { id: 'py2', tenant: 'Toza Xizmat', amount: 980000, date: '2026-07-12', status: "To'langan" },
  { id: 'py3', tenant: 'Clean Pro', amount: 2100000, date: '2026-07-15', status: 'Kutilmoqda' },
  { id: 'py4', tenant: 'Elite Clean', amount: 750000, date: '2026-07-14', status: 'Rad etilgan' },
  { id: 'py5', tenant: 'Firma MCHJ', amount: 1500000, date: '2026-07-16', status: 'Kutilmoqda' },
];

export const mockTransactions: Transaction[] = [
  { id: 'tx1', type: "Buyurtma to'lovi", amount: 250000, date: '2026-07-15', isIncome: true },
  { id: 'tx2', type: 'Komissiya', amount: 25000, date: '2026-07-15', isIncome: false },
  { id: 'tx3', type: 'Pul chiqarish', amount: 500000, date: '2026-07-14', isIncome: false },
  { id: 'tx4', type: "Buyurtma to'lovi", amount: 180000, date: '2026-07-13', isIncome: true },
  { id: 'tx5', type: "Buyurtma to'lovi", amount: 300000, date: '2026-07-12', isIncome: true },
];

export const mockReviews: Review[] = [
  {
    id: 'r1',
    client: 'Jasur Q.',
    rating: 5,
    comment: 'Juda toza va tez ishlashdi. Tavsiya qilaman!',
    date: '2026-07-15',
  },
  {
    id: 'r2',
    client: 'Dilnoza R.',
    rating: 4,
    comment: 'Yaxshi ishlashdi, lekin biroz kech qolishdi.',
    date: '2026-07-14',
  },
  {
    id: 'r3',
    client: 'Akbar S.',
    rating: 5,
    comment: "A'lo xizmat! Keyingi safar ham buyurtma beraman.",
    date: '2026-07-13',
  },
  { id: 'r4', client: 'Malika T.', rating: 3, comment: "O'rtacha. Narx biroz yuqori.", date: '2026-07-12' },
  { id: 'r5', client: 'Timur A.', rating: 5, comment: "Eng zo'r tozalash xizmati! Rahmat.", date: '2026-07-11' },
];

export const revenueData = [
  { month: 'Yanvar', amount: 12000000 },
  { month: 'Fevral', amount: 15000000 },
  { month: 'Mart', amount: 13500000 },
  { month: 'Aprel', amount: 18000000 },
  { month: 'May', amount: 16500000 },
  { month: 'Iyun', amount: 21000000 },
  { month: 'Iyul', amount: 19500000 },
];
