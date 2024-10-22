import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    // List of image URLs
    final List<String> imageUrls = [
      'https://cdn.pixabay.com/photo/2016/11/29/22/05/white-male-1871454_1280.jpg',
      'https://cdn.pixabay.com/photo/2017/09/05/19/17/crowd-2718834_960_720.jpg',
      'https://cdn.pixabay.com/photo/2017/02/20/08/47/males-2081830_1280.jpg',
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('AwaChama'),
        actions: [
          IconButton(
            icon: const Icon(Icons.login),
            tooltip: 'Sign In',
            onPressed: () {
              // Navigate to login screen
              Navigator.of(context).pushNamed('/login');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Image Slider with overlay and text
            CarouselSlider.builder(
              itemCount: imageUrls.length,
              itemBuilder: (BuildContext context, int index, int realIndex) {
                return Stack(
                  children: [
                    // Background Image
                    Container(
                      width: double.infinity,
                      child: Image.network(
                        imageUrls[index],
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 400,
                        loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                                  : null,
                            ),
                          );
                        },
                        errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                          return const Center(child: Text('Error loading image'));
                        },
                      ),
                    ),
                    // Dark Overlay for better contrast
                    Container(
                      width: double.infinity,
                      height: 400,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5), // Dark overlay
                      ),
                    ),
                    // Text Overlay
                    Positioned(
                      bottom: 50,
                      left: 20,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Empowering You',
                            style: TextStyle(
                              color: Colors.yellowAccent, // Changed text color for visibility
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(
                                  blurRadius: 10.0,
                                  color: Colors.black,
                                  offset: Offset(3.0, 3.0),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Join AwaChama for financial independence.',
                            style: TextStyle(
                              color: Colors.yellowAccent, // Changed text color for visibility
                              fontSize: 18,
                              shadows: [
                                Shadow(
                                  blurRadius: 10.0,
                                  color: Colors.black,
                                  offset: Offset(2.0, 2.0),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
              options: CarouselOptions(
                autoPlay: true,
                enlargeCenterPage: true,
                aspectRatio: 16 / 9,
                viewportFraction: 1.0,
                height: 400,
              ),
            ),
            // Text Description organized in Cards
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'About AwaChama',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black, // Dark text color
                    ),
                  ),
                  const SizedBox(height: 10),
                  
                  // Points arranged in Card form
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: const [
                          Icon(Icons.group, color: Colors.green),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Create and join Chamas to save and invest with trusted friends and family.',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: const [
                          Icon(Icons.money, color: Colors.green),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Easily integrate mobile money for deposits and withdrawals.',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: const [
                          Icon(Icons.forum, color: Colors.green),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Engage with group members in discussion forums to share ideas.',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Sign In Button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton.icon(
                onPressed: () {
                  // Navigate to login screen
                  Navigator.of(context).pushNamed('/login');
                },
                icon: const Icon(Icons.login),
                label: const Text('Sign In'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  textStyle: const TextStyle(fontSize: 16),
                  backgroundColor: Colors.green, // Custom color for button
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

