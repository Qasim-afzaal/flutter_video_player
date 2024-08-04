# Flutter video player

A Flutter project demonstrating clean architecture principles to pick and display media files (images and videos) with thumbnail support and video playback.

## Project Structure

This project follows clean architecture principles with a well-organized structure:

- **Presentation Layer**: Contains the UI and handles user interactions.
- **Domain Layer**: Contains the business logic and use cases.
- **Data Layer**: Manages data sources such as API calls or local databases.

## Features

- Pick images and videos from the gallery.
- Display thumbnails for videos.
- Play videos in a dialog box.
- Clean architecture for better maintainability and scalability.

## Dependencies

- `image_picker: ^0.8.6`
- `permission_handler: ^11.3.0`
- `dotted_border: ^2.1.0`
- `video_player:`
- `wechat_assets_picker: ^9.0.3`
- `flutter_bloc: ^8.1.1`

## Getting Started

### Prerequisites

- Flutter SDK: [Install Flutter](https://flutter.dev/docs/get-started/install)
- Dart SDK

### Installation

1. Clone the repository:

```bash
git clone https://github.com/your_username/media_picker_clean_architecture.git
cd media_picker_clean_architecture
