import 'package:flutter/material.dart';
import 'package:sliit_eats/helpers/colors.dart';
import 'package:sliit_eats/models/product.dart';
import 'package:sliit_eats/routes/app_routes.dart';
import 'package:sliit_eats/screens/product/components/product_order_modal.dart';
import 'package:sliit_eats/screens/widgets/custom_card.dart';

class ProductCard extends StatefulWidget {
  const ProductCard({Key? key, required this.thisProduct}) : super(key: key);
  final Product thisProduct;

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, AppRoutes.PRODUCT_DETAIL,
            arguments: {'product_id': widget.thisProduct.id});
      },
      child: CustomCard(
        color: AppColors.cardColor,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.4,
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Hero(
                  tag: widget.thisProduct.name,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: 90,
                    child: Image.network(
                      widget.thisProduct.image,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.thisProduct.name,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Rs. ${widget.thisProduct.unitPrice.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  Column(
                    children: widget.thisProduct.unitsLeft == 0
                        ? [
                            Text(
                              'OUT',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.red,
                              ),
                            ),
                            Text(
                              'of stock',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.red,
                              ),
                            ),
                          ]
                        : [
                            Text(
                              '${widget.thisProduct.unitsLeft}',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'left',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                  ),
                ],
              ),
              GestureDetector(
                onTap: () async {
                  if (widget.thisProduct.unitsLeft != 0)
                    return showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return ProductOrderModal(
                            productId: widget.thisProduct.id,
                            name: widget.thisProduct.name,
                            price: widget.thisProduct.unitPrice.toDouble(),
                            unitsLeft: widget.thisProduct.unitsLeft,
                          );
                        });
                },
                child: Container(
                  height: 30,
                  width: MediaQuery.of(context).size.width * 0.4,
                  decoration: BoxDecoration(
                    color: widget.thisProduct.unitsLeft == 0
                        ? Colors.grey[500]
                        : AppColors.primary,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Center(
                    child: Text(
                      'Reserve',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
