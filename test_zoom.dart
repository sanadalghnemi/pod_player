// Simple test to verify zoom functionality
void main() {
  // Simulate zoom functionality
  double _videoZoomScale = 1;
  const double _minZoomScale = 0.5;
  const double _maxZoomScale = 3;
  const double _zoomStep = 0.25;

  void zoomIn() {
    if (_videoZoomScale < _maxZoomScale) {
      _videoZoomScale = (_videoZoomScale + _zoomStep).clamp(_minZoomScale, _maxZoomScale).toDouble();
      print('Zoomed in to: ${_videoZoomScale}x');
    } else {
      print('Already at maximum zoom: ${_videoZoomScale}x');
    }
  }

  void zoomOut() {
    if (_videoZoomScale > _minZoomScale) {
      _videoZoomScale = (_videoZoomScale - _zoomStep).clamp(_minZoomScale, _maxZoomScale).toDouble();
      print('Zoomed out to: ${_videoZoomScale}x');
    } else {
      print('Already at minimum zoom: ${_videoZoomScale}x');
    }
  }

  void resetZoom() {
    _videoZoomScale = 1;
    print('Reset zoom to: ${_videoZoomScale}x');
  }

  // Test zoom functionality
  print('=== Testing Zoom Functionality ===');
  print('Initial zoom: ${_videoZoomScale}x');
  
  // Test zoom in
  print('\n--- Testing Zoom In ---');
  for (int i = 0; i < 10; i++) {
    zoomIn();
  }
  
  // Test zoom out
  print('\n--- Testing Zoom Out ---');
  for (int i = 0; i < 15; i++) {
    zoomOut();
  }
  
  // Test reset
  print('\n--- Testing Reset ---');
  zoomIn();
  zoomIn();
  zoomIn();
  resetZoom();
  
  print('\n=== Zoom Test Complete ===');
}