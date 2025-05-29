import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:markopi/service/iklan_service.dart';
import 'package:markopi/models/iklan.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';

class IklanBanner extends StatefulWidget {
  const IklanBanner({super.key});

  @override
  State<IklanBanner> createState() => _IklanBannerState();
}

class _IklanBannerState extends State<IklanBanner> {
  late Future<List<Iklan>> _iklanList;
  PageController _pageController = PageController(initialPage: 1000); // Start dari tengah untuk infinite scroll
  Timer? _timer;
  int _currentPage = 0;
  List<Iklan> iklanData = [];

  @override
  void initState() {
    super.initState();
    _iklanList = IklanService.getAllIklan();
    _loadData();
  }

  void _loadData() async {
    try {
      final data = await IklanService.getAllIklan();
      setState(() {
        iklanData = data;
        if (iklanData.isNotEmpty) {
          _startAutoScroll();
        }
      });
    } catch (e) {
      print('Error loading iklan data: $e');
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoScroll() {
    _timer?.cancel(); // Cancel existing timer
    if (iklanData.isEmpty) return;
    
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      if (_pageController.hasClients) {
        _pageController.nextPage(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  int _getRealIndex(int position) {
    if (iklanData.isEmpty) return 0;
    return position % iklanData.length;
  }

  Future<void> _launchURL(String url) async {
    if (url.isEmpty) return;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Temukkan Kebutuhan tanaman anda',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 160,
          child: FutureBuilder<List<Iklan>>(
            future: _iklanList,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('Tidak ada data iklan.'));
              } else {
                final iklanList = snapshot.data!;
                
                return Stack(
                  children: [
                    PageView.builder(
                      controller: _pageController,
                      onPageChanged: (index) {
                        setState(() {
                          _currentPage = _getRealIndex(index);
                        });
                      },
                      itemBuilder: (context, index) {
                        final realIndex = _getRealIndex(index);
                        final iklan = iklanList[realIndex];
                        
                        return GestureDetector(
                          onTap: () => _launchURL(iklan.link),
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(2, 4),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  iklan.gambar.isNotEmpty
                                      ? CachedNetworkImage(
                                          imageUrl: iklan.gambar,
                                          placeholder: (context, url) =>
                                              const Center(
                                                  child: CircularProgressIndicator()),
                                          errorWidget: (context, url, error) =>
                                              const Center(
                                                  child: Icon(Icons.broken_image,
                                                      size: 50)),
                                          fit: BoxFit.cover,
                                        )
                                      : const Center(
                                          child: Icon(Icons.store, size: 50)),
                                  Positioned(
                                    bottom: 0,
                                    left: 0,
                                    right: 0,
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      color: Colors.black.withOpacity(0.5),
                                      child: Text(
                                        iklan.judulIklan,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    // Indicator dots
                    Positioned(
                      bottom: 10,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: iklanList.asMap().entries.map((entry) {
                          return GestureDetector(
                            onTap: () {
                              // Calculate the target page to maintain infinite scroll
                              final currentPageIndex = _pageController.page?.round() ?? 1000;
                              final currentRealIndex = _getRealIndex(currentPageIndex);
                              final targetPage = currentPageIndex - currentRealIndex + entry.key;
                              
                              _pageController.animateToPage(
                                targetPage,
                                duration: Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            },
                            child: Container(
                              width: 8.0,
                              height: 8.0,
                              margin: EdgeInsets.symmetric(horizontal: 4.0),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _currentPage == entry.key
                                    ? Colors.white
                                    : Colors.white.withOpacity(0.4),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ],
    );
  }
}