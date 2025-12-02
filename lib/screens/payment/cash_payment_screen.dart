import 'package:flutter/material.dart';

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
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        title: const Text(
          "Cash Payment",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        elevation: 0,
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

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// TOTAL
            Text(
              "Total Belanja",
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey.shade700,
              ),
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
                quickButton("20.000", () => addQuickCash(20000)),
                quickButton("50.000", () => addQuickCash(50000)),
                quickButton("100.000", () => addQuickCash(100000)),
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
              child: ElevatedButton(
                onPressed: change >= 0
                    ? () {
                        Navigator.pop(context, true);
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      change >= 0 ? Colors.transparent : Colors.grey.shade400,
                  elevation: change >= 0 ? 0 : 0,
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Ink(
                  decoration: change >= 0
                      ? const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFFFF6B9D), Color(0xFF5B4EC3)],
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(14)),
                        )
                      : const BoxDecoration(),
                  child: Container(
                    alignment: Alignment.center,
                    child: const Text(
                      "CONFIRM PAYMENT",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget quickButton(String label, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 48,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF5B4EC3)),
          ),
          child: Center(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Color(0xFF5B4EC3),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
