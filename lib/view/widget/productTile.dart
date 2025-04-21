import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../models/productModel.dart';

class ProductTile extends StatefulWidget {
  final Product product;

  const ProductTile({super.key, required this.product});

  @override
  State<ProductTile> createState() => _ProductTileState();
}
//Toggle Check For Icon
bool isFavorite = false;


class _ProductTileState extends State<ProductTile> {
  @override
  Widget build(BuildContext context) {
    // Get screen size information
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;

    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate responsive dimensions
        final cardPadding = screenSize.width * 0.02;
        final fontScale = isSmallScreen ? 0.9 : 1.0;
        final imageHeight = constraints.maxWidth * (isSmallScreen ? 0.65 : 0.7);

        return Card(
          margin: EdgeInsets.all(cardPadding),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(cardPadding)),
          elevation: 4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // Product Image with favorite icon
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.vertical(
                        top: Radius.circular(cardPadding)),
                    child:

                        //Image
                        CachedNetworkImage(
                      imageUrl: widget.product.thumbnail,
                      height: imageHeight,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) => Container(
                        height: imageHeight,
                        color: Colors.grey[200],
                        child: const Icon(Icons.error),
                      ),
                    ),
                  ),

                  //Icon Button
                  Positioned(
                    top: cardPadding,
                    right: cardPadding,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          isFavorite = !isFavorite;
                        });
                      },
                      child: CircleAvatar(
                        radius: screenSize.width * 0.05,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.favorite,
                          color: isFavorite ? Colors.red : Colors.grey,
                          size: screenSize.width * 0.08,
                        ),
                      ),
                    ),
                  )
                ],
              ),

              // Content section
              Padding(
                padding: EdgeInsets.all(cardPadding * 1.5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // Title
                    Text(
                      widget.product.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16 * fontScale,
                      ),
                    ),

                    SizedBox(height: cardPadding),

                    // Price & Discount
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Text(
                            "\$${widget.product.price.toStringAsFixed(0)}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16 * fontScale,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(width: cardPadding),
                        Flexible(
                          child: Text(
                            "\$${(widget.product.price + 5).toStringAsFixed(2)}",
                            style: TextStyle(
                              decoration: TextDecoration.lineThrough,
                              color: Colors.grey,
                              fontSize: 14 * fontScale,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(width: cardPadding),
                        Text(
                          "15% OFF",
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 12 * fontScale,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: cardPadding),

                    // Rating
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: cardPadding * 0.75,
                            vertical: cardPadding * 0.5,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius:
                                BorderRadius.circular(cardPadding * 0.5),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.star,
                                size: 14 * fontScale,
                                color: Colors.white,
                              ),
                              SizedBox(width: cardPadding * 0.5),
                              Text(
                                widget.product.rating.toStringAsFixed(1),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12 * fontScale,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: cardPadding * 0.75),
                        Text(
                          "(${(widget.product.rating * 20).toInt()})",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12 * fontScale,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
