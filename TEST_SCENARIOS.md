# Test Scenario: Auto Create & Delete Sale

## 📋 Test Cases

### ✅ Test Case 1: Auto-Create Sale on First Item

**Precondition:**
- User sudah login
- Cart kosong
- Tidak ada active draft sale

**Steps:**
1. Browse products di `CatalogScreen`
2. Klik product pertama
3. Set quantity = 1
4. Klik "Tambah ke Keranjang"

**Expected Result:**
- ✅ Draft sale otomatis dibuat (POST /sales)
- ✅ Item ditambahkan ke sale (POST /sales/items)
- ✅ Stock produk berkurang
- ✅ Cart menampilkan 1 item
- ✅ Total terhitung dengan benar
- ✅ Snackbar success muncul

**Verify in Console:**
```
[INFO] POST /sales
[INFO] Response: {sale_id: 123, payment_status: 'draft', ...}
[INFO] POST /sales/items
[INFO] Response: {sale_id: 123, items: [...]}
```

---

### ✅ Test Case 2: Add Multiple Items (Sale Already Exists)

**Precondition:**
- Draft sale sudah ada (dari Test Case 1)
- Cart berisi 1+ items

**Steps:**
1. Browse products
2. Klik product kedua
3. Set quantity = 2
4. Klik "Tambah ke Keranjang"

**Expected Result:**
- ✅ TIDAK create sale baru (reuse existing sale_id)
- ✅ Item langsung ditambahkan ke sale yang ada
- ✅ Stock produk berkurang
- ✅ Cart menampilkan 2 items
- ✅ Subtotal & total update

**Verify in Console:**
```
[INFO] POST /sales/items (NO POST /sales)
[INFO] sale_id: 123 (same as before)
```

---

### ✅ Test Case 3: Remove Item (Cart Not Empty)

**Precondition:**
- Cart berisi 2+ items
- Draft sale exists

**Steps:**
1. Buka cart page
2. Klik delete icon pada item pertama

**Expected Result:**
- ✅ Item dihapus via API (DELETE /sales/items/{id})
- ✅ Stock produk dikembalikan
- ✅ Cart update (1 item tersisa)
- ✅ Sale TIDAK dihapus (masih ada item lain)
- ✅ Total terhitung ulang

**Verify in Console:**
```
[INFO] DELETE /sales/items/456
[INFO] Response: {sale_id: 123, items: [1 item remaining]}
```

---

### ✅ Test Case 4: Auto-Delete Sale on Last Item Removal

**Precondition:**
- Cart berisi HANYA 1 item
- Draft sale exists

**Steps:**
1. Buka cart page
2. Klik delete icon pada item terakhir

**Expected Result:**
- ✅ Item dihapus via API (DELETE /sales/items/{id})
- ✅ Stock produk dikembalikan
- ✅ Cart kosong
- ✅ **Sale OTOMATIS DIHAPUS** (DELETE /sales/{id})
- ✅ Console log: "Cart is empty, auto-deleting draft sale..."
- ✅ Empty cart UI muncul

**Verify in Console:**
```
[INFO] DELETE /sales/items/789
[INFO] Response: {sale_id: 123, items: []}
[INFO] Cart is empty, auto-deleting draft sale 123
[INFO] DELETE /sales/123
[INFO] Response: {message: 'Sale deleted successfully'}
```

**Verify in Backend Database:**
```sql
-- Sale harus sudah terhapus
SELECT * FROM sales WHERE sale_id = 123;  -- 0 rows

-- Sale items juga sudah terhapus
SELECT * FROM sale_items WHERE sale_id = 123;  -- 0 rows

-- Stock harus kembali seperti semula
SELECT stock FROM products WHERE product_id = xxx;  -- original stock
```

---

### ✅ Test Case 5: Add After Auto-Delete (Clean Start)

**Precondition:**
- Cart kosong (dari Test Case 4)
- Previous draft sale sudah terhapus

**Steps:**
1. Browse products lagi
2. Klik product
3. Tambah ke cart

**Expected Result:**
- ✅ **Draft sale BARU dibuat** (sale_id berbeda)
- ✅ Item ditambahkan
- ✅ Flow sama seperti Test Case 1

**Verify in Console:**
```
[INFO] POST /sales
[INFO] Response: {sale_id: 124, ...}  // New sale_id!
```

---

### ✅ Test Case 6: Paid Sale Protection (No Auto-Delete)

**Precondition:**
- User completed checkout
- Sale status changed to 'paid'
- Sale items still in cart view (optional, tergantung UI flow)

**Steps:**
1. User tries to clear cart or remove items after payment

**Expected Result:**
- ✅ **Sale TIDAK dihapus** (status != 'draft')
- ✅ Console log: "Warning: Cannot delete sale X - status is paid"
- ✅ Error message: "Cannot delete completed sales"
- ✅ Sale tetap tersimpan di database
- ✅ Stock TIDAK dikembalikan

**Verify in Console:**
```
[INFO] Attempting to delete sale 123...
[WARN] Warning: Cannot delete sale 123 - status is paid
[INFO] Sale protected from deletion
```

**Verify in Backend Database:**
```sql
-- Sale masih ada dengan status 'paid'
SELECT * FROM sales WHERE sale_id = 123;
-- payment_status = 'paid' ✅

-- Sale items tetap ada
SELECT * FROM sale_items WHERE sale_id = 123;
-- All items preserved ✅

-- Stock TIDAK berubah (tetap sudah dikurangi)
```

---

## 🔍 Edge Cases to Test

### Edge Case 1: Network Error During Delete
**Scenario:** Remove last item, tapi DELETE /sales gagal

**Expected:**
- Item tetap dihapus dari sale_items
- Error message muncul
- User bisa retry manual delete

### Edge Case 2: Multiple Rapid Add/Remove
**Scenario:** User spam add & remove items cepat

**Expected:**
- Loading state mencegah duplicate requests
- Sale lifecycle tetap konsisten
- No race conditions

### Edge Case 3: Insufficient Stock
**Scenario:** Add item lebih dari stock available

**Expected:**
- Backend reject request (422)
- Error message: "Insufficient stock..."
- Sale tidak terpengaruh

### Edge Case 4: Token Expired During Operation
**Scenario:** JWT expired saat add/remove item

**Expected:**
- 401 Unauthorized response
- Redirect ke login page
- Draft sale tetap tersimpan (bisa resume after login)

---

## 📊 Verification Checklist

### Frontend Verification:
- [ ] Console logs menunjukkan flow yang benar
- [ ] Loading indicators muncul saat processing
- [ ] Error messages ditampilkan jika gagal
- [ ] Cart count badge update realtime
- [ ] Total & subtotal terhitung benar
- [ ] Empty cart state muncul setelah delete all

### Backend Verification:
- [ ] Sale record dibuat dengan status 'draft'
- [ ] Sale_items records match dengan cart
- [ ] Stock values updated correctly
- [ ] Sale & sale_items terhapus saat cart kosong
- [ ] No orphaned records di database
- [ ] Transaction logs tercatat

### Integration Verification:
- [ ] Stock consistency antara frontend & backend
- [ ] Sale ID sama di semua operations
- [ ] Auto-delete hanya untuk status 'draft'
- [ ] Payment status transitions correctly

---

## 🐛 Known Issues / Limitations

1. **Quantity Update**: Belum ada endpoint PUT /sales/items/{id}
   - Workaround: Remove & add again

2. **Concurrent Users**: Belum handle jika user login di multiple devices
   - Could have multiple draft sales

3. **Timeout Handling**: Long operations could timeout
   - Need retry mechanism

4. **Optimistic Updates**: UI updates after API success
   - Could show stale data if network slow

---

## 💡 Testing Tips

1. **Monitor Console Logs:**
   ```powershell
   flutter run --verbose
   ```

2. **Watch Backend Logs:**
   - Check Laravel logs for API calls
   - Monitor database queries

3. **Use Network Inspector:**
   - Chrome DevTools → Network tab
   - Filter: XHR/Fetch

4. **Database Monitoring:**
   ```sql
   -- Watch draft sales
   SELECT * FROM sales WHERE payment_status = 'draft' ORDER BY created_at DESC;
   
   -- Check stock changes
   SELECT product_id, name, stock FROM products ORDER BY updated_at DESC;
   ```

5. **Clear State Between Tests:**
   - Logout & login
   - Clear SharedPreferences
   - Delete draft sales manually if needed

---

## ✅ Success Criteria

Test dianggap **PASS** jika:
1. ✅ Draft sale otomatis dibuat hanya sekali per shopping session
2. ✅ Draft sale otomatis dihapus saat cart kosong
3. ✅ Stock selalu konsisten dengan cart state
4. ✅ No orphaned sales atau sale_items di database
5. ✅ Error handling bekerja untuk semua edge cases
6. ✅ UI responsive dan user-friendly
7. ✅ Performance acceptable (<2s per operation)
