# POS Kasir Flutter - Backend Integration

## 📋 Overview

Project ini telah diintegrasikan dengan backend API Laravel yang sudah di-deploy di `http://supercashier.my.id/api`.

## 🔄 Perubahan Utama

### 1. **Models** (Updated & Created)
#### Updated: `lib/models/product.dart`
- Sesuai dengan schema backend (Laravel Product model)
- Fields: `product_id`, `categories_id`, `name`, `description`, `cost_price`, `selling_price`, `product_images`, `stock`, `barcode`
- JSON serialization: `fromJson()` dan `toJson()`
- Getter compatibility untuk UI lama

#### Created: `lib/models/sale.dart`
- Model `Sale` dan `SaleItem` sesuai backend schema
- Mendukung status: `draft`, `pending`, `paid`, `cancelled`
- Relasi lengkap dengan user, payment, dan items
- JSON serialization lengkap

### 2. **Services** (Created)
#### `lib/services/sale_service.dart`
API calls untuk manajemen sale:
- `createSale()` - Buat draft sale baru
- `addItem()` - Tambah produk ke sale (auto-deduct stock)
- `removeItem()` - Hapus item dari sale (auto-restore stock)
- `getSale()` - Fetch detail sale dengan items
- `deleteSale()` - Hapus draft sale (restore all stock)

#### `lib/services/product_service.dart`
API calls untuk products:
- `getProducts()` - Fetch semua products dengan filter category & search
- `getProduct()` - Fetch single product by ID
- `searchByBarcode()` - Cari product by barcode

### 3. **Provider** (Refactored)
#### `lib/providers/cart_provider.dart`
- Terintegrasi penuh dengan `SaleService` dan `ProductService`
- Loading states: `isLoadingProducts`, `isLoadingSale`, `isProcessing`
- Error handling dengan `errorMessage`
- Auto-create draft sale saat add item pertama
- Sync local cart dengan backend sale
- Backward compatible dengan UI existing

### 4. **UI Components** (Enhanced)
#### `lib/screens/catalog_screen.dart`
- Fetch products from API on init
- Loading indicator saat fetch
- Error state dengan retry button
- Empty state
- Auto-refresh catalog

#### `lib/screens/product_detail_dialog.dart`
- Async add to cart dengan loading state
- Error handling dengan snackbar
- Stock validation dari backend

## 🔌 Backend API Endpoints

### Authentication
- `POST /login` - Login & get JWT token (auto-injected via `AuthInterceptor`)

### Sales
- `POST /sales` - Create draft sale
- `POST /sales/items` - Add item to sale
- `DELETE /sales/items/{saleItemId}` - Remove item from sale
- `GET /sales/{saleId}` - Get sale details
- `DELETE /sales/{saleId}` - Delete draft sale

### Products
- `GET /products` - Fetch products (with optional filters)
- `GET /products/{productId}` - Get single product

## 🔐 Authentication Flow

1. User login via `LoginPage`
2. `AuthService` call `/login` endpoint
3. JWT token disimpan di `SharedPreferences`
4. `AuthInterceptor` auto-inject token ke semua request:
   ```dart
   headers['Authorization'] = 'Bearer $token'
   ```
5. Backend verify token dan extract `user_id`

## 🛒 Cart/Sale Flow

### **Auto-Create & Auto-Delete Sale**

1. **Browse Products**
   - `CatalogScreen` fetch products via `ProductService`
   - Display dengan filter & search

2. **Add to Cart (Auto-Create Sale)**
   - Klik product → `ProductDetailDialog`
   - User pilih quantity
   - Click "Tambah ke Keranjang"
   - `CartProvider.addProductToCart()`:
     - **Check if active sale exists**
     - **If NOT exists** → **Auto-create draft sale** via `SaleService.createSale()`
     - Add item via `SaleService.addItem()`
     - Backend auto-deduct stock
     - Update UI with response
   - ✅ **Draft sale otomatis dibuat saat add item pertama**

3. **Manage Cart**
   - View items di `PaymentScreen` / `CartPage`
   - Increase/decrease quantity (perlu implement via `addItem` lagi)
   - Remove item via `SaleService.removeItem()` (auto-restore stock)
   - **If last item removed** → **Auto-delete draft sale** via `SaleService.deleteSale()`
   - ✅ **Draft sale otomatis dihapus saat cart kosong**

4. **Checkout** (Coming Soon)
   - Update sale payment_id
   - Change payment_status to 'paid'
   - Generate receipt/invoice

### **Flow Diagram:**
```
┌─────────────────────────────────────────────────┐
│  User Browse Products                           │
│  └─> Fetch from API                            │
└─────────────────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────────────────┐
│  Add First Item to Cart                         │
│  ├─> Check: Sale exists? NO                     │
│  ├─> AUTO CREATE DRAFT SALE ✨                  │
│  │   POST /sales → sale_id: 123                │
│  └─> Add item to sale                          │
│      POST /sales/items                          │
│      └─> Stock deducted                        │
└─────────────────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────────────────┐
│  Add More Items                                 │
│  ├─> Sale already exists (sale_id: 123)        │
│  └─> Add items directly                        │
│      POST /sales/items                          │
└─────────────────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────────────────┐
│  Remove Items                                   │
│  ├─> DELETE /sales/items/{saleItemId}          │
│  ├─> Stock restored                            │
│  └─> Check: Cart empty? NO                     │
│      └─> Continue shopping                     │
└─────────────────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────────────────┐
│  Remove Last Item                               │
│  ├─> DELETE /sales/items/{saleItemId}          │
│  ├─> Stock restored                            │
│  ├─> Check: Cart empty? YES ✅                  │
│  ├─> Check: Sale status = 'draft'? YES ✅       │
│  └─> AUTO DELETE DRAFT SALE ✨                  │
│      DELETE /sales/{saleId}                     │
│      └─> All stock fully restored              │
└─────────────────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────────────────┐
│  CHECKOUT & PAYMENT (Coming Soon)              │
│  ├─> User selects payment method               │
│  ├─> Confirm payment                           │
│  └─> PUT /sales/{saleId}/checkout              │
│      ├─> payment_status: 'draft' → 'paid' ✅    │
│      ├─> payment_id: set                       │
│      └─> Sale PERMANENTLY SAVED 💾              │
│          NEVER auto-deleted!                    │
└─────────────────────────────────────────────────┘
```

## ⚠️ Important Notes

### Sale Lifecycle (Auto-Create & Auto-Delete)
- ✅ **Auto-Create**: Draft sale otomatis dibuat saat **add item pertama ke cart**
- ✅ **Auto-Delete**: Draft sale otomatis dihapus saat **remove item terakhir** (cart kosong) **HANYA jika status = 'draft'**
- ✅ **Protected Sales**: Sale dengan status 'paid', 'pending', 'cancelled' **TIDAK AKAN PERNAH** dihapus otomatis
- ✅ **Clean State**: Tidak ada draft sale menggantung di database
- ✅ **Stock Integrity**: Stock selalu konsisten (deduct on add, restore on remove/delete)
- ⚠️ **Payment Completion**: Saat pembayaran berhasil, sale status berubah ke 'paid' dan **disimpan permanent** di database

### Stock Management
- Stock **otomatis dikurangi** saat add item via backend
- Stock **otomatis dikembalikan** saat remove item atau delete sale
- Backend validate stock sebelum add item
- Error handling untuk insufficient stock

### Sale Status
- `draft` - Belum checkout, bisa diedit/delete, **AKAN auto-delete jika cart kosong**
- `pending` - Menunggu pembayaran, **PROTECTED** dari auto-delete
- `paid` - Sudah dibayar, **PERMANENT** di database, tidak bisa delete
- `cancelled` - Dibatalkan, **PROTECTED** dari auto-delete

**Important:** Auto-delete **HANYA** berlaku untuk sale dengan status `draft`!

### Tax Calculation
- Tax 11% dihitung di backend
- Formula: `total = subtotal - discount + tax`

## 🚀 Next Steps

### Priority Features
1. **Update Quantity** - Implement increase/decrease item quantity via API
2. **Payment Integration** - Complete checkout flow dengan payment methods
3. **Receipt Generation** - PDF/Print struk transaksi
4. **Transaction History** - View past sales
5. **Barcode Scanner** - Scan barcode untuk add product

### API Endpoints Needed
- `PUT /sales/items/{saleItemId}` - Update item quantity
- `POST /sales/{saleId}/checkout` - Finalize sale & payment
- `GET /sales` - List all sales (with filters)
- `GET /categories` - Fetch product categories

## 🐛 Testing

### Manual Testing
1. Login dengan credential valid
2. Browse products (harus fetch dari API)
3. Add product to cart (check sale created)
4. Add more items (check sale updated)
5. Remove item (check stock restored)
6. Check error handling (insufficient stock, network error)

### Check Logs
- LogInterceptor sudah enabled di `DioClient`
- Request & response body ditampilkan di console
- Monitor untuk debug API calls

## 📝 Code Quality

### Compile Errors: ✅ Fixed
- Semua model, service, provider terintegrasi
- Backward compatibility maintained
- Type-safe dengan proper null handling

### Warnings: ⚠️ (Optional)
- `use_build_context_synchronously` - Safe, ada `mounted` check
- `avoid_print` - Debug logging, bisa diganti dengan logger package

## 🔧 Configuration

### Base URL
File: `lib/services/dio_client.dart`
```dart
baseUrl: "http://supercashier.my.id/api"
```

### Timeout
```dart
connectTimeout: Duration(seconds: 10)
receiveTimeout: Duration(seconds: 10)
```

## 📚 Resources

- Backend Model: Laravel Eloquent (Product, Sale, SaleItem)
- State Management: Provider
- HTTP Client: Dio with interceptors
- Storage: SharedPreferences (JWT token)
