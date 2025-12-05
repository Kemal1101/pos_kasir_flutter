import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';
import '../../utils/responsive_helper.dart';

class CashPaymentScreen extends StatefulWidget {
  final double total;

  const CashPaymentScreen({super.key, required this.total});

  @override
  State<CashPaymentScreen> createState() => _CashPaymentScreenState();
}

class _CashPaymentScreenState extends State<CashPaymentScreen> {
  final TextEditingController cashController = TextEditingController(text: "");

  double get cash => double.tryParse(cashController.text) ?? 0;
  double get change => cash - widget.total;

  void addQuickCash(int amount) {
    final current = double.tryParse(cashController.text) ?? 0;
    cashController.text = (current + amount).toStringAsFixed(0);
    setState(() {});
  }

  String format(double number) {
    final s = number.toInt().toString();
    final reg = RegExp(r'\B(?=(\d{3})+(?!\d))');
    return s.replaceAllMapped(reg, (m) => '.');
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape = ResponsiveHelper.isLandscape(context);
    
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(
          "Cash Payment",
          style: TextStyle(
            fontSize: isLandscape ? 16 : 20,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        toolbarHeight: isLandscape ? 40 : kToolbarHeight,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF7F56D9), Color(0xFFE94B9C)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),

      body: SafeArea(
        child: isLandscape 
          ? _buildLandscapeLayout()
          : _buildPortraitLayout(),
      ),
    );
  }

  Widget _buildLandscapeLayout() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left side - Total & Input
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                /// TOTAL
                Text(
                  "Total Belanja",
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                ),
                const SizedBox(height: 4),
                Text(
                  "Rp ${format(widget.total)}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF5B4EC3),
                  ),
                ),
                const SizedBox(height: 12),

                /// INPUT CASH
                const Text(
                  "Nominal Uang Customer",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: TextField(
                    controller: cashController,
                    keyboardType: TextInputType.number,
                    onChanged: (v) => setState(() {}),
                    style: const TextStyle(fontSize: 14),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Masukkan nominal",
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                /// QUICK BUTTONS
                Row(
                  children: [
                    quickButton("20K", () => addQuickCash(20000), true),
                    quickButton("50K", () => addQuickCash(50000), true),
                    quickButton("100K", () => addQuickCash(100000), true),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Right side - Change & Button
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                /// KEMBALIAN
                Text(
                  "Kembalian",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: change >= 0 ? Colors.green : Colors.red,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  change >= 0
                      ? "Rp ${format(change)}"
                      : "Kurang Rp ${format(change.abs())}",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: change >= 0 ? Colors.green : Colors.red,
                  ),
                ),
                const SizedBox(height: 16),

                /// CONFIRM BUTTON
                SizedBox(
                  width: double.infinity,
                  height: 40,
                  child: _buildConfirmButton(true),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPortraitLayout() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// TOTAL
          Text(
            "Total Belanja",
            style: TextStyle(fontSize: 15, color: Colors.grey.shade700),
          ),
          const SizedBox(height: 6),
          Text(
            "Rp ${format(widget.total)}",
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF5B4EC3),
            ),
          ),
          const SizedBox(height: 26),

          /// INPUT CASH
          const Text(
            "Nominal Uang Customer",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: TextField(
              controller: cashController,
              keyboardType: TextInputType.number,
              onChanged: (v) => setState(() {}),
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: "Masukkan nominal uang",
              ),
            ),
          ),
          const SizedBox(height: 16),

          /// QUICK BUTTONS
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              quickButton("20.000", () => addQuickCash(20000), false),
              quickButton("50.000", () => addQuickCash(50000), false),
              quickButton("100.000", () => addQuickCash(100000), false),
            ],
          ),
          const SizedBox(height: 26),

          /// KEMBALIAN
          Text(
            "Kembalian",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: change >= 0 ? Colors.green : Colors.red,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            change >= 0
                ? "Rp ${format(change)}"
                : "Uang kurang Rp ${format(change.abs())}",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: change >= 0 ? Colors.green : Colors.red,
            ),
          ),
          const Spacer(),

          /// CONFIRM BUTTON
          SizedBox(
            width: double.infinity,
            height: 54,
            child: _buildConfirmButton(false),
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmButton(bool isLandscape) {
    return ElevatedButton(
      onPressed: change >= 0
          ? () async {
              final cart = Provider.of<CartProvider>(context, listen: false);
              
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (ctx) => const Center(child: CircularProgressIndicator()),
              );

              final result = await cart.completeSale(paymentId: 1);

              if (context.mounted) Navigator.pop(context);

              if (result['success']) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Pembayaran berhasil!'), backgroundColor: Colors.green),
                  );
                  Navigator.pop(context, true);
                }
              } else {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(result['message'] ?? 'Pembayaran gagal'), backgroundColor: Colors.red),
                  );
                }
              }
            }
          : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: change >= 0 ? Colors.transparent : Colors.grey.shade400,
        elevation: 0,
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(isLandscape ? 10 : 14)),
      ),
      child: Ink(
        decoration: change >= 0
            ? BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFFFF6B9D), Color(0xFF5B4EC3)]),
                borderRadius: BorderRadius.all(Radius.circular(isLandscape ? 10 : 14)),
              )
            : const BoxDecoration(),
        child: Container(
          alignment: Alignment.center,
          child: Text(
            "CONFIRM PAYMENT",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: isLandscape ? 12 : 16,
            ),
          ),
        ),
      ),
    );
  }

  Widget quickButton(String label, VoidCallback onTap, bool isLandscape) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: isLandscape ? 36 : 48,
          margin: EdgeInsets.symmetric(horizontal: isLandscape ? 2 : 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(isLandscape ? 8 : 12),
            border: Border.all(color: const Color(0xFF5B4EC3)),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: isLandscape ? 11 : 15,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF5B4EC3),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
